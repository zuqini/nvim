return {
  'akinsho/toggleterm.nvim',
  keys = '<c-\\>',
  config = function ()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
    })
  end
}
