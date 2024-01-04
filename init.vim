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

" code folding
set foldenable
set foldlevelstart=10
set foldmethod=indent

" CUSTOM BINDINGS ==================================================
" \<space> to unhighlight search
nnoremap <leader><esc> :nohlsearch<CR>
" Ctrl-p to search for file
nnoremap <C-p> :Files<CR>
" \p to search term within files
nnoremap <leader>p :Rg<CR>
" space to fold/unfold code
nnoremap <leader><space> za

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
