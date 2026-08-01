-- Colorschemes tend to link PmenuKind to Pmenu, leaving the kind column
-- indistinguishable from the label. Noice used to color it via Special.
local function set_pum_kind_hl()
  local special = vim.api.nvim_get_hl(0, { name = 'Special', link = false })
  local pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
  local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
  vim.api.nvim_set_hl(0, 'PmenuKind', { fg = special.fg, bg = pmenu.bg })
  vim.api.nvim_set_hl(0, 'PmenuKindSel', { fg = special.fg, bg = pmenu_sel.bg or pmenu.bg })
end

set_pum_kind_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_pum_kind_hl })

---For replacing certain <C-x>... keymaps.
---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

local function supertab()
  if pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    if next(vim.lsp.get_clients { bufnr = 0 }) then
      vim.lsp.completion.get()
    else
      if vim.bo.omnifunc == '' then
        feedkeys '<C-x><C-n>'
      else
        feedkeys '<C-x><C-o>'
      end
    end
  end
end

local M = {}

---@param opts table
M.setup = function(opts)
  local client = opts.client
  local bufnr = opts.bufnr
  vim.o.completeopt = 'fuzzy,menuone,popup,noinsert'

  ---Utility for keymap creation.
  ---@param lhs string
  ---@param rhs string|function
  ---@param key_opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, key_opts, mode)
    key_opts = type(key_opts) == 'string' and { desc = key_opts }
        or vim.tbl_extend('error', key_opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, key_opts)
  end

  -- Enable completion and configure keybindings.
  if client:supports_method("textDocument/completion") then
    -- Trigger completion on any character
    local chars = {}
    for i = 32, 126 do
      table.insert(chars, string.char(i))
    end
    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

    -- Use enter to accept completions.
    keymap('<cr>', function()
      return pumvisible() and '<C-y>' or '<cr>'
    end, { expr = true }, 'i')

    -- Use esc to dismiss the completion menu.
    keymap('<esc>', function()
      return pumvisible() and '<C-e>' or '<esc>'
    end, { expr = true }, 'i')

    -- Use <C-n> to navigate to the next completion or:
    -- - Trigger LSP completion.
    -- - If there's no one, fallback to vanilla omnifunc.
    keymap('<C-n>', supertab, 'Trigger/select next completion', 'i')
    keymap('<Tab>', supertab, {}, { 'i', 's' })

    -- Buffer completions.
    keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')

    -- Do something similar with <S-Tab>.
    keymap('<S-Tab>', function()
      if pumvisible() then
        feedkeys '<C-p>'
      elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
      else
        feedkeys '<S-Tab>'
      end
    end, {}, { 'i', 's' })

    -- Inside a snippet, use backspace to remove the placeholder.
    keymap('<BS>', '<C-o>s', {}, 's')
  end
end

return M
