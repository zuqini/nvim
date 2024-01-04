vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1;
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

function vRequire(path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path .. '.vim')
end

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  -- Themes
  { 'zuqini/gruvbox-material', lazy = true },
  { 'EdenEast/nightfox.nvim', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'folke/tokyonight.nvim', branch = 'main', lazy = true, },
  { 'pineapplegiant/spaceduck', branch= 'main', lazy = true, },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'nvim-tree/nvim-tree.lua', -- https://github.com/kyazdani42/nvim-tree.lua/issues/877,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("plugins/nvim-tree")
    end,
    keys = {
      "<S-Tab>",
      "<Leader><Tab>",
    },
  },

  -- FZF
  { 'junegunn/fzf', build = './install --bin' },
  {
    'ibhagwan/fzf-lua',
    enabled = not vim.g.is_windows,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('plugins/fzf-lua');
    end
  },
  {
    'junegunn/fzf.vim',
    enabled = vim.g.is_windows,
    event = 'VeryLazy',
    config = function ()
      vRequire('plugins/fzf');
    end
  },

  -- Languages stuff
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',

  {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    -- not InsertEnter because I need it for commandline cmp too
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'L3MON4D3/LuaSnip', -- Snippets plugin
    },
    config = function()
      require("plugins/lsp/cmp")
    end,
  },
  { 'stevearc/vim-arduino', ft = "arduino", },

  -- Treesitter
  'windwp/nvim-ts-autotag',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/nvim-treesitter-context',
  'drybalka/tree-climber.nvim',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', },

  -- Additional language packs that treesitter doesn't support
  { 'elubow/cql-vim', ft = 'cql', },

  --  Utils
  {
    'darfink/vim-plist',
    ft={ "plist", "strings" },
    config = function ()
      vRequire("plugins/plist")
    end
  },
  {
    'ThePrimeagen/harpoon', -- needs plenary
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
      require('plugins/harpoon')
    end
  },
  {
    'mbbill/undotree',
    keys = { '<leader>u' },
    config = function ()
      vRequire('plugins/undotree')
    end
  },
  {
    'petertriho/nvim-scrollbar',
    event = 'VeryLazy',
    config = function ()
      require("scrollbar").setup()
    end
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function ()
      require("plugins/whichkey")
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function ()
      require("plugins/gitsigns")
    end
  },
  {
    'kylechui/nvim-surround', -- ys,ds,cs,ts
    event = 'VeryLazy',
    config = function ()
      require("nvim-surround").setup()
    end
  },
  {
    'ggandor/leap.nvim', -- breaking changes: https://github.com/ggandor/leap.nvim/issues/18
    event = 'VeryLazy',
    config = function ()
      require('plugins/leap')
    end
  },
  { "dstein64/vim-startuptime", cmd = "StartupTime", },
  'lukas-reineke/indent-blankline.nvim',
  'tpope/vim-commentary', -- gc
  'tpope/vim-repeat',
  'michaeljsmith/vim-indent-object', -- ii, ai, iI, aI
}, {
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock" .. (vim.g.is_windows and '.win' or '') .. ".json", -- lockfile generated after running update.
})

-- require helpers.lua first - it defines helper functions that other config files may use
require("helpers")

vRequire("main")

require("plugins/treesitter/treesitter")
require("plugins/treesitter/context")
require("plugins/treesitter/treeclimber")
require('plugins/lualine')
require('plugins/indent_blankline')

require("plugins/lsp/mason")
require("plugins/lsp/lsp")
pcall(function() require("plugins/lsp/my") end) -- this is for env specific lsp configs

-- theme needs to be at the end so the ColorScheme autocmds take effect
require("themes/theme")

-- client specific configs
vRequire("neovide")
