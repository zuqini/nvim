return {
  'nvim-mini/mini.surround',
  event = "VeryLazy",
  config = function()
    -- emulate vim surround
    require('mini.surround').setup({
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
    })

    -- Remap adding surrounding to Visual mode selection
    vim.keymap.del('x', 'ys')
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    -- Make special mapping for "add surrounding for line"
    vim.keymap.set('n', 'yss', 'ys_', { remap = true })
  end
}
