return {
  "iamcco/markdown-preview.nvim",
  cond = not vim.g.vscode,
  build = function() vim.fn["mkdp#util#install"]() end,
}
