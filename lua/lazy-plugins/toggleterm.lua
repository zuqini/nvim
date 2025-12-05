return {
  'akinsho/toggleterm.nvim',
  keys = [[<leader>\]],
  cond = not vim.g.vscode,
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<leader>\]],
      shade_terminals = false,
      size = function(_term)
        return vim.o.lines * 0.6
      end,
    })
  end
}
