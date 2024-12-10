return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    -- separating config out so it can be hot-reloaded later in utils.themes-hot-reload
    require('plugins.config.noice')
  end
}
