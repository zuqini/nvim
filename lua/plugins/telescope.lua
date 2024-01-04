return {
  enabled = vim.g.search_with_telescope,
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  -- or                              , branch = '0.1.x',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fs', function() builtin.grep_string { shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end, {})

    require('telescope').load_extension('fzf')
  end
}
