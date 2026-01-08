local M = {}

function M.setup()
  require('ayu').colorscheme()
  vim.cmd("colorscheme ayu")
end

return M
