return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  config = function()
    require('illuminate').configure({
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = {
          'lsp',
          'regex',
        },
      },
      should_enable = function(bufnr)
        return not require('utils').is_large_file(bufnr)
      end,
      filetypes_denylist = {
        'snacks_picker_input',
      },
    })
  end,
}
