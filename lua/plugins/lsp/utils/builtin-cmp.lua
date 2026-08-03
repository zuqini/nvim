-- Neovim's own completion under 'autocomplete' (see |ins-autocompletion|): a
-- path source, zsnip's snippets, core's buffer scanners and the LSP omnifunc,
-- fuzzy-ranked into one menu. Selected with vim.g.cmp_engine = 'builtin'.
-- Design rationale is in .claude/review-decisions.md.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

local candidates = require 'plugins.lsp.utils.cmp-candidates'
local zsnip_complete = require 'zsnip.complete'

local NAME = 'builtin-cmp'
local SNIPPET_LIMIT = 30

local M = {}

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

local word_chars = vim.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '')

---Widening triggers to every letter is what makes autotrigger re-ask on a plain
---keyword. Idempotent: a second call re-reads the widened list and dedups.
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

---'autocomplete' forces 'noselect', so 'preselect' is the only thing putting an
---item under the cursor for <cr>. 'refresh' re-runs the source as the leading
---text changes; without it matches are only ever filtered down.
---@param items lsp.CompletionItem[]
---@return table
local function reply(items)
  local words = {}
  for i, item in ipairs(items) do
    -- The label, never insertText: each source anchors at the run it replaces.
    words[i] = { word = item.label, kind = Kind[item.kind], preselect = i == 1 and 1 or nil }
  end
  return { words = words, refresh = 'always' }
end

---@param findstart integer
function M.path_source(findstart)
  if findstart == 1 then
    -- -2, not -3: -3 leaves completion mode, taking the other sources with it.
    return candidates.path_start() or -2
  end
  return reply(candidates.path() or {})
end

---@param keys string
local function feedkeys(keys)
  api.nvim_feedkeys(vim.keycode(keys), 'n', true)
end

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

---The info window cannot be focused -- reaching it means leaving insert mode,
---which dismisses the menu. Scroll it where it stands instead. complete_info()
---takes no 'what' filter here: the filter silently drops 'preview_winid'.
---@param keys string
---@return boolean
local function scroll_info(keys)
  local win = vim.fn.complete_info().preview_winid
  if not win or win == 0 or not api.nvim_win_is_valid(win) then
    return false
  end
  api.nvim_win_call(win, function()
    vim.cmd('normal! ' .. vim.keycode(keys))
  end)
  return true
end

---Core owns triggering; this only steps through a menu already up, or a snippet.
local function complete()
  if not pumvisible() and vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    feedkeys '<C-n>'
  end
end

---An unconditional <Tab> would swallow every indent, since this attaches to
---nearly every buffer. The mode check matters: <C-n> is a no-op in the select
---mode a placeholder puts you in, leaving <Tab> dead at the last tabstop.
local function supertab()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])
  if pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  elseif vim.fn.mode() == 'i' and vim.fn.matchstr(before, '\\k*$') ~= '' then
    feedkeys '<C-n>'
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

---Gated on a real selection, not on the menu being up, or <cr> would swallow the
---newline. nvim-autopairs owns <cr> globally and this map is buffer-local, so the
---fallback hands it back -- in real termcodes, as autopairs_cr() returns, since
---replace_keycodes would insert them literally.
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
  -- <C-e> cancels the menu and *stays* in insert mode. The cost is that <esc> no
  -- longer leaves insert mode while a menu is open; that takes a second one.
  keymap('i', '<esc>', function()
    return pumvisible() and '<C-e>' or '<esc>'
  end, { expr = true })

  keymap('i', '<C-n>', complete, { desc = 'Trigger/select next completion' })
  -- Not <C-d>/<C-u>: those are i_CTRL-D and i_CTRL-U, dedent and kill-line.
  keymap('i', '<C-f>', function()
    if not scroll_info '<C-d>' then
      feedkeys '<C-f>'
    end
  end, { desc = 'Scroll documentation down' })
  keymap('i', '<C-b>', function()
    if not scroll_info '<C-u>' then
      feedkeys '<C-b>'
    end
  end, { desc = 'Scroll documentation up' })
  keymap({ 'i', 's' }, '<Tab>', supertab)
  keymap({ 'i', 's' }, '<S-Tab>', shifttab)

  -- Inside a snippet, backspace removes the placeholder.
  keymap('s', '<BS>', '<C-o>s')
