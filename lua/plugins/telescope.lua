return {
  enabled = vim.g.search_with_telescope,
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  -- or                              , branch = '0.1.x',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },
  config = function()
    require('telescope').setup{
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          height = 0.95,
          width = 0.85,
          preview_height = 0.65,
          preview_cutoff = 25,
          mirror = true,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    }

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', 'S', builtin.find_files, {})
    vim.keymap.set('n', '<leader>S', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>s', function() builtin.grep_string { shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end, {})

    vim.keymap.set('n', '<leader>o', builtin.oldfiles, {})

    vim.keymap.set('n', '<leader>b', builtin.buffers, {})

    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fm', builtin.marks, {})
    vim.keymap.set('n', '<leader>fu', builtin.resume, {})

    require('telescope').load_extension('fzf')
  end
}
