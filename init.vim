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

  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim' " for :Ag and :Rg, See: https://github.com/junegunn/fzf.vim

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'

  " Utils
  Plug 'tpope/vim-surround' " ys,ds,cs,ts
  Plug 'tpope/vim-commentary' " gc
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  Plug 'michaeljsmith/vim-indent-object' " ii, ai, iI, aI
  Plug 'junegunn/vim-peekaboo'
  Plug 'psliwka/vim-smoothie'
  Plug 'jiangmiao/auto-pairs'
  Plug 'takac/vim-hardtime'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'sheerun/vim-polyglot'
call plug#end()

if vim_plug_installed
  " VIMSCRIPT configs
  let vim_configs_path = stdpath('config') . '/vim'
  exec "source " . vim_configs_path . "/themes/" . theme . ".vim"
  exec "source " . vim_configs_path . "/main.vim"
  exec "source " . vim_configs_path . "/configs/fzf.vim"
  exec "source " . vim_configs_path . "/configs/nvim-tree.vim"
  exec "source " . vim_configs_path . "/configs/surround.vim"

  " LUA configs
  lua require('main')
  lua require("configs/lualine")
  lua require("configs/hop")
  lua require("configs/nvim-tree")
  lua require("configs/lsp")

  " Disabled configs
  " exec "source " . vim_configs_path . "/configs/configs/hardmode.vim"
  " exec "source " . vim_configs_path . "/configs/nutoggle.vim"
endif
