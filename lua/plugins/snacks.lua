local picker = require('plugins.snacks.picker');

return {
  'folke/snacks.nvim',
  lazy = false,
  keys = vim.list_extend({
    { "<leader>gh", mode = { "n" }, function() require('snacks').gitbrowse() end, desc = "Git browse" },
  }, picker.keys),
  config = function()
    require('snacks').setup({
      bigfile = {},
      quickfile = {},
      statuscolumn = require('plugins.snacks.statuscolumn').opts,
      indent = require('plugins.snacks.indent').opts,
      dashboard = require('plugins.snacks.dashboard').opts,
      picker = picker.opts,
      gitbrowse = {},
    })
  end
}
