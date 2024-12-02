-- vim.lsp.set_log_level("debug")
local lspconfig = require('lspconfig')

local map = function(mode, mapping, rhs, desc)
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
end

map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'Dignostic Float')

-- these are default in nvim v0.11
map('n', 'grn', vim.lsp.buf.rename, 'Rename')
map('n', 'gra', vim.lsp.buf.code_action, 'Code Action')
map('n', 'grr', function() vim.lsp.buf.references { includeDeclaration = false } end, 'References')
map('i', '<c-s>', vim.lsp.buf.signature_help, 'Signature Help')

vim.diagnostic.config({
  virtual_text = {
    prefix = '󰅏 ',
  }
})

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
  ---@class vim.lsp.util.open_floating_preview.Opts
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local on_attach = function(_, bufnr)
  vim.lsp.inlay_hint.enable(true)
  --- toggle diagnostics
  vim.g.diagnostics_visible = true
  local function toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.diagnostic.enable(false)
    else
      vim.g.diagnostics_visible = true
      vim.diagnostic.enable(true)
    end
  end

  -- Mappings.
  local bufmap = function(mode, mapping, rhs, desc)
    vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true, buffer = bufnr })
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  bufmap('n', 'gd', vim.lsp.buf.definition, 'Definition')
  bufmap('n', 'gD', vim.lsp.buf.declaration, 'Declaration')
  bufmap('n', 'gR', vim.lsp.buf.references, 'References w/ Declaration')
  bufmap('n', 'gi', vim.lsp.buf.implementation, 'Implementation')

  bufmap('n', '<leader>K', vim.lsp.buf.signature_help, 'Signature Help')
  bufmap('n', '<leader>ga', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
  bufmap('n', '<leader>gr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
  bufmap('n', '<leader>gl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    'List Workspace Folder')
  bufmap('n', '<leader>gd', vim.lsp.buf.type_definition, 'Type Definition')

  bufmap('n', '<leader>gf', function() vim.lsp.buf.format { async = true } end, 'Format')
  bufmap('v', '<leader>gf', vim.lsp.buf.format, 'Format')
  bufmap('n', '<leader>gD', toggle_diagnostics, 'Toggle Dignostics')
  bufmap('n', '<leader>gI',
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
    'Toggle Inlay Hints')
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
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = "clippy"
      }
    }
  },
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
    map('n', '<leader>ge', ':RustOpenExternalDocs<CR>', 'Open Ext. Docs')
  end,
})

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'RequireVim' },
        disable = { "missing-fields" }
      },
      hint = {
        enable = true
      },
    }
  }
}

-- setup servers
lspconfig.vimls.setup {}
lspconfig.ts_ls.setup {}
lspconfig.pyright.setup {}
lspconfig.jdtls.setup {}
lspconfig.jsonls.setup {}
lspconfig.gdscript.setup {}
lspconfig.astro.setup {}

-- expose on_attach and capabilities to other config files
lspconfig.zuqini_custom = {}
lspconfig.zuqini_custom.on_attach = on_attach
lspconfig.zuqini_custom.capabilities = capabilities

-- if vim.g.is_windows then
--   windows specific bug, see https://www.reddit.com/r/neovim/comments/114z8he/comment/j8z2w0k/?utm_source=share&utm_medium=web2x&context=3
--   remember to run `scoop install nmap`
--   lspconfig.gdscript.setup { cmd = { "ncat", "localhost", "6005" } }
-- end

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
