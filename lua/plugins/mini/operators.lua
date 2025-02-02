return {
  'echasnovski/mini.operators',
  version = false,
  event = 'VeryLazy',
  config = function()
    require('mini.operators').setup({
      replace = {
        prefix = 'gp',
      },
    })
    -- remap = true to use mini.operators replace
    vim.keymap.set('n', '<leader>gp', '"0gp', { desc = 'Yank Replace Operator', remap = true })
    vim.keymap.set('n', '<leader>gv', '"+gp', { desc = 'Clipboard Replace Operator', remap = true })
  end
};
