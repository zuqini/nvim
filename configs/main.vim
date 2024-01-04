" vim8 does not have stdpath, manually fill in nvim plugin path
let nvimPluggedPath = g:is_nvim ? stdpath('data') . '/plugged' : '~/.local/share/nvim/plugged'

call plug#begin(nvimPluggedPath)
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

let mapleader = "\<space>"
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

" Terminal emulator
tnoremap <Esc> <C-\><C-n>

" more logical Y command
" because C => c$ and D => d$
nnoremap Y y$
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
nnoremap <silent> <C-q> :Bdelete menu<CR>
nnoremap <silent> <leader>Q :Bdelete! menu<CR>

" Using Tabs
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>T :windo bd!<CR> " close tab and kill all buffers within tab

" Windows
set splitbelow
set splitright
nnoremap <C-h> <C-W>4<
nnoremap <C-l> <C-W>4>
nnoremap <C-k> <C-W>4+
nnoremap <C-j> <C-W>4-
nnoremap <left> <C-W>h
nnoremap <right> <C-W>l
nnoremap <up> <C-W>k
nnoremap <down> <C-W>j
nnoremap <leader><left> <C-W>H
nnoremap <leader><right> <C-W>L
nnoremap <leader><up> <C-W>K
nnoremap <leader><down> <C-W>J
nnoremap <silent><F5> :mod<CR>

" copied from ITerm2 Hotkey
nnoremap <leader>D :sp<CR>
nnoremap <leader>d :vs<CR>

" Clipboard Copy Pasting
nnoremap <leader>x "*d
nnoremap <leader>c "*y
nnoremap <leader>v "*p
vnoremap <leader>x "*d
vnoremap <leader>c "*y
vnoremap <leader>v "*p

" Indentation without hard tabs
" https://vim.fandom.com/wiki/Indenting_source_code
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

let g:indentLine_char = '│'
" indentLine defaults conceal level to 2 (it won't work with conceal level 0)
" setting conceal level for specific file types manually
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" whitespace characters
" other listchars:
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
"set listchars=tab:\|\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
set list
set showbreak=↪\
set listchars=tab:→\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
