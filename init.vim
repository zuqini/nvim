let theme = 'spaceduck'

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" SETUP =======================================================================
let is_windows = has("win64") || has("win32") || has("win16")
" set std_path for vim8 explicitly
let g:std_path_data = has('nvim') ? stdpath('data') : '~/.local/share/nvim'
let g:std_path_config = has('nvim') ? stdpath('config') : '~/.config/nvim'

let vim_plug_installed = !empty(glob(g:std_path_data . '/site/autoload/plug.vim'))
exec "source " . g:std_path_config . "/configs/vimcompatibility.vim"

if !is_windows && !vim_plug_installed
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" END =======================================================================

call plug#begin(g:std_path_data . '/plugged')
  " Themes
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'cocopon/iceberg.vim'
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'embark-theme/vim', { 'as': 'embark' }

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

  " ds,cs,ts
  Plug 'tpope/vim-surround'
  " gc
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  Plug 'machakann/vim-highlightedyank'
  Plug 'jiangmiao/auto-pairs'
  Plug 'takac/vim-hardtime'
  Plug 'Yggdroot/indentLine'
  Plug 'easymotion/vim-easymotion'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'PhilRunninger/nerdtree-visual-selection'
  Plug 'Asheq/close-buffers.vim'
call plug#end()

if vim_plug_installed
  exec "source " . g:std_path_config . "/configs/themes/" . theme . ".vim"
  exec "source " . g:std_path_config . "/configs/main.vim"

  exec "source " . g:std_path_config . "/configs/goyolime.vim"
  exec "source " . g:std_path_config . "/configs/coc.vim"
  exec "source " . g:std_path_config . "/configs/fzf.vim"
  exec "source " . g:std_path_config . "/configs/nerdtree.vim"
  exec "source " . g:std_path_config . "/configs/easymotion.vim"
  exec "source " . g:std_path_config . "/configs/surround.vim"
  exec "source " . g:std_path_config . "/configs/nutoggle.vim"

  " Disabled
  " exec "source " . g:std_path_config . "/configs/hardmode.vim"
endif
