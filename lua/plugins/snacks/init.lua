return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {},
    quickfile = {},
    statuscolumn = require('plugins.snacks.statuscolumn').opts,
    indent = require('plugins.snacks.indent').opts,
    dashboard = require('plugins.snacks.dashboard').opts,
    picker = require('plugins.snacks.picker').opts,
  },
  keys = vim.tbl_extend('error', {}, require('plugins.snacks.picker').keys),
}
