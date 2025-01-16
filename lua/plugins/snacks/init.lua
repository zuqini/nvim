return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {},
    quickfile = {},
    dashboard = require('plugins.snacks.dashboard').opts,
    picker = require('plugins.snacks.picker').opts,
  },
  keys = vim.tbl_extend('error', {}, require('plugins.snacks.picker').keys),
}
