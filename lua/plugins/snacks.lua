local picker = require('plugins.snacks.picker');

return {
  'folke/snacks.nvim',
  keys = picker.keys,
  config = function()
    require('snacks').setup({
      bigfile = {},
      quickfile = {},
      statuscolumn = require('plugins.snacks.statuscolumn').opts,
      indent = require('plugins.snacks.indent').opts,
      dashboard = require('plugins.snacks.dashboard').opts,
      picker = picker.opts,
    })
  end
}
