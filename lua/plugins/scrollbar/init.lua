return {
  'petertriho/nvim-scrollbar',
  event = 'VeryLazy',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'kevinhwang91/nvim-hlslens',
  },
  config = function ()
    require('plugins.scrollbar.config')
  end,
}
