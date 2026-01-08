local M = {}

function M.setup()
  require("citruszest").setup({
    style = {
      CursorLine = { bg = "#222222" }
    },
  })
  vim.cmd("colorscheme citruszest")
end

return M
