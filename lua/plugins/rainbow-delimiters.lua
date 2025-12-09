return {
  'hiphish/rainbow-delimiters.nvim',
  cond = not vim.g.vscode,
  config = function()
    require('rainbow-delimiters.setup').setup {}
  end,
}
