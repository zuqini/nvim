return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  cond = not vim.g.vscode,
  config = function()
    require('illuminate').configure({
      should_enable = function(bufnr)
        return not require('utils.file_size').is_large_file(bufnr)
      end,
      filetypes_denylist = {
        'snacks_picker_input',
      },
    })
  end,
}
