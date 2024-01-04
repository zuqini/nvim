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
    lazy = true,
    dependencies = {
      'kyazdani42/nvim-web-devicons'
    },
  },
  {
    'kyazdani42/nvim-tree.lua', -- https://github.com/kyazdani42/nvim-tree.lua/issues/877,
    dependencies = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require("plugins/nvim-tree")
    end,
    keys = {
      "<S-Tab>",
      "<Leader><Tab>",
    },
  },

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
  'ggandor/leap.nvim', -- breaking changes: https://github.com/ggandor/leap.nvim/issues/18
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
}, {
  defaults = {
  },
})


-- require helpers.lua first - it defines helper functions that other config files may use
require("helpers")

vRequire("main")
vRequire("neovide")


require("plugins/treesitter/treesitter")
require("plugins/treesitter/context")
require("plugins/treesitter/treeclimber")

require("plugins/lsp/mason")
require("plugins/lsp/lsp")
pcall(function() require("plugins/lsp/my") end) -- this is for env specific lsp configs

require("plugins/gitsigns")
require("plugins/indent_blankline")
require("plugins/leap")
require("plugins/whichkey")
require("plugins/harpoon")
require("plugins/misc")
vRequire("plugins/undotree")
vRequire("plugins/closetag")
-- call RequireVim("plugins/nutoggle")
vRequire("plugins/plist")

if vim.g.is_windows then
  vRequire("plugins/fzf")
else
  require("plugins/fzf-lua")
end

-- theme needs to be at the end so the ColorScheme autocmds take effect
require("themes/theme")

