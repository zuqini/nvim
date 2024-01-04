let is_windows = has("win64") || has("win32") || has("win16")

call plug#begin(stdpath('data') . '/plugged')
  Plug 'junegunn/vim-plug'

  " Themes
  Plug 'zuqini/gruvbox-material'
  Plug 'EdenEast/nightfox.nvim'
  Plug 'rebelot/kanagawa.nvim'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua' " https://github.com/kyazdani42/nvim-tree.lua/issues/877

  " Telescope
  " Plug 'nvim-lua/plenary.nvim'
  " Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
  " Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " this might be shipped with telescope by default in the future

  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  if !is_windows
    Plug 'ibhagwan/fzf-lua' " fzf-lua is not supported on windows
  else
    Plug 'junegunn/fzf.vim'
  endif

  " Languages stuff
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'

  Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
  Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
  Plug 'L3MON4D3/LuaSnip' " Snippets plugin

  " Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
  Plug 'stevearc/vim-arduino'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'nvim-treesitter/nvim-treesitter-context'
  Plug 'drybalka/tree-climber.nvim'
  " Additional language packs that treesitter doesn't support
  Plug 'elubow/cql-vim' "CQL syntax highlight for cassandra

  " Utils
  Plug 'nvim-lua/plenary.nvim'
  Plug 'ThePrimeagen/harpoon' " needs plenary
  Plug 'darfink/vim-plist'
  Plug 'nvim-zh/colorful-winsep.nvim'
  Plug 'petertriho/nvim-scrollbar'
  Plug 'dstein64/vim-startuptime'
  Plug 'folke/which-key.nvim'
  Plug 'mbbill/undotree'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kylechui/nvim-surround' " ys,ds,cs,ts
  Plug 'tpope/vim-commentary' " gc
  Plug 'tpope/vim-repeat'
  Plug 'alvan/vim-closetag'

  Plug 'michaeljsmith/vim-indent-object' " ii, ai, iI, aI
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'ggandor/leap.nvim' " breaking changes: https://github.com/ggandor/leap.nvim/issues/18
call plug#end()
command! PU PlugUpdate | PlugUpgrade

function! RequireVim(path)
  exec "source " . stdpath('config') . '/vim/' . a:path . '.vim'
endfunction

" require helpers.lua first - it defines helper functions that other config files may use
lua require("helpers")

call RequireVim("main")
call RequireVim("neovide")

lua require("plugins/nvim-tree")

lua require("plugins/treesitter/treesitter")
lua require("plugins/treesitter/context")
lua require("plugins/treesitter/treeclimber")

lua require("plugins/lsp/mason")
lua require("plugins/lsp/lsp")
lua require("plugins/lsp/cmp")
lua pcall(function() require("plugins/lsp/my") end) -- this is for env specific lsp configs

lua require("plugins/lualine")
lua require("plugins/colorful-winsep")
lua require("plugins/gitsigns")
lua require("plugins/indent_blankline")
lua require("plugins/leap")
lua require("plugins/whichkey")
lua require("plugins/harpoon")
lua require("plugins/misc")
call RequireVim("plugins/undotree")
call RequireVim("plugins/closetag")
" call RequireVim("plugins/nutoggle")
call RequireVim("plugins/plist")

if !is_windows
  lua require("plugins/fzf-lua")
else
  call RequireVim("plugins/fzf")
endif

" theme needs to be at the end so the ColorScheme autocmds take effect
lua require("themes/theme")
