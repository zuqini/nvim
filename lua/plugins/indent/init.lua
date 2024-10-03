return {
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    event = 'VeryLazy',
    config = function()
      require('plugins.indent.ibl-config')
    end
  },
  {
    "shellRaining/hlchunk.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('plugins.indent.hlchunk-config')
    end
  },
}
