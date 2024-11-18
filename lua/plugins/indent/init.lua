return {
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function()
      require('plugins.indent.ibl-config')
    end
  },
  {
    "shellRaining/hlchunk.nvim",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('plugins.indent.hlchunk-config')
    end
  },
}
