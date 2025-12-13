return {
  'mrcjkb/rustaceanvim',
  cond = not vim.g.vscode,
  version = vim.version.range('^6'), -- Recommended
  event = 'FileType',
  pattern = 'rust',
  -- make sure rust-analyzer is installed, and NOT through mason.nvim
  -- see https://github.com/mrcjkb/rustaceanvim/blob/master/doc/mason.txt
}
