local M = {}

function M.setup()
  require('nightfox').setup({
    options = {
      styles = {
        comments = "italic",
      }
    }
  })

  vim.cmd("colorscheme carbonfox")
  vim.api.nvim_set_hl(0, "Visual", { bg = "#303030" })
end

return M
