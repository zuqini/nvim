return {
  { "rafamadriz/friendly-snippets" },
  { 'L3MON4D3/LuaSnip' },
  {
    'saghen/blink.cmp',
    enabled = vim.g.cmp_engine == 'blink',
    cond = not vim.g.vscode,

    -- use a release tag to download pre-built binaries
    version = vim.version.range("1.*"),

    config = function()
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      local opts = {
        snippets = { preset = 'luasnip' },
        sources = {
          -- add lazydev to your completion providers
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            lua = { inherit_defaults = true, 'lazydev' }
          },
          providers = {
            -- dont show LuaLS require statements when lazydev has items
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
          },
        },
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- see the "default configuration" section below for full documentation on how to define
        -- your own keymap.
        keymap = {
          preset = 'enter',
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ['<C-l>'] = { 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide', 'fallback' },
          ['<Esc>'] = { 'hide', 'fallback' },
          ['<C-y>'] = { 'select_and_accept' },
          ['<CR>'] = { 'select_and_accept', 'fallback' },
        },
        cmdline = {
          keymap = {
            preset = 'enter',
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ['<C-y>'] = { 'select_and_accept' },
            ['<CR>'] = {
              function(cmp)
                return cmp.accept({
                  callback = function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
                  end,
                })
              end,
              'fallback',
            },
          },
          completion = {
            menu = {
              auto_show = true,
            },
            list = {
              selection = { preselect = false, auto_insert = true },
            },
          },
        },

        completion = {
          menu = {
            draw = {
              gap = 2,
              treesitter = { "lsp" },
            },
          },
          documentation = {
            -- Controls whether the documentation window will automatically show when selecting a completion item
            auto_show = true,
            auto_show_delay_ms = 50,
            window = {
              winblend = vim.o.winblend
            },
          },
          list = {
            selection = { preselect = false, auto_insert = true },
          },
        },

        -- experimental signature help support
        signature = {
          enabled = true,
          window = {
            winblend = vim.o.winblend
          }
        }
      }
      require("luasnip.loaders.from_vscode").lazy_load()
      require('blink.cmp').setup(opts)
    end
  },
}
