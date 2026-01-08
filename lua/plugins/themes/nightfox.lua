local M = {}

function M.setup()
  require('nightfox').setup({
    options = {
      styles = {
        comments = "italic",
      }
    }
  })

  vim.cmd("colorscheme nightfox")
end

return M
