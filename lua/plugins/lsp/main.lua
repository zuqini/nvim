local lspconfig = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>ra', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>rl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>rd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

    buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('v', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    }
  }
)

lspconfig.rust_analyzer.setup({
  commands = {
    RustOpenExternalDocs = {
      function()
        vim.lsp.buf_request(vim.api.nvim_get_current_buf(), 'experimental/externalDocs', vim.lsp.util.make_position_params(), function(err, url)
          if err then
            error(tostring(err))
          elseif url == nil then
            print("No documentation found.")
          else
            vim.fn['netrw#BrowseX'](url, 0)
          end
        end)
      end,
      description = 'Open documentation for the symbol under the cursor in default browser',
    },
  },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      buf_set_keymap('n', '<leader>re', ':RustOpenExternalDocs<CR>', opts)
    end,
})
lspconfig.tsserver.setup {}
lspconfig.pyright.setup {}
lspconfig.sumneko_lua.setup {}
lspconfig.omnisharp.setup {}
lspconfig.jdtls.setup {}
lspconfig.jsonls.setup {}
