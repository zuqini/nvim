return {
  'dstein64/nvim-scrollview',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    require('scrollview').setup()
    require('scrollview.contrib.gitsigns').setup()
  end,
}
