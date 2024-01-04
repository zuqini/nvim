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

call plug#begin(g:std_path_data . '/plugged')
  " Themes
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'cocopon/iceberg.vim'

  Plug 'junegunn/vim-plug'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'takac/vim-hardtime'
  Plug 'Yggdroot/indentLine'
  Plug 'easymotion/vim-easymotion'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'Asheq/close-buffers.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " note for fzf.vim: for special commands like :Ag and :Rg, need to install additional
  " dependencies. See: https://github.com/junegunn/fzf.vim
call plug#end()

if vim_plug_installed
  exec "source " . g:std_path_config . "/loader.vim"
endif
