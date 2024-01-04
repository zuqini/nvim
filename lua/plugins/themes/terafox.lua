-- Default options
require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
    }
  }
})

-- setup must be called before loading
vim.cmd("colorscheme terafox")
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#223235" })
vim.api.nvim_set_hl(0, 'Cursor', { bg='#a1cdd8', reverse=true })
vim.api.nvim_set_hl(0, 'TermCursor', { bg='#a1cdd8', reverse=true })
vim.api.nvim_set_hl(0, 'TermCursorNC', { bg='#a1cdd8', reverse=true })
