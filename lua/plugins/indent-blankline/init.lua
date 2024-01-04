return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  config = function ()
    require('plugins.indent-blankline.config')
  end
}
