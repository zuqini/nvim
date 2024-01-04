return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'Everblush/everblush.nvim' -- needed for lualine theme
  },
  config = function ()
    -- separating config so it can be hot-reloaded later in utlis.themes-hot-reload
    require('plugins.lualine.config')
  end
}
