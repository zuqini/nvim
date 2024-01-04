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
" <space> to unhighlight search
nnoremap <leader><esc> :nohlsearch<CR>

" FZF
" Ctrl-p to search for file
nnoremap <c-p> :Files<CR>
nnoremap <leader><c-p> :Files 
" p to search term within files
nnoremap <leader>p :Rg<CR>
nnoremap <leader>P :Ag<CR>

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=10
" zZ open/closes folds
nnoremap <leader>z za
nnoremap <leader>Z zA

" NERDTREE
nnoremap <s-tab> :NERDTreeToggle<CR>
nnoremap <c-n> :NERDTreeFind<CR>

nnoremap <leader>Q :Bdelete menu<CR>

" Using Tabs
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>T :windo bd<CR>

" Windows
set splitbelow
set splitright

" copied from ITerm2 Hotkey
nnoremap <leader>D :sp<CR>
nnoremap <leader>d :vs<CR>
" Smart way to move between windows
nnoremap <Left> <C-W>h
nnoremap <Down> <C-W>j
nnoremap <Up> <C-W>k
nnoremap <Right> <C-W>l

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

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

" hard mode to git gud =============================================
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_insert_keys = []
let g:list_of_disabled_keys = []
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <BS> <Nop>
inoremap <Del> <Nop>
