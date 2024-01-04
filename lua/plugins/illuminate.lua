return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  config = function()
    require('illuminate').configure({
      large_file_cutoff = 5000,
    })
  end,
}
