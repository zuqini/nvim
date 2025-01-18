return {
  {
    "apple/pkl-neovim",
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
      require('pkl-neovim.internal').init()

      -- Set up syntax highlighting.
      vim.cmd("TSInstall! pkl")
    end,
  },
  {
    "https://github.pie.apple.com/zuqi-li/pcl-neovim.git",
    event = "BufReadPre *.pcl",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      vim.cmd("TSInstall! pcl")
    end,
  }
}
