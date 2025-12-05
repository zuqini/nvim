return {
  require('plugins.lsp.lsp'),
  { "mason-org/mason.nvim", config = function() require('mason').setup({}) end },
  {
    "mason-org/mason-lspconfig.nvim",
    cond = not vim.g.vscode,
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "vimls",
          "lua_ls",
        },
        automatic_enable = {
          exclude = { "rust_analyzer" }
        }
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    cond = not vim.g.vscode,
    ft = "lua", -- only load on lua files
    config = function()
      require('lazydev').setup({
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim",        words = { "Snacks" } },
        },
      })
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    cond = not vim.g.vscode,
    -- version = '^6', -- Recommended
    ft = "rust"
    -- make sure rust-analyzer is installed, and NOT through mason.nvim
    -- see https://github.com/mrcjkb/rustaceanvim/blob/master/doc/mason.txt
  }
}
