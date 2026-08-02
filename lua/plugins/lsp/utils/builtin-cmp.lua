-- Snippet, buffer word and path completion as 'complete' functions under
-- 'autocomplete' (see |ins-autocompletion|), with the LSP omnifunc alongside
-- them via the 'o' flag M.setup appends. Selected with
-- vim.g.cmp_engine = 'builtin'.
--
-- The design principle, arrived at the long way round: do not work against what
-- core already does. Each 'F' source returns its own start column, so the path
-- source anchors at the path segment and the snippet source at a trigger built
-- only from punctuation. Core dedups identical words across sources, fuzzy-ranks
-- the union, applies per-source '^{count}' limits and time-slices slow sources.
-- All of that used to be hand-rolled here against vim.fn.complete(), which has
-- exactly one start column for the entire menu.
--
-- Real servers share the menu: typing `l` in this file gives one popup holding
-- Field/Function/Keyword/Variable from lua_ls next to a dozen snippets and the
-- buffer's words, and it stays that way through `lo`, `loc`, `loca`. That merge is
-- neovim PR #35346, which seeds vim.lsp.completion's match list from
-- complete_info() so each response rebuilds the union instead of replacing it.
--
-- The seam is neovim#32428. vim.fn.complete(), which vim.lsp.completion calls
-- when a response lands, is destructive -- set_completion() in insexpand.c opens
-- with ins_compl_prep(), ins_compl_clear(), ins_compl_free() and then takes
-- ctrl_x_mode = CTRL_X_EVAL. From that point the 'complete' sources are not
-- consulted again for the cycle, so their items are preserved but never
-- recomputed. Mostly that is harmless, since fuzzy matching only narrows and
-- anything matching a longer prefix already matched the shorter one. What it
-- does cost is a source that legitimately returned nothing at the start of the
-- cycle -- the word sources after a '.', where the keyword is empty -- staying
-- silent for the rest of the word. Arguably right: after a '.' or ':' the
-- server's own members are what you wanted.
--
-- The server half does not have that problem, because M.setup runs autotrigger
-- as well and it re-asks per keystroke. That is why both are on; see the note
-- there, and do not remove one thinking it is redundant.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

local candidates = require 'plugins.lsp.utils.cmp-candidates'
local zsnip = require 'zsnip'

local NAME = 'builtin-cmp'
-- 'complete' reaches the source functions through v:lua, so they have to hang
-- off a global. Dotted lookup resolves there, which keeps the three out of _G.
local NS = 'ZCmpBuiltin'

local function set_pum_kind_hl()
  local special = api.nvim_get_hl(0, { name = 'Special', link = false })
  if not special.fg then
    return
  end
  local pmenu = api.nvim_get_hl(0, { name = 'Pmenu', link = false })
  local pmenu_sel = api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
  api.nvim_set_hl(0, 'PmenuKind', { fg = special.fg, bg = pmenu.bg })
  api.nvim_set_hl(0, 'PmenuKindSel', { fg = special.fg, bg = pmenu_sel.bg or pmenu.bg })
end

