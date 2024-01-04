-- Default options
require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
    }
  }
})

-- setup must be called before loading
vim.cmd("colorscheme carbonfox")
