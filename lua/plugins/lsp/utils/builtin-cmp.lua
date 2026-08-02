-- Buffer word and path completion as 'complete' functions under 'autocomplete'
-- (see |ins-autocompletion|), alongside zsnip's snippet source and the LSP
-- omnifunc, which M.setup adds through the 'o' flag. Selected with
-- vim.g.cmp_engine = 'builtin'.
--
-- The design principle, arrived at the long way round: do not work against what
-- core already does. Each 'F' source returns its own start column, so the path
-- source anchors at the path segment and zsnip's at a trigger built only from
-- punctuation. Core dedups identical words across sources, fuzzy-ranks the
-- union, applies per-source '^{count}' limits and time-slices slow sources. All
-- of that used to be hand-rolled here against vim.fn.complete(), which has
-- exactly one start column for the entire menu.
--
-- The seam is neovim#32428. vim.fn.complete(), which vim.lsp.completion calls
-- when a response lands, is destructive: from that point the 'complete' sources
-- are not consulted again for the cycle, so their items are preserved but never
-- recomputed. Mostly that is harmless, since fuzzy matching only narrows and
-- anything matching a longer prefix already matched the shorter one. What it
-- does cost is a source that legitimately returned nothing at the start of the
-- cycle -- the word sources after a '.', where the keyword is empty -- staying
-- silent for the rest of the word. Arguably right: after a '.' or ':' the
-- server's own members are what you wanted.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

local candidates = require 'plugins.lsp.utils.cmp-candidates'
local zsnip_complete = require 'zsnip.complete'

local NAME = 'builtin-cmp'
-- 'complete' reaches the source functions through v:lua, so they have to hang
-- off a global. Dotted lookup resolves there, which keeps the two out of _G.
local NS = 'ZCmpBuiltin'

local SNIPPET_LIMIT = 30

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
---accept. A "preselect" item overrides that, and every source marks its own
---first item, so whichever survives the sort highest is the one selected.
---
---'refresh' is what makes a source re-run as the leading text changes; without
---it the first call's matches are filtered down and never replaced, so a source
---whose anchor sits before the keyword run goes stale the moment you type.
---@param items lsp.CompletionItem[]
---@return table
local function reply(items)
  local words = {}
  for i, item in ipairs(items) do
    -- The label, never insertText: each source anchors at the run its item
    -- replaces in full.
    words[i] = { word = item.label, kind = Kind[item.kind], preselect = i == 1 and 1 or nil }
  end
  return { words = words, refresh = 'always' }
end

local sources = {}
_G[NS] = sources

---Anchored at the segment after the last '/', with no '\k' constraint.
---@param findstart integer
---@param base string
function sources.path(findstart, base)
  if findstart == 1 then
    local ctx = candidates.context()
    local dir, segment = candidates.path_split(ctx.before)
    if not dir or not segment then
      -- -2, not -3: -3 leaves completion mode, which would take the other
      -- sources down with it.
      return -2
    end
    return #ctx.before - #segment
  end
  return reply(candidates.path(candidates.context(base)) or {})
end

---@param findstart integer
---@param base string
function sources.buffer(findstart, base)
  if findstart == 1 then
    local ctx = candidates.context()
    return #ctx.before - #ctx.keyword
  end
  local items = candidates.buffer(candidates.context(base), function()
    return vim.fn.complete_check() ~= 0
  end)
  return reply(items)
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

-- No '^{count}' caps: every source truncates before core sees it, so a cap
-- could only ever restate a limit that already held. Source order still
-- matters -- it is the time-slicing priority.
local complete_option = table.concat({
  ('Fv:lua.%s.path'):format(NS),
  zsnip_complete.source(),
  ('Fv:lua.%s.buffer'):format(NS),
}, ',')

---The single writer of 'complete'. Both BufEnter and LspAttach reach it, in
---either order -- a warm client makes LspAttach fire before the scheduled
---attach(), a cold one after -- so it derives the whole value from current state
---rather than appending to whatever is there.
---@param bufnr integer
local function set_complete(bufnr)
  local cpt = complete_option
  -- 'o' is the LSP omnifunc, which vim.lsp.completion.enable installs per
  -- client, so it is only worth listing once a server can actually answer.
  if next(vim.lsp.get_clients { bufnr = bufnr, method = 'textDocument/completion' }) then
    cpt = cpt .. ',o'
  end
  vim.bo[bufnr].complete = cpt
end

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
    set_complete(bufnr)
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

  -- zsnip's own 'complete' source, already named in complete_option above. It
  -- expands what is accepted from it through its own CompleteDone handler;
  -- `complete = false` stops enable() appending a second, uncapped copy to the
  -- option set_complete owns.
  zsnip_complete.enable {
    complete = false,
    limit = SNIPPET_LIMIT,
    -- No detail on purpose: the popup previews the expanded body instead, which
    -- beats friendly-snippets' terse descriptions.
    documentation = false,
  }

  vim.go.autocomplete = false
  -- Explicit and at the default: the knob that decides whether the menu chases
  -- every keystroke, and the one to reach for first if native feels noisy.
  vim.o.autocompletedelay = 0
  -- Under 'autocomplete' only fuzzy, longest, popup, preinsert, preselect and
  -- preview still apply -- 'nosort' in particular is inert, so the source order
  -- in 'complete' is a time-slicing priority, not the ranking.
  --
  -- 'noinsert' is the exception, and it is not inert here. It does nothing for
  -- the 'autocomplete' pipeline, but vim.lsp.completion does not go through that
  -- pipeline -- it calls vim.fn.complete() itself, and that path still honours
  -- it. Without it 'preselect' selects the server's first item and complete()
  -- *inserts* it: `vim.` becomes `vim.F`, every later keystroke appends to the
  -- wrong word, and the menu is empty from then on.
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

  -- Buffers opened before this ran never see BufEnter.
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      attach(buf)
    end
  end
end

---Real servers only. 'o' in 'complete' puts the LSP omnifunc *inside* the
---autocomplete cycle, which is the only arrangement where a server's items and
---everything else end up in one ranked menu -- neovim#35257, fixed by PR #35346.
---See the header for the seam that leaves.
---@param opts { client: vim.lsp.Client, bufnr: integer }
M.setup = function(opts)
  local client, bufnr = opts.client, opts.bufnr
  local provider = client.server_capabilities.completionProvider
  if not provider or not client:supports_method('textDocument/completion') then
    return
  end

  provider.triggerCharacters = trigger_chars(client)
  -- Both delivery paths, deliberately, because each covers what the other
  -- misses: 'o' merges server items into the ranked menu but asks once per
  -- cycle, and autotrigger re-asks on every widened trigger character but
  -- delivers nothing for a plain keyword. Measurements in review-decisions.md.
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  set_complete(bufnr)
end

---The buffer may have just lost its last completion provider, leaving 'o' with
---nothing to answer. Scheduled because the detaching client is still attached
---while LspDetach runs.
---@param bufnr integer
M.detach = function(bufnr)
  vim.schedule(function()
    if api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == '' then
      set_complete(bufnr)
    end
  end)
end

return M
