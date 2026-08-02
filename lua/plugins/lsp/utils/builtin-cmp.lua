-- Colorschemes tend to link PmenuKind to Pmenu, leaving the kind column
-- indistinguishable from the label. Noice used to color it via Special.
local function set_pum_kind_hl()
  local special = vim.api.nvim_get_hl(0, { name = 'Special', link = false })
  local pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
  local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
  vim.api.nvim_set_hl(0, 'PmenuKind', { fg = special.fg, bg = pmenu.bg })
  vim.api.nvim_set_hl(0, 'PmenuKindSel', { fg = special.fg, bg = pmenu_sel.bg or pmenu.bg })
end

local sources = require 'plugins.lsp.utils.cmp-sources'

---LSP, then our paths and snippets, then plain words. Servers suggest bare
---document words too (kind Text); at LSP priority they bury everything else.
---@param item table complete-item
---@return integer
local function source_rank(item)
  if item.kind == 'Text' then
    return 3
  end
  return sources.owns(item) and 2 or 1
end

---table.sort is unstable: without a real tiebreaker the server's own ranking
---gets shuffled.
---@param item table complete-item
---@return string
local function sort_key(item)
  local lsp_item = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'completion_item') or {}
  return lsp_item.sortText or lsp_item.label or item.word or ''
end

---table.sort calls the comparator O(n log n) times over the whole merged menu
---on every keystroke, so both halves are derived once per item instead. Weak
---keys: the items are thrown away with each response.
local ordering = setmetatable({}, { __mode = 'k' })

---@param item table complete-item
---@return { rank: integer, key: string }
local function order_of(item)
  local cached = ordering[item]
  if not cached then
    cached = { rank = source_rank(item), key = sort_key(item) }
    ordering[item] = cached
  end
  return cached
end

---@param a table
---@param b table
---@return boolean
local function compare(a, b)
  local order_a, order_b = order_of(a), order_of(b)
  if order_a.rank ~= order_b.rank then
    return order_a.rank < order_b.rank
  end
  return order_a.key < order_b.key
end

local word_chars = {}
for i = string.byte 'a', string.byte 'z' do
  word_chars[#word_chars + 1] = string.char(i)
  word_chars[#word_chars + 1] = string.char(i):upper()
end

---Letters plus whatever the server asked for. Space, punctuation and digits
---would trigger on an empty or meaningless prefix, and a lone '_' (the throwaway
---in `for _, v in ipairs(t)`) fuzzy-matches every snake_case name in scope.
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

---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), 'n', true)
end

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

local function complete()
  if pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    vim.lsp.completion.get()
  end
end

---cmp-sources attaches to nearly every buffer, so an unconditional <Tab> here
---would swallow every indent. Only a word under the cursor asks for a menu.
local function supertab()
  local before = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2])
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

---nvim-autopairs owns <cr> globally; our buffer-local map would otherwise
---shadow it everywhere cmp-sources attaches, which is nearly every buffer.
---Returns real termcodes, since autopairs_cr() does -- feeding those through
---replace_keycodes a second time inserts them as literal text.
---@return string
local function enter()
  if pumvisible() then
    return vim.keycode '<C-y>'
  end
  local ok, autopairs = pcall(require, 'nvim-autopairs')
  return ok and autopairs.autopairs_cr() or vim.keycode '<cr>'
end

local M = {}

M.enable = function()
  set_pum_kind_hl()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('builtin-cmp', {}),
    callback = set_pum_kind_hl,
  })
  -- Without 'nosort', fuzzy score re-sorts everything and source_rank is lost.
  vim.o.completeopt = 'fuzzy,nosort,menuone,popup,noinsert'
  -- Autotriggering in every buffer means ins-completion would otherwise report
  -- 'match 1 of 9' / 'Pattern not found' on nearly every keystroke.
  vim.opt.shortmess:append 'c'
end

---@param opts { client: vim.lsp.Client, bufnr: integer }
M.setup = function(opts)
  local client, bufnr = opts.client, opts.bufnr
  local provider = client.server_capabilities.completionProvider
  if not provider or not client:supports_method('textDocument/completion') then
    return
  end

  provider.triggerCharacters = trigger_chars(client)
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true, cmp = compare })

  local function keymap(mode, lhs, rhs, key_opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('error', key_opts or {}, { buffer = bufnr }))
  end

  keymap('i', '<cr>', enter, { expr = true, replace_keycodes = false })
  keymap('i', '<esc>', function()
    return pumvisible() and '<C-e>' or '<esc>'
  end, { expr = true })

  keymap('i', '<C-n>', supertab, { desc = 'Trigger/select next completion' })
  keymap({ 'i', 's' }, '<Tab>', supertab)
  keymap({ 'i', 's' }, '<S-Tab>', shifttab)

  -- Inside a snippet, backspace removes the placeholder.
  keymap('s', '<BS>', '<C-o>s')
end

return M
