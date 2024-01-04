let mapleader = "\<space>"

call plug#begin(stdpath('data') . '/plugged')
" Themes
Plug 'ghifarit53/tokyonight-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

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
nnoremap <leader>Q :Bdelete menu<CR>

" Using Tabs
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>T :windo bd!<CR> " close tab and kill all buffers within tab

" Windows
set splitbelow
set splitright
nnoremap <left> <C-W>h
nnoremap <right> <C-W>l
nnoremap <up> <C-W>k
nnoremap <down> <C-W>j

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
" Tabs Indicator for *WHITE SPACE* I.E. expandtab setting
" Colors taken from tokyonight-custom bg4
" Ideally should use default highlight group, but doesn't seem to work
" See: https://github.com/Yggdroot/indentLine/issues/339
" and https://github.com/ghifarit53/tokyonight-vim/issues/20
let g:indentLine_char = '│'
let g:indentLine_color_term = 237
let g:indentLine_color_gui = '#444b6a'

" whitespace characters
set list
set showbreak=↪\
set listchars=tab:→\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
" other listchars:
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
"set listchars=tab:\|\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
