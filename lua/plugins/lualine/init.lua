return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function ()
    -- separating config out so it can be hot-reloaded later in utils.themes-hot-reload
    require('plugins.lualine.config')
  end
}
