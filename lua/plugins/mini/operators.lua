return {
  'nvim-mini/mini.operators',
  event = "VeryLazy",
  opts = {
    replace = { prefix = 'gp' },
  },
  config = function(_, opts)
    require('mini.operators').setup(opts)
    vim.keymap.set('n', '<leader>gp', '"0gp', { desc = 'Yank Replace Operator', remap = true })
    vim.keymap.set('n', '<leader>gv', '"+gp', { desc = 'Clipboard Replace Operator', remap = true })
  end
}
