return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = true,
  event = 'VeryLazy',
  config = function()
    -- separating config out so it can be hot-reloaded later in utils.themes-hot-reload
    require('plugins.config.ibl')
  end
}
