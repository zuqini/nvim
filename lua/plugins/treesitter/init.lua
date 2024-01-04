return {
  'windwp/nvim-ts-autotag',
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function () require("plugins/treesitter/context") end
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function () require("plugins/treesitter/treesitter") end
  },
  {
    'drybalka/tree-climber.nvim',
    config = function () require("plugins/treesitter/treeclimber") end
  },
  -- Additional language packs that treesitter doesn't support
  { 'elubow/cql-vim', ft = 'cql', },
}
