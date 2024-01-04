let mapleader = "\<space>"

call plug#begin(stdpath('data') . '/plugged')
" Themes
Plug 'ghifarit53/tokyonight-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'sheerun/vim-polyglot'
" install fzf first
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" note: for special commands like :Ag and :Rg, need to install additional
" dependencies. See: https://github.com/junegunn/fzf.vim
Plug 'junegunn/fzf.vim'
call plug#end()
":PlugInstall

" enable true color
set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

set number
set showcmd
set wildmenu
" show matching brackets
set showmatch

" highlight search
set incsearch
set hlsearch

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=10

" CUSTOM BINDINGS ==================================================
" <space> to unhighlight search
nnoremap <leader><space> :nohlsearch<CR>
" Ctrl-p to search for file
nnoremap <C-p> :Files<CR>
" p to search term within files
nnoremap <leader>p :Rg<CR>
" z open/closes folds
nnoremap <leader>z za
" Z open/closes folds recursively
nnoremap <leader>Z zA

" Auto-toggle hybrid/absolute line numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" hard mode to git gud ==================================================
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <BS> <Nop>
inoremap <BS> <Nop>
inoremap <Del> <Nop>
