return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = {
        {
          "williamboman/mason.nvim",
          build = ":MasonUpdate" -- :MasonUpdate updates registry contents
        },
      },
      config = function()
        require('mason').setup()
        require("mason-lspconfig").setup({
          automatic_installation = {
            exclude = {
              "rust_analyzer",
              "omnisharp",
              "omnisharp_mono",
              "jdtls",
              "astro",
            }
          }
        })
      end
    },
  },
  config = function()
    -- vim.lsp.set_log_level("debug")
    local lspconfig = require('lspconfig')

    local map = function(mode, mapping, rhs, desc)
      vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
    end

    map('n', '<leader>e', vim.diagnostic.open_float, 'Dignostic Float')

    -- these are default in nvim v0.11
    map('n', 'gra', vim.lsp.buf.code_action, 'Code Action')
    map('n', 'grr', function() vim.lsp.buf.references { includeDeclaration = false } end, 'References')
    map('n', 'gri', vim.lsp.buf.implementation, 'Implementation')
    map('n', 'gO', vim.lsp.buf.document_symbol, 'Document Symbol')
    map('i', '<c-s>', vim.lsp.buf.signature_help, 'Signature Help')
    -- map('n', 'grn', vim.lsp.buf.rename, 'Rename')
    map('n', 'grn', ':IncRename ', 'Rename (Clear)')
    vim.keymap.set(
      "n",
      'grN',
      function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end,
      { desc = 'Rename', noremap = true, silent = true, expr = true })

    vim.diagnostic.config({
      virtual_text = {
        prefix = '󰅏 ',
      }
    })

    -- local border = {
    --   { "╭", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╮", "FloatBorder" },
    --   { "│", "FloatBorder" },
    --   { "╯", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╰", "FloatBorder" },
    --   { "│", "FloatBorder" },
    -- }
    --
    -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    --   ---@class vim.lsp.util.open_floating_preview.Opts
    --   opts = opts or {}
    --   opts.border = opts.border or border
    --   return orig_util_open_floating_preview(contents, syntax, opts, ...)
    -- end

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

      if vim.lsp.codelens then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        })
      end

      -- Mappings.
      local bufmap = function(mode, mapping, rhs, desc)
        vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true, buffer = bufnr })
      end
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      bufmap('n', '<C-]>', vim.lsp.buf.definition, 'Definition')
      bufmap('n', 'gd', vim.lsp.buf.definition, 'Definition')
      bufmap('n', 'gD', vim.lsp.buf.type_definition, 'Type Definition')
      bufmap('n', 'gR', vim.lsp.buf.references, 'References w/ Declaration')

      bufmap('n', '<leader>K', vim.lsp.buf.signature_help, 'Signature Help')
      bufmap('n', '<leader>gq', vim.lsp.buf.format, 'Format Buffer')
      bufmap('n', '<leader>gd', vim.lsp.buf.declaration, 'Declaration')
      bufmap('n', '<leader>ga', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
      bufmap('n', '<leader>gr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
      bufmap('n', '<leader>gl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        'List Workspace Folder')

      bufmap('n', '<leader>gc', vim.lsp.codelens.run, 'Run CodeLens')

      bufmap('n', '<leader>gD', toggle_diagnostics, 'Toggle Dignostics')
      bufmap('n', '<leader>gI', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        'Toggle Inlay Hints')
    end

    local capabilities = nil
    if vim.g.cmp_engine == "blink" then
      capabilities = require('blink.cmp').get_lsp_capabilities()
    end
    if vim.g.cmp_engine == "nvim-cmp" then
      capabilities = require('cmp_nvim_lsp').default_capabilities()
    end

    lspconfig.util.default_config = vim.tbl_extend(
      'force',
      lspconfig.util.default_config,
      {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    )

    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            }
          }
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          local bufmap = function(mode, mapping, rhs, desc)
            vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true, buffer = bufnr })
          end
          bufmap('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'Hover')
          bufmap('n', 'gra', function() vim.cmd.RustLsp('codeAction') end, 'Code Action')
        end,
      }
    }

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
          codeLens = {
            enable = true,
          },
        }
      }
    }

    -- setup servers
    lspconfig.vimls.setup {}
    lspconfig.ts_ls.setup {
      init_options = {
        preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = 'non-relative',
        },
      },
    }
    lspconfig.pyright.setup {}
    lspconfig.jdtls.setup {}
    lspconfig.jsonls.setup {}
    lspconfig.gdscript.setup {}
    lspconfig.astro.setup {}
    lspconfig.cssls.setup {}

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
  end
}
