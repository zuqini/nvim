vim.cmd.packadd("nvim.undotree")
vim.api.nvim_create_user_command('U', require("undotree").open, { bang = true })

vim.cmd.packadd("nohlsearch")
