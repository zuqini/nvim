let mapleader = "\<space>"

call plug#begin(stdpath('data') . '/plugged')
" Themes
Plug 'ghifarit53/tokyonight-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'takac/vim-hardtime'
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

" enable true color
set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight-custom
let g:lightline = {'colorscheme' : 'tokyonight'}

set mouse=a
set number
set showcmd
set wildmenu
set showmatch " show matching brackets

" highlight search
set incsearch
set hlsearch
set ignorecase
set smartcase
" <space> to unhighlight search and close coc float menus
nnoremap <silent> <ESC><ESC> :nohlsearch \| match none \| 2match none \| call coc#float#close_all()<CR>

" smaller scroll to be less jarring
nnoremap <C-d> 20<C-d>
nnoremap <C-u> 20<C-u>

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=10
" zZ open/closes folds
nnoremap <leader>z za
nnoremap <leader>Z zA

" Kill buffers
nnoremap <leader>Q :Bdelete menu<CR>

" Using Tabs
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>T :windo bd<CR>

" Windows
set splitbelow
set splitright
nnoremap <left> gT
nnoremap <right> gt

" copied from ITerm2 Hotkey
nnoremap <leader>D :sp<CR>
nnoremap <leader>d :vs<CR>
" Smart way to move between windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Clipboard Copy Pasting
nnoremap <leader>x "*d
nnoremap <leader>c "*y
nnoremap <leader>v "*p
vnoremap <leader>x "*d
vnoremap <leader>c "*y
vnoremap <leader>v "*p

" Indentation with mixed tabs and spaces
" https://vim.fandom.com/wiki/Indenting_source_code
set autoindent
set noexpandtab
set shiftwidth=4
set softtabstop=4

" Auto-toggle hybrid/absolute line numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

