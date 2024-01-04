return {
  'akinsho/toggleterm.nvim',
  keys = '<c-\\>',
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      -- size = function (term)
      --   return vim.o.lines * 0.75
      -- end,
    })
  end
}
