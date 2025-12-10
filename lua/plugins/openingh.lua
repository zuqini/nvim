return {
  "almo7aya/openingh.nvim",
  keys = {
    { "<leader>gh", mode = { "n" }, function() vim.cmd("OpenInGHFile") end, desc = "Open GH File" },
    { "<leader>gH", mode = { "n" }, function() vim.cmd("OpenInGHRepo") end, desc = "Open GH Repo" },
  },
}