end

-- Order is the time-slicing priority. Only '.', 'w' and 'b' carry a '^{count}':
-- the path and snippet sources truncate before core ever sees a list.
local complete_option = table.concat({
  [[Fv:lua.require'plugins.lsp.utils.builtin-cmp'.path_source]],
  zsnip_complete.source(),
  '.^100',
  'w^50',
  'b^50',
}, ',')

---The single writer of 'complete'. Derives the whole value from current state,
---because BufEnter and LspAttach reach it in either order.
---@param bufnr integer
local function set_complete(bufnr)
  local cpt = complete_option
  -- 'o' is the LSP omnifunc, only worth listing once a server can answer.
  if next(vim.lsp.get_clients { bufnr = bufnr, method = 'textDocument/completion' }) then
    cpt = cpt .. ',o'
  end
  vim.bo[bufnr].complete = cpt
end

---The one place deciding which buffers this engine owns, reached from BufEnter
---and both LSP hooks. Scheduled because scratch buffers are still buftype '' at
---BufEnter, and a detaching client is still attached while LspDetach runs.
---@param bufnr integer
local function attach(bufnr)
  vim.schedule(function()
    if not api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= '' then
      return
    end
    -- Buffer-local so a prompt or terminal buffer keeps core's default menu.
    vim.bo[bufnr].autocomplete = true
    set_complete(bufnr)
    keymaps(bufnr)
  end)
end

M.enable = function()
  set_pum_kind_hl()
  api.nvim_create_autocmd('ColorScheme', {
    group = api.nvim_create_augroup(NAME .. '-hl', {}),
    callback = set_pum_kind_hl,
  })

  -- `complete = false` stops enable() appending a second, uncapped copy of the
  -- source to the option set_complete owns. No detail: the popup previews the
  -- expanded body instead, which beats friendly-snippets' terse descriptions.
  zsnip_complete.enable {
    complete = false,
    limit = SNIPPET_LIMIT,
    documentation = false,
  }

  vim.go.autocomplete = false
  -- Sources only run once the delay elapses, so this also bounds how often the
  -- path listing and the server are asked. It suppresses nothing while typing
  -- faster than the value: measured 10 keystrokes 120ms apart, 0 and 60 both
  -- ran the source 10 times, 150 ran it once. Raise it past your own gap.
  vim.o.autocompletedelay = 200
  -- 'noinsert' is the one flag 'autocomplete' ignores and is still load-bearing:
  -- vim.lsp.completion calls vim.fn.complete() itself and that path honours it.
  -- Without it 'preselect' inserts the server's first item, so `vim.` becomes
  -- `vim.F` and every later keystroke appends to the wrong word.
  vim.go.completeopt = 'fuzzy,menuone,popup,noinsert,preselect'
  -- Autotriggering everywhere would report 'match 1 of 9' on nearly every key.
  vim.opt.shortmess:append 'c'

  api.nvim_create_autocmd('BufEnter', {
    group = api.nvim_create_augroup(NAME, {}),
    callback = function(args)
      attach(args.buf)
    end,
  })
  -- Buffers opened before this ran never see BufEnter.
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      attach(buf)
    end
  end
end

---Both delivery paths, because each covers what the other misses: 'o' merges
---server items into the ranked menu but asks once per cycle, and autotrigger
---re-asks per trigger character but delivers nothing for a plain keyword.
---@param opts { client: vim.lsp.Client, bufnr: integer }
M.setup = function(opts)
  local client, bufnr = opts.client, opts.bufnr
  local provider = client.server_capabilities.completionProvider
  if not provider or not client:supports_method('textDocument/completion') then
    return
  end

  provider.triggerCharacters = trigger_chars(client)
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  attach(bufnr)
end

---The buffer may have just lost its last completion provider, leaving 'o' with
---nothing to answer.
M.detach = attach

return M
