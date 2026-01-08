local M = {}

function M.setup()
  vim.cmd('colorscheme default')
  vim.api.nvim_set_hl(0, 'StatusLine', { fg='NvimLightGrey4' })
end

return M
