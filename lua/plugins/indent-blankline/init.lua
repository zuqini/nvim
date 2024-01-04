return {
  'lukas-reineke/indent-blankline.nvim',
  version = '2.20.8', -- @TODO: update this
  event = 'VeryLazy',
  config = function ()
    require('plugins.indent-blankline.config')
  end
}
