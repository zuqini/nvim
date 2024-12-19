return {
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim-ts-autotag').setup({})
    end,
    lazy = true,
    event = "VeryLazy"
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
  },
  -- Additional language packs that treesitter doesn't support
  {
    'elubow/cql-vim',
    ft = 'cql',
  },
  { import = 'plugins/treesitter' }
}
