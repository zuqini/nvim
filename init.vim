let mapleader = "\<space>"

call plug#begin(stdpath('data') . '/plugged')
" Themes
Plug 'ghifarit53/tokyonight-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " install fzf first
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

set number
set showcmd
set wildmenu
set showmatch " show matching brackets

" highlight search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=10

" Indentation with mixed tabs and spaces
" https://vim.fandom.com/wiki/Indenting_source_code
set autoindent
set noexpandtab
set shiftwidth=4
set softtabstop=4

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
