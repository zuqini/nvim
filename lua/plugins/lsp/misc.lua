require("nvim-navic").setup({
  icons = {
    File          = "󰈙  ",
    Module        = "  ",
    Namespace     = "󰌗  ",
    Package       = "  ",
    Class         = "󰌗  ",
    Method        = "󰆧  ",
    Property      = "  ",
    Field         = "  ",
    Constructor   = "  ",
    Enum          = "󰕘  ",
    Interface     = "󰕘  ",
    Function      = "󰊕  ",
    Variable      = "󰆧  ",
    Constant      = "󰏿  ",
    String        = "󰀬  ",
    Number        = "󰎠  ",
    Boolean       = "◩ ",
    Array         = "󰅪  ",
    Object        = "󰅩  ",
    Key           = "󰌋  ",
    Null          = "󰟢  ",
    EnumMember    = "  ",
    Struct        = "󰌗  ",
    Event         = "  ",
    Operator      = "󰆕  ",
    TypeParameter = "󰊄  ",
  },
  lsp = {
    auto_attach = true,
  },
  -- highlight = true,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
  safe_output = true,
  click = true,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 10000 then
      vim.b.navic_lazy_update_context = true
    end
  end,
})

-- Notify empty results
local handler_names_to_notify = {
  'textDocument/definition',
  'textDocument/declaration',
  'textDocument/implementation',
  'textDocument/typeDefinition',
}
for _, handler_name in pairs(handler_names_to_notify) do
  local handler = vim.lsp.handlers[handler_name]
  vim.lsp.handlers[handler_name] = function(err, result, ctx, config)
    if not result then
      vim.notify("could not find " .. handler_name)
    end
    handler(err, result, ctx, config)
  end
end
