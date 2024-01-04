let is_windows = has("win64") || has("win32") || has("win16")
call plug#begin(stdpath('data') . '/plugged')
  Plug 'junegunn/vim-plug'

  " Themes
  Plug 'sainnhe/gruvbox-material'
  Plug 'EdenEast/nightfox.nvim'
  Plug 'rebelot/kanagawa.nvim'
  Plug 'sam4llis/nvim-tundra'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua' " deprecation notice: https://github.com/kyazdani42/nvim-tree.lua/issues/877

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

  Plug 'stevearc/vim-arduino'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
  Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
  Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
  Plug 'L3MON4D3/LuaSnip' " Snippets plugin
  " Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-context'
  " Additional language packs that treesitter doesn't support
  Plug 'elubow/cql-vim' "CQL syntax highlight for cassandra

  " Wildmenu
  " see https://github.com/gelguy/wilder.nvim/issues/109
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

  " Utils
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'tpope/vim-surround' " ys,ds,cs,ts
  Plug 'tpope/vim-commentary' " gc
  Plug 'tpope/vim-repeat'
  Plug 'alvan/vim-closetag'

  Plug 'michaeljsmith/vim-indent-object' " ii, ai, iI, aI
  Plug 'junegunn/vim-peekaboo'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'ggandor/leap.nvim'
call plug#end()
command! PU PlugUpdate | PlugUpgrade

function! RequireVim(path)
  exec "source " . stdpath('config') . '/vim/' . a:path . '.vim'
endfunction

" Order is important
" 1. helpers.lua defines helper functions that other config files may use
" 2. theme should be before everything else since some plugins need the theme to be set prior to setup
" 3. nvim-tree.vim needs to execute before nvim-tree
lua require("helpers")
call RequireVim("main")
lua require("themes/theme")

lua require("plugins/nvim-tree")

lua require("plugins/treesitter")
lua require("plugins/leap")

lua require("plugins/lsp/mason")
lua require("plugins/lsp/main")
lua require("plugins/lsp/additional")
lua require("plugins/lsp/my")

lua require("plugins/lualine")
lua require("plugins/gitsigns")
lua require("plugins/indent_blankline")
call RequireVim("plugins/surround")
call RequireVim("plugins/wilder")
call RequireVim("plugins/closetag")
call RequireVim("plugins/nutoggle")

if !is_windows
  lua require("plugins/fzf-lua")
else
  call RequireVim("plugins/fzf")
endif
