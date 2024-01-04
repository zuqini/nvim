local lspconfig = require('lspconfig')
local wk = require('which-key') -- For documentation

-- vim.lsp.set_log_level("debug")

local keymap_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', keymap_opts)
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', keymap_opts)
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', keymap_opts)
-- Q loclist is set in plugins/vim/main.vim

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

wk.register({
  ['[d'] = 'Prev Diagnostic',
  [']d'] = 'Next Diagnostic',
})

wk.register({
  e = 'Open Float',
}, { prefix = '<leader>' })

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>ga', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>gl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>gn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>gc', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references { includeDeclaration = false } end, bufopts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts)

  vim.keymap.set('n', '<leader>gf', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('v', '<leader>gf', vim.lsp.buf.format, bufopts)

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
    g = {
      name = 'Lang.',
      a = 'Add Workspace',
      r = 'Remove Workspace',
      l = 'Show Workspace',
      d = 'Type Definition',
      n = 'Rename',
      c = 'Code Action',
      f = 'Format',
      q = 'jq',
      p = 'Peek func',
      P = 'Peek class',
    }
  }, { prefix = '<leader>' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
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

local open_url = require('utils').open_url;
lspconfig.rust_analyzer.setup({
  commands = {
    RustOpenExternalDocs = {
      function()
        vim.lsp.buf_request(vim.api.nvim_get_current_buf(), 'experimental/externalDocs',
          vim.lsp.util.make_position_params(), function(err, url)
          if err then
            error(tostring(err))
          elseif url == nil then
            print("No documentation found.")
          else
            open_url(url)
          end
        end)
      end,
      description = 'Open documentation for the symbol under the cursor in default browser',
    },
  },
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    buf_set_keymap('n', '<leader>ge', ':RustOpenExternalDocs<CR>', keymap_opts)
    wk.register({
      g = {
        e = 'RustOpenExtDocs',
      }
    }, { prefix = '<leader>' })
  end,
})

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'RequireVim' }
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
