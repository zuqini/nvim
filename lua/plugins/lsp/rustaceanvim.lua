return {
  'mrcjkb/rustaceanvim',
  cond = not vim.g.vscode,
  sem_version = '^6', -- Recommended
  ft = 'rust'
  -- make sure rust-analyzer is installed, and NOT through mason.nvim
  -- see https://github.com/mrcjkb/rustaceanvim/blob/master/doc/mason.txt
}
