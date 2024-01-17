return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<c-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<a-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  opts = {
    modes = {
      search = {
        enabled = false,
      },
      char = {
        config = function(opts)
          -- https://github.com/folke/flash.nvim/issues/103#issuecomment-1615177345
          -- autohide flash when in operator-pending mode
          local pending_operators_to_autohide = "yd"
          opts.autohide = vim.fn.mode(true):find("no") and string.find(pending_operators_to_autohide, vim.v.operator)

          -- disable jump labels when enabled and when using a count
          opts.jump_labels = opts.jump_labels and vim.v.count == 0

          -- Show jump labels only in operator-pending mode
          -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
        end
      }
    }
  }
}
