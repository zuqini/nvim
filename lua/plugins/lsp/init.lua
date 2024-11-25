return {
  {
    'neovim/nvim-lspconfig',
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
      'SmiteshP/nvim-navic',
    },
    config = function()
      require("plugins.lsp.mason")
      require("plugins.lsp.lsp")
      require("plugins.lsp.misc")
      pcall(function() require("plugins.lsp.my") end) -- this is for env specific lsp configs
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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

      -- 'onsails/lspkind.nvim', -- @TODO: look into this. optional but required for better ui experience
    },
    config = function()
      require("plugins.lsp.cmp")
    end,
  },
}
