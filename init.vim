" set std_path_data for vim explicitly
let std_path_data = has('nvim') ? stdpath('data') : '~/.local/share/nvim'
let vim_plug_installed = !empty(glob(std_path_data . '/site/autoload/plug.vim'))
source $HOME/.config/nvim/configs/vimcompativility.vim

if !vim_plug_installed
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(std_path_data . '/plugged')
    " Themes
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'cocopon/iceberg.vim'

    Plug 'junegunn/vim-plug'
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
  source $HOME/.config/nvim/loader.vim
endif
