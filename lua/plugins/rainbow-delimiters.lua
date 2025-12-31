return {
  'hiphish/rainbow-delimiters.nvim',
  cond = not vim.g.vscode,
  lazy = true,
  main = 'rainbow-delimiters.setup',
  opts = {},
}
