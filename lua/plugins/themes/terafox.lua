local M = {}

function M.setup()
  require('nightfox').setup({
    options = {
      styles = {
        comments = "italic",
      }
    }
  })

  vim.cmd("colorscheme terafox")
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#223235" })
end

return M
