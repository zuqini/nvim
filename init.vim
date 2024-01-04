" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.config/nvim/loader.vim
else
  source $HOME/.config/nvim/loader.vim
endif

call plug#begin('~/.local/share/nvim/plugged')
    " Themes
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'cocopon/iceberg.vim'

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
":PlugInstall
