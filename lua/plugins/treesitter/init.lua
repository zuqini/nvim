return {
  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    config = function () require("plugins/treesitter/context") end
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function () require("plugins/treesitter/treesitter") end
  },
  {
    'drybalka/tree-climber.nvim',
    event = 'VeryLazy',
    config = function () require("plugins/treesitter/treeclimber") end
  },
  -- Additional language packs that treesitter doesn't support
  { 'elubow/cql-vim', ft = 'cql', },
}
