local M = {}

function M.setup()
  local everblush = require('everblush')
  everblush.setup({
    override = {
      Comment = { fg = '#737A7C', italic = true },
      NeogitHunkHeaderHighlight = { fg = '#737A7C', italic = true },
      ['@comment'] = { fg = '#737A7C', italic = true },
      ['@float'] = { fg = '#6E7577' },
      ['@exception'] = { fg = '#6E7577' },
      ['@text.note'] = { fg = '#6E7577' },
      ['@text.danger'] = { fg = '#6E7577' },
    },
  })

  vim.cmd("colorscheme everblush")
end

return M
