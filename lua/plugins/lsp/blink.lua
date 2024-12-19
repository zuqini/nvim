return {
  'saghen/blink.cmp',
  enabled = vim.g.cmp_engine == "blink",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  -- version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      -- add lazydev to your completion providers
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
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
      ['<Esc>'] = { 'cancel', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },

      cmdline = {
        preset = 'enter',
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ['<C-y>'] = { 'select_and_accept' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Esc>'] = {
          'cancel',
          function(_) return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true) end, -- https://github.com/Saghen/blink.cmp/issues/547
        }
      }
    },

    completion = {
      documentation = {
        -- Controls whether the documentation window will automatically show when selecting a completion item
        auto_show = true,
        auto_show_delay_ms = 100,
        window = {
          border = 'rounded',
        },
      },
      accept = {
        -- Create an undo point when accepting a completion item
        create_undo_point = true,
        -- Experimental auto-brackets support
        auto_brackets = {
          -- Whether to auto-insert brackets for functions
          enabled = true,
        },
      },
      list = {
        selection = 'auto_insert',
      },
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = 'rounded',
      },
    }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" }
}
