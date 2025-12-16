return {
  "iamcco/markdown-preview.nvim",
  cond = not vim.g.vscode,
  event = "FileType",
  pattern = "markdown",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
