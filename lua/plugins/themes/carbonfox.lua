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
vim.api.nvim_set_hl(0, "Visual", { bg = "#303030" })
