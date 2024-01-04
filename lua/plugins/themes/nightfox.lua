-- Default options
require('nightfox').setup()

-- setup must be called before loading
vim.cmd("colorscheme terafox")
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#223235" })
vim.api.nvim_set_hl(0, 'Cursor', { bg='#a1cdd8' })
