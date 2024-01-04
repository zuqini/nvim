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

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  -- Themes
  'zuqini/gruvbox-material',
  'EdenEast/nightfox.nvim',
  'rebelot/kanagawa.nvim',
  {
    'folke/tokyonight.nvim',
    branch = 'main'
  },
  {
    'pineapplegiant/spaceduck',
    branch= 'main'
  },

  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-web-devicons', -- for file icons
  'kyazdani42/nvim-tree.lua', -- https://github.com/kyazdani42/nvim-tree.lua/issues/877,

  -- Telescope
  -- 'nvim-lua/plenary.nvim',
  -- {
  --   'nvim-telescope/telescope.nvim',
  --   branch = '0.1.x'
  -- },
  -- {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   build = 'make'
  -- }, -- this might be shipped with telescope by default in the future

  -- FZF
  { 'junegunn/fzf', build = './install --bin' },
  'ibhagwan/fzf-lua',
  'junegunn/fzf.vim',

  -- Languages stuff
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
  'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
  'L3MON4D3/LuaSnip', -- Snippets plugin

  -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'stevearc/vim-arduino',

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/nvim-treesitter-context',
  'drybalka/tree-climber.nvim',
  -- Additional language packs that treesitter doesn't support
  'elubow/cql-vim', -- CQL syntax highlight for cassandra

  --  Utils
  'nvim-lua/plenary.nvim',
  'ThePrimeagen/harpoon', -- needs plenary
  'darfink/vim-plist',
  'petertriho/nvim-scrollbar',
  'dstein64/vim-startuptime',
  'folke/which-key.nvim',
  'mbbill/undotree',
  'lewis6991/gitsigns.nvim',
  'kylechui/nvim-surround', -- ys,ds,cs,ts
  'tpope/vim-commentary', -- gc
  'tpope/vim-repeat',
  'alvan/vim-closetag',

  'michaeljsmith/vim-indent-object', -- ii, ai, iI, aI
  'lukas-reineke/indent-blankline.nvim',
  'ggandor/leap.nvim', -- breaking changes: https://github.com/ggandor/leap.nvim/issues/18
})

function requireVim(path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path .. '.vim')
end

-- require helpers.lua first - it defines helper functions that other config files may use
require("helpers")

requireVim("main")
requireVim("neovide")

require("plugins/nvim-tree")

require("plugins/treesitter/treesitter")
require("plugins/treesitter/context")
require("plugins/treesitter/treeclimber")

require("plugins/lsp/mason")
require("plugins/lsp/lsp")
require("plugins/lsp/cmp")
pcall(function() require("plugins/lsp/my") end) -- this is for env specific lsp configs

require("plugins/lualine")
require("plugins/gitsigns")
require("plugins/indent_blankline")
require("plugins/leap")
require("plugins/whichkey")
require("plugins/harpoon")
require("plugins/misc")
requireVim("plugins/undotree")
requireVim("plugins/closetag")
-- call RequireVim("plugins/nutoggle")
requireVim("plugins/plist")

if vim.g.is_windows then
  requireVim("plugins/fzf")
else
  require("plugins/fzf-lua")
end

-- theme needs to be at the end so the ColorScheme autocmds take effect
require("themes/theme")

