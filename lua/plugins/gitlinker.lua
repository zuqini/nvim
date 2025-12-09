return {
  "linrongbin16/gitlinker.nvim",
  -- enabled = false,
  config = function()
    require('gitlinker').setup({})
  end,
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>",        mode = { "n", "v" }, desc = "Yank git link" },
    { "<leader>gY", "<cmd>GitLink blame<cr>",  mode = { "n", "v" }, desc = "Yank git link Blame" },
    { "<leader>gh", "<cmd>GitLink!<cr>",       mode = { "n", "v" }, desc = "Open git link" },
    { "<leader>gH", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open git link blame" }
  },
}
