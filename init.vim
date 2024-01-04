call plug#begin(stdpath('data') . '/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

" enable true color
set termguicolors

" theme
colorscheme dracula

set number
set showcmd
set wildmenu
" show brackets
set showmatch

" highlight search
set incsearch
set hlsearch
" \<space> to unhighlight search
nnoremap <leader><space> :nohlsearch<CR>

" code folding
set foldenable
set foldlevelstart=10
set foldmethod=indent
" <space> to unfold
nnoremap <space> za
