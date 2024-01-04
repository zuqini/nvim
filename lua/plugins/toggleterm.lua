return {
  'akinsho/toggleterm.nvim',
  keys = '<c-\\>',
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      size = function (_term)
        return vim.o.lines * 0.6
      end,
    })
  end
}
