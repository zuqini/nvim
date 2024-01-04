return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
    },
    config = function ()
      require("plugins/lsp/mason")
      require("plugins/lsp/lsp")
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
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'L3MON4D3/LuaSnip', -- Snippets plugin
    },
    config = function()
      require("plugins.lsp.cmp")
    end,
  },
}
