let is_windows = has("win64") || has("win32") || has("win16")
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let vim_plug_installed = !empty(glob(autoload_plug_path))
if !is_windows
  if !vim_plug_installed
    silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  endif
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin(stdpath('data') . '/plugged')
  Plug 'junegunn/vim-plug'

  " Themes
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'morhetz/gruvbox'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'rebelot/kanagawa.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua' " deprecation notice: https://github.com/kyazdani42/nvim-tree.lua/issues/877

  " Telescope
  " Plug 'nvim-lua/plenary.nvim'
  " Plug 'nvim-telescope/telescope.nvim'
  " Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " this might be shipped with telescope by default in the future

  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  if !is_windows
    Plug 'ibhagwan/fzf-lua' " fzf-lua is not supported on windows
  else
    Plug 'junegunn/fzf.vim'
  endif

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
  Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
  Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
  Plug 'L3MON4D3/LuaSnip' " Snippets plugin

  " Wildmenu
  " see https://github.com/gelguy/wilder.nvim/issues/109
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

  " " Utils
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'rstacruz/vim-closer'
  Plug 'tpope/vim-surround' " ys,ds,cs,ts
  Plug 'tpope/vim-commentary' " gc
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  Plug 'michaeljsmith/vim-indent-object' " ii, ai, iI, aI
  Plug 'junegunn/vim-peekaboo'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'sheerun/vim-polyglot'
call plug#end()

function! RequireVim(path)
  exec "source " . stdpath('config') . '/vim/' . a:path . '.vim'
endfunction

if vim_plug_installed
  let vim_configs_path = stdpath('config') . '/vim'

  " Order is important
  " 1. helpers.lua defines helper functions that other config files may use
  " 2. theme should be before everything else since some plugins need the theme to be set prior to setup
  " 3. nvim-tree.vim needs to execute before nvim-tree

  lua require("helpers")
  call RequireVim("main")
  lua require("themes/theme")

  call RequireVim("plugins/nvim-tree")
  lua require("plugins/nvim-tree")

  lua require("plugins/treesitter")
  lua require("plugins/lsp")
  lua require("plugins/lualine")
  lua require("plugins/hop")
  lua require("plugins/indent_blankline")
  call RequireVim("plugins/surround")
  call RequireVim("plugins/wilder")

  if !is_windows
    lua require("plugins/fzf-lua")
    call RequireVim("plugins/fzf-lua")
  else
    call RequireVim("plugins/fzf")
  endif
endif
