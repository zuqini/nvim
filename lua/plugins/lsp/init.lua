return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
          {
            "williamboman/mason.nvim",
            build = ":MasonUpdate" -- :MasonUpdate updates registry contents
          },
        },
      },
      'folke/neodev.nvim',
    },
    config = function ()
      require("plugins/lsp/mason")
      require("plugins/lsp/lsp")
      require("plugins/lsp/utils")
      pcall(function() require("plugins/lsp/my") end) -- this is for env specific lsp configs
    end
  },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      -- consider https://github.com/petertriho/cmp-git

      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require("plugins.lsp.cmp")
    end,
  },
}
