return {
  {
    "apple/pkl-neovim",
    cond = not vim.g.vscode,
    ft = "pkl",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = function(_)
          vim.cmd("TSUpdate")
        end,
      },
    },
    build = function()
      require('pkl-neovim').init()

      -- Set up syntax highlighting.
      vim.cmd("TSInstall! pkl")
    end,
  },
}
