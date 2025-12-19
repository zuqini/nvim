return {
  "iamcco/markdown-preview.nvim",
  cond = not vim.g.vscode,
  ft = "markdown",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    require('utils').schedule_notify('Markdown Preview loaded on FileType markdown')
  end
}