local word_chars = {}
for i = string.byte 'a', string.byte 'z' do
  word_chars[#word_chars + 1] = string.char(i)
  word_chars[#word_chars + 1] = string.char(i):upper()
end

---@param client vim.lsp.Client
---@return string[]
local function trigger_chars(client)
  local declared = vim.tbl_get(client.server_capabilities, 'completionProvider', 'triggerCharacters')
  local seen, chars = {}, {}
  for _, char in ipairs(vim.list_extend(vim.list_extend({}, declared or {}), word_chars)) do
    if not seen[char] then
      seen[char] = true
      chars[#chars + 1] = char
    end
  end
  return chars
end

---'autocomplete' forces 'noselect' on, which would leave <cr> with nothing to
---accept. A "preselect" item overrides that and, unlike 'preinsert' -- the
---other documented way out -- does not cost the fuzzy sort: it navigates to the
---marked item instead of pinning the menu to index 1. Every source marks its
---own first item, so whichever survives the sort highest is the one selected.
---Verified: <cr> over a menu accepts the highlighted item.
---@param items lsp.CompletionItem[]
---@param snippet boolean? bodies go to CompleteDone rather than into the buffer
---@return table[] complete-items
local function complete_items(items, snippet)
  local out = {}
  for i, item in ipairs(items) do
    out[i] = {
      -- The label, never insertText: each source anchors at the run its item
      -- replaces in full, and for a snippet insertText is the body.
      word = item.label,
      kind = Kind[item.kind],
      preselect = i == 1 and 1 or nil,
      user_data = snippet and { zcmp = { body = item.insertText } } or nil,
    }
  end
  return out
end

---@param base string the text between this source's own anchor and the cursor
---@return CmpContext
local function context(base)
  local ctx = candidates.context()
  ctx.keyword = base
  return ctx
end

---'refresh' is what makes a source re-run as the leading text changes; without
---it the first call's matches are filtered down and never replaced, so a source
---whose anchor sits before the keyword run goes stale the moment you type.
---@param items table[]
---@return table
local function reply(items)
  return { words = items, refresh = 'always' }
end

local sources = {}
_G[NS] = sources

---Anchored at the segment after the last '/', with no '\k' constraint -- the
---capability vim.fn.complete() cannot express, since one start column has to
---serve every item in the menu.
---@param findstart integer
---@param base string
function sources.path(findstart, base)
  if findstart == 1 then
    local ctx = candidates.context()
    local dir, segment = candidates.path_split(ctx.before)
    if not dir or not segment then
      -- -2, not -3: -3 leaves completion mode, which would take the other two
      -- sources down with it.
      return -2
    end
    return #ctx.before - #segment
  end
  return reply(complete_items(candidates.path(context(base)) or {}))
end

---Anchored at the whole trigger, which is how a trigger built only from
---punctuation (pkl's '->') becomes reachable at all.
---@param findstart integer
---@param base string
function sources.snippet(findstart, base)
  if findstart == 1 then
    local ctx = candidates.context()
    local matched = zsnip.match()
    -- The longer of the two. A trigger that starts with a keyword character has
    -- to start a word, so it can only ever reach further back than '\k*$'.
    local len = math.max(#ctx.keyword, matched and #matched.prefix or 0)
    return #ctx.before - len
  end
  return reply(complete_items(candidates.snippet(context(base)), true))
end

---@param findstart integer
---@param base string
function sources.buffer(findstart, base)
  if findstart == 1 then
    local ctx = candidates.context()
    return #ctx.before - #ctx.keyword
  end
  local items = candidates.buffer(context(base), function()
    return vim.fn.complete_check() ~= 0
  end)
  return reply(complete_items(items))
end

---The snippet source puts the trigger in the buffer, since that is all
---'complete' knows how to insert, and the body rides along in user_data.
local function expand_completed_snippet()
  local item = vim.v.completed_item
  local body = vim.tbl_get(item or {}, 'user_data', 'zcmp', 'body')
  if not body then
    return
  end

  local row, col = unpack(api.nvim_win_get_cursor(0))
  local from = col - #item.word
  -- The trigger is meant to be sitting right behind the cursor. Anything else
  -- means something moved it between the accept and here, and deleting that
  -- range blind would eat real text.
  if from < 0 or api.nvim_buf_get_text(0, row - 1, from, row - 1, col, {})[1] ~= item.word then
    return
  end
  api.nvim_buf_set_text(0, row - 1, from, row - 1, col, {})
  vim.snippet.expand(body)
end

---@param keys string
local function feedkeys(keys)
  api.nvim_feedkeys(vim.keycode(keys), 'n', true)
end

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

---Core owns triggering here, so there is nothing to ask for -- the only job
---left is stepping through a menu that is already up, or through a snippet.
local function complete()
  if not pumvisible() and vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    feedkeys '<C-n>'
  end
end

---An unconditional <Tab> would swallow every indent, since this attaches to
---nearly every buffer. Only a word under the cursor asks for a menu.
local function supertab()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])
  if pumvisible() or vim.snippet.active { direction = 1 } or vim.fn.matchstr(before, '\\k*$') ~= '' then
    complete()
  else
    feedkeys '<Tab>'
  end
end

local function shifttab()
  if pumvisible() then
    feedkeys '<C-p>'
  elseif vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  else
    feedkeys '<S-Tab>'
  end
end

---Gated on a real selection rather than on the menu being up: 'autocomplete'
---sets 'noselect', and only the preselect marking above puts anything under the
---cursor. Without the gate <cr> would swallow the newline and insert nothing.
---
---nvim-autopairs owns <cr> globally and this map is buffer-local, so the
---fallback has to hand it back. Returns real termcodes, since autopairs_cr()
---does -- feeding those through replace_keycodes a second time inserts them as
---literal text.
---@return string
local function enter()
  if pumvisible() and vim.fn.complete_info({ 'selected' }).selected >= 0 then
    return vim.keycode '<C-y>'
  end
  local ok, autopairs = pcall(require, 'nvim-autopairs')
  return ok and autopairs.autopairs_cr() or vim.keycode '<cr>'
end

---@param bufnr integer
local function keymaps(bufnr)
  local function keymap(mode, lhs, rhs, key_opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('error', key_opts or {}, { buffer = bufnr }))
  end

  keymap('i', '<cr>', enter, { expr = true, replace_keycodes = false })
  -- <C-e> cancels the menu and *stays* in insert mode, so this dismisses a
  -- suggestion without interrupting typing. The cost is that <esc> no longer
  -- leaves insert mode while a menu is open; that takes a second one.
  keymap('i', '<esc>', function()
    return pumvisible() and '<C-e>' or '<esc>'
  end, { expr = true })

  keymap('i', '<C-n>', complete, { desc = 'Trigger/select next completion' })
  keymap({ 'i', 's' }, '<Tab>', supertab)
  keymap({ 'i', 's' }, '<S-Tab>', shifttab)

  -- Inside a snippet, backspace removes the placeholder.
  keymap('s', '<BS>', '<C-o>s')
end

local complete_option = table.concat({
  ('Fv:lua.%s.path^%d'):format(NS, candidates.limits.path),
  ('Fv:lua.%s.snippet^%d'):format(NS, candidates.limits.snippet),
  ('Fv:lua.%s.buffer^%d'):format(NS, candidates.limits.buffer),
}, ',')

---Terminal, quickfix and plugin scratch buffers are still buftype '' at
---BufEnter and only settle afterwards, so decide on the next tick.
---@param bufnr integer
local function attach(bufnr)
  vim.schedule(function()
    if not api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= '' then
      return
    end
    -- Buffer-local, both of them: 'autocomplete' is left off globally so a
    -- prompt or terminal buffer does not start popping up core's own
    -- '.,w,b,u,t' menu, which is the default 'complete' we never replaced there.
    vim.bo[bufnr].autocomplete = true
    vim.bo[bufnr].complete = complete_option
    keymaps(bufnr)
  end)
end

local M = {}

M.enable = function()
  set_pum_kind_hl()
  api.nvim_create_autocmd('ColorScheme', {
    group = api.nvim_create_augroup(NAME .. '-hl', {}),
    callback = set_pum_kind_hl,
  })

  vim.go.autocomplete = false
  -- Explicit and at the default: the knob that decides whether the menu chases
  -- every keystroke, and the one to reach for first if native feels noisy.
  vim.o.autocompletedelay = 0
  -- Under 'autocomplete' only fuzzy, longest, popup, preinsert, preselect and
  -- preview still apply -- 'nosort' in particular is inert, so the source order
  -- in 'complete' is a time-slicing priority, not the ranking. 'preinsert' is
  -- the other way to defeat the forced 'noselect', but it requires 'fuzzy' to
  -- be unset, and our candidates are fuzzy-matched before core ever sees them.
  --
  -- 'noinsert' is the exception to that list, and leaving it out cost a day.
  -- It is inert for the 'autocomplete' pipeline, but vim.lsp.completion does
  -- not go through that pipeline -- it calls vim.fn.complete() itself, and that
  -- path still honours it. Without it, 'preselect' selects the server's first
  -- item and complete() *inserts* it: `vim.` becomes `vim.F`, every later
  -- keystroke appends to the wrong word, and the menu is empty from then on.
  -- Reads exactly like a substrate-level race between the two menus. It isn't.
  vim.o.completeopt = 'fuzzy,menuone,popup,noinsert,preselect'
  -- Autotriggering in every buffer means ins-completion would otherwise report
  -- 'match 1 of 9' / 'Pattern not found' on nearly every keystroke.
  vim.opt.shortmess:append 'c'

  local group = api.nvim_create_augroup(NAME, {})
  api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args)
      attach(args.buf)
    end,
  })
  -- BufUnload too: an unloaded buffer keeps its entry otherwise, and its
  -- contents are re-read from disk if it comes back.
  api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout', 'BufUnload' }, {
    group = group,
    callback = function(args)
      candidates.forget(args.buf)
    end,
  })
  api.nvim_create_autocmd('CompleteDone', {
    group = group,
    callback = expand_completed_snippet,
  })

  -- Buffers opened before this ran never see BufEnter.
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      attach(buf)
    end
  end
