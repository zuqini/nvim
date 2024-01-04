local lspconfig = require('lspconfig')
local wk = require('which-key') -- For documentation

-- vim.lsp.set_log_level("debug")

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- Q loclist is set in plugins/vim/main.vim

wk.register({
  ['[d'] = 'Prev Diagnostic',
  [']d'] = 'Next Diagnostic',
})

wk.register({
  e = 'Open Float',
}, { prefix='<leader>' })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  vim.keymap.set('n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', bufopts)
  vim.keymap.set('n', '<leader>ra', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', bufopts)
  vim.keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', bufopts)
  vim.keymap.set('n', '<leader>rl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', bufopts)
  vim.keymap.set('n', '<leader>rd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
  vim.keymap.set('n', '<leader>rc', '<cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>', bufopts)
  vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)

  vim.keymap.set('n', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>', bufopts)
  vim.keymap.set('v', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>', bufopts)

  wk.register({
    K = 'Hover',
    g = {
      name = 'Go',
      d = 'Definition',
      D = 'Declaration',
      i = 'Implementation',
      r = 'References',
      R = 'References (incl. decl)',
    }
  })

  wk.register({
    K = 'Signature Help',
    r = {
      name = 'Lang.',
      a = 'Add Workspace',
      r = 'Remove Workspace',
      l = 'Show Workspace',
      d = 'Type Definition',
      n = 'Rename',
      c = 'Code Action',
      f = 'Format',
      j = 'jq',
    }
  }, { prefix='<leader>' })
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
      buf_set_keymap('n', '<leader>re', ':RustOpenExternalDocs<CR>', opts)
    end,
})

lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

-- expose on_attach and capabilities to other config files
lspconfig.zuqini_custom = {}
lspconfig.zuqini_custom.on_attach = on_attach
lspconfig.zuqini_custom.capavilities = capabilities

-- setup servers
lspconfig.tsserver.setup {}
lspconfig.pyright.setup {}
lspconfig.jdtls.setup {}
lspconfig.jsonls.setup {}

-- either use omnisharp or omnisharp_mono, add to my.lua based on which is needed
-- lspconfig.omnisharp.setup {}

-- omnisharp_mono comes from mason so need to setup defaults manually
-- lspconfig.omnisharp_mono.setup {
--     on_attach = lspconfig.zuqini_custom.on_attach,
--     capabilities = lspconfig.zuqini_custom.capabilities,
--     flags = {
--         debounce_text_changes = 150,
--     }
-- }

-- Arduino stuff
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#arduino_language_server
-- also: arduino-cli core install arduino:avr
-- lspconfig.arduino_language_server.setup {
--   cmd = {
--     "arduino-language-server",
--     "-cli-config", "/Users/zuqinimbp16/Library/Arduino15/arduino-cli.yaml",
--     "-fqbn", "arduino:avr:uno",
--     "-cli", "arduino-cli",
--     "-clangd", "clangd"
--   }
-- }
