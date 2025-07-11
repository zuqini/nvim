return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    ft = "rust"
    -- make sure rust-analyzer is installed, and NOT through mason.nvim
    -- see https://github.com/mrcjkb/rustaceanvim/blob/master/doc/mason.txt
  },
  { import = 'plugins.lsp' }
}
