return {
  'hiphish/rainbow-delimiters.nvim',
  enabled = true,
  cond = not vim.g.vscode,
  config = function()
    require('rainbow-delimiters.setup').setup {}
  end,
}
