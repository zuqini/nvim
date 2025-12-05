return {
  'dstein64/nvim-scrollview',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    require('scrollview').setup({
      hide_bar_for_insert = true,
      signs_hidden_for_insert = { 'all' },
    })
    require('scrollview.contrib.gitsigns').setup()
  end,
}
