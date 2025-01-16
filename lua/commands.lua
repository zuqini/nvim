local utils = require("utils")
local opts = { bang = true }

vim.api.nvim_create_user_command('ClearReg', utils.clear_reg, opts)

-- tabs
vim.api.nvim_create_user_command('TS', "tab split", opts)
vim.api.nvim_create_user_command('TN', "tab new", opts)
vim.api.nvim_create_user_command('HN',
  "let g:hybrid_nu = !g:hybrid_nu | if g:hybrid_nu | set rnu | else | set nornu | endif", opts)

vim.api.nvim_create_user_command('T', utils.trim_space, opts)
vim.api.nvim_create_user_command('TT', utils.trim_last_lines, opts)
vim.api.nvim_create_user_command('TTT', function()
  utils.trim_last_lines()
  utils.trim_space()
end, opts)
