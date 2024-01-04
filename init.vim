let theme = 'spaceduck'

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" BOOTSTRAP PLUG =============================================================
let is_windows = has("win64") || has("win32") || has("win16")

let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let vim_plug_installed = !empty(glob(autoload_plug_path))
if !is_windows
  if !vim_plug_installed
    silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  endif

  " Run PlugInstall if there are missing plugins
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
  \| endif
endif

unlet autoload_plug_path
" END ========================================================================

call plug#begin(stdpath('data') . '/plugged')
  " Themes
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'nvim-lualine/lualine.nvim'

  Plug 'preservim/nerdtree'
  Plug 'PhilRunninger/nerdtree-visual-selection'

  Plug 'junegunn/vim-plug'
  Plug 'junegunn/vim-peekaboo'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " note for fzf.vim: for special commands like :Ag and :Rg, need to install additional
  " dependencies. See: https://github.com/junegunn/fzf.vim

  " ys,ds,cs,ts
  Plug 'tpope/vim-surround'
  " gc
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  " ii, ai, iI, aI
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'psliwka/vim-smoothie'
  Plug 'jiangmiao/auto-pairs'
  Plug 'takac/vim-hardtime'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
call plug#end()

let vim_configs_path = stdpath('config') . '/vim'
if vim_plug_installed
  exec "source " . vim_configs_path . "/themes/" . theme . ".vim"
  exec "source " . vim_configs_path . "/main.vim"

  lua require('main')
endif
