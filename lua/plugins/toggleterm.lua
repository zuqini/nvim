return {
  'akinsho/toggleterm.nvim',
  keys = '<c-\\>',
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      size = function (_term)
        return vim.o.lines * 0.6
      end,
    })
  end
}
