return {
  { 'windwp/nvim-ts-autotag',     event = 'VeryLazy' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  -- Additional language packs that treesitter doesn't support
  { 'elubow/cql-vim',             ft = 'cql', },
  { import = 'plugins/treesitter' }
}
