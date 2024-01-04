let theme = 'spaceduck'

" BOOTSTRAP PLUG =============================================================
let is_windows = has("win64") || has("win32") || has("win16")

let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let vim_plug_installed = !empty(glob(autoload_plug_path))
if !is_windows
  if !vim_plug_installed
    silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  endif
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

unlet autoload_plug_path
" END ========================================================================

call plug#begin(stdpath('data') . '/plugged')
  Plug 'junegunn/vim-plug'

  " Themes
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua' " deprecation notice: https://github.com/kyazdani42/nvim-tree.lua/issues/877

  " Telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " this might be shipped with telescope by default in the future

  " FZF
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " Plug 'junegunn/fzf.vim'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
  Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
  Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
  Plug 'L3MON4D3/LuaSnip' " Snippets plugin

  " Utils
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'tpope/vim-surround' " ys,ds,cs,ts
  Plug 'tpope/vim-commentary' " gc
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  Plug 'michaeljsmith/vim-indent-object' " ii, ai, iI, aI
  Plug 'junegunn/vim-peekaboo'
  Plug 'jiangmiao/auto-pairs'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'sheerun/vim-polyglot'
call plug#end()

if vim_plug_installed
  let vim_configs_path = stdpath('config') . '/vim'

  " NOTE: order is important
  " 1. helpers.lua defines helper functions that other config files may use
  " 2. theme should be before everything else since some plugins need the theme to be set prior to setup
  " 3. nvim-tree.vim needs to execute before nvim-tree

  lua require("helpers")

  exec "source " . vim_configs_path . "/themes/" . theme . ".vim"
  exec "source " . vim_configs_path . "/main.vim"
  exec "source " . vim_configs_path . "/plugins/surround.vim"

  " exec "source " . vim_configs_path . "/plugins/fzf.vim"

  lua require("plugins/telescope")
  exec "source " . vim_configs_path . "/plugins/telescope.vim"

  exec "source " . vim_configs_path . "/plugins/nvim-tree.vim"
  lua require("plugins/nvim-tree")

  lua require("plugins/indent_blankline")
  lua require("plugins/lualine")
  lua require("plugins/hop")
  lua require("plugins/lsp")
  lua require("plugins/treesitter")
endif
