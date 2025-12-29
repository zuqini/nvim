return {
  'nvim-mini/mini.surround',
  event = "VeryLazy",
  opts = {
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '<leader>sf',
      find_left = '<leader>sF',
      highlight = '<leader>sh',
      replace = 'cs',
      update_n_lines = '<leader>sn',
    },
    search_method = 'cover_or_next',
  },
  config = function(_, opts)
    require('mini.surround').setup(opts)
    vim.keymap.del('x', 'ys')
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    vim.keymap.set('n', 'yss', 'ys_', { remap = true })
  end
}
