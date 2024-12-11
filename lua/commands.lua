local clear_reg = require("utils").clear_reg
local opts = { bang = true }

vim.api.nvim_create_user_command('ClearReg', function()
  clear_reg()
end, opts)

-- tabs
vim.api.nvim_create_user_command('TS', "tab split", opts)
vim.api.nvim_create_user_command('TN', "tab new", opts)
vim.api.nvim_create_user_command('HN', "let g:hybrid_nu = !g:hybrid_nu | if g:hybrid_nu | set rnu | else | set nornu | endif", opts)
