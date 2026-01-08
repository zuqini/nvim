local M = {}

function M.setup()
  vim.g.gruvbox_material_background='hard'
  vim.g.background='dark'
  vim.g.gruvbox_material_diagnostic_text_highlight=1
  vim.g.gruvbox_material_diagnostic_line_highlight=1
  vim.g.gruvbox_material_diagnostic_virtual_text='colored'

  vim.cmd('colorscheme gruvbox-material')
end

return M
