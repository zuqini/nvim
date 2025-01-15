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

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          print("LSP client is unexpectedly unavailable")
          return
        end

        vim.lsp.inlay_hint.enable(true)

        if vim.lsp.codelens then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = args.buf,
            callback = vim.lsp.codelens.refresh,
          })
        end

        -- Mappings.
        local bufmap = function(mode, mapping, rhs, desc)
          vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true, buffer = args.buf })
        end
        vim.keymap.set(
          "n",
          'grN',
          function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
          end,
          { desc = 'Rename', noremap = true, silent = true, expr = true, buffer = args.buf })
        bufmap('n', 'grn', ':IncRename ', 'Rename (Clear)')
        -- TODO: only add keymap if client:supports_method
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

        bufmap('n', '<leader>gI', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
          'Toggle Inlay Hints')

        if client:supports_method('textDocument/formatting') then
          -- Format the current buffer on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
        end
      end,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      callback = function(args)
        -- Get the detaching client
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          print("LSP client is unexpectedly unavailable")
          return
        end
        -- Remove the autocommand to format the buffer on save, if it exists
        if client:supports_method('textDocument/formatting') then
          vim.api.nvim_clear_autocmds({
            event = 'BufWritePre',
            buffer = args.buf,
          })
        end
      end,
    })

    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            }
          }
        },
        on_attach = function(_, bufnr)
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

    -- if vim.g.is_windows then
    --   windows specific bug, see https://www.reddit.com/r/neovim/comments/114z8he/comment/j8z2w0k/?utm_source=share&utm_medium=web2x&context=3
    --   remember to run `scoop install nmap`
    --   lspconfig.gdscript.setup { cmd = { "ncat", "localhost", "6005" } }
    -- end

    -- either use omnisharp or omnisharp_mono, add to my.lua based on which is needed
    -- lspconfig.omnisharp.setup {}

    -- omnisharp_mono comes from mason so maybe need to setup defaults manually
    -- lspconfig.omnisharp_mono.setup { }

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