end

---Real servers only. 'o' in 'complete' puts the LSP omnifunc *inside* the
---autocomplete cycle, which is the only arrangement where a server's items and
---everything else end up in one ranked menu. See the header for the seam that
---leaves, and the note below for why autotrigger is on as well.
---
---Upstream, in case any of this comes loose: neovim#35257 is non-merging, fixed
---by PR #35346 (October 2025) with the complete_info() reconstruction that makes
---the merge work at all; neovim#32428 is the open one this config works around,
---blocked on an append primitive that Vim declined in vim/vim#16662.
---@param opts { client: vim.lsp.Client, bufnr: integer }
M.setup = function(opts)
  local client, bufnr = opts.client, opts.bufnr
  local provider = client.server_capabilities.completionProvider
  if not provider or not client:supports_method('textDocument/completion') then
    return
  end

  provider.triggerCharacters = trigger_chars(client)
  -- Both delivery paths, deliberately, because each covers what the other
  -- misses and they are not alternatives.
  --
  -- 'o' in 'complete' runs the LSP omnifunc inside the autocomplete cycle, which
  -- is what puts server items in the same ranked menu as ours -- neovim#35257,
  -- fixed by PR #35346, which seeds trigger()'s match list from complete_info()
  -- so each response rebuilds the union instead of replacing it. On its own it
  -- asks the server once per cycle: after `vim.` you get whatever came back for
  -- the bare prefix, and typing `tbl_g` never fetches `tbl_get`, because
  -- vim.fn.complete() has taken the cycle and the 'complete' sources are done
  -- (neovim#32428).
  --
  -- autotrigger re-asks on each of the trigger characters widened above, which
  -- is what fetches it -- `vim.tbl_g` comes back with 21 items including
  -- `tbl_get`. On its own it delivers nothing for a plain keyword, so the menu
  -- has no server items at all until you type a separator.
  --
  -- Together: measured, `l` gives Field/Function/Keyword/Variable beside 12
  -- snippets and 172 buffer words, and `vim.tbl_g` still finds `tbl_get`.
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  if not vim.bo[bufnr].complete:find(',o', 1, true) then
    vim.bo[bufnr].complete = vim.bo[bufnr].complete .. ',o'
  end
end

return M
