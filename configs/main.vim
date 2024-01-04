let mapleader = "\<space>"

" enable true color
set termguicolors

" Terminal emulator
tnoremap <Esc> <C-\><C-n>

" TokyoNight colorscheme settings
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 1
colorscheme tokyonight-custom
"colorscheme dracula
let g:lightline = {'colorscheme' : 'tokyonight'}
set laststatus=2

" disable <F1>
nmap <F1> <nop>
imap <F1> <nop>

set mouse=a
set number
set showcmd
set wildmenu
set showmatch " show matching brackets
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap <silent> <ESC><ESC> :nohlsearch \| match none \| 2match none \| call coc#float#close_all()<CR>

" Movement
nnoremap <C-h> 10h
nnoremap <C-l> 10l
nnoremap <C-k> 10k
nnoremap <C-j> 10j
vnoremap <C-h> 10h
vnoremap <C-l> 10l
vnoremap <C-k> 10k
vnoremap <C-j> 10j

" more logical Y command
" because C => c$ and D => d$
nnoremap Y y$

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=10
" zZ open/closes folds
nnoremap <leader>z za
nnoremap <leader>Z zA

" Using Tabs
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>T :windo bd!<CR> " close tab and kill all buffers within tab

" Windows
set splitbelow
set splitright
nnoremap <left> <C-W>4<
nnoremap <right> <C-W>4>
nnoremap <up> <C-W>4+
nnoremap <down> <C-W>4-
nnoremap <leader><C-h> <C-W>H
nnoremap <leader><C-l> <C-W>L
nnoremap <leader><C-k> <C-W>K
nnoremap <leader><C-j> <C-W>J
nnoremap <silent><F5> :mod<CR>

" copied from ITerm2 Hotkey
nnoremap <silent><leader>D :sp<CR>
nnoremap <silent><leader>d :vs<CR>

" Clipboard Copy Pasting
nnoremap <C-v> "*p
vnoremap <C-x> "*d
vnoremap <C-c> "*y
vnoremap <C-v> "*p
" Yank Pasting only
nnoremap <silent><leader>p "0p
nnoremap <silent><leader>p "0P
vnoremap <silent><leader>p "0p
vnoremap <silent><leader>p "0P

" Indentation without hard tabs
" https://vim.fandom.com/wiki/Indenting_source_code
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

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

" small plugins configs
nnoremap <silent> <leader>Q :Bdelete! menu<CR>
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
