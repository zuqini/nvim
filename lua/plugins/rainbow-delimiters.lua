return {
  'hiphish/rainbow-delimiters.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  main = 'rainbow-delimiters.setup',
  opts = {},
}
