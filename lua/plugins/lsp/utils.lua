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
