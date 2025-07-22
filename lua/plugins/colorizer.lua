return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  cond = not vim.g.vscode,
  opts = { -- set to setup table
  },
}
