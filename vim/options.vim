if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set mouse=a
set hidden
set number
set showcmd
set wildmenu
set showmatch " show matching brackets
set noshowmode
set incsearch
set hlsearch
set ignorecase smartcase
set laststatus=3

set scrolloff=8
set synmaxcol=512

set cursorline
set pumblend=6
set winblend=6

set splitbelow
set splitright

set nofixendofline
set undofile

" Indentation without hard tabs
" https://vim.fandom.com/wiki/Indenting_source_code
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=10

" block insert
" set guicursor=n-v-c-i-ci-ve:block,r-cr:hor20,o:hor50
"   \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"   \,sm:block-blinkwait175-blinkoff150-blinkon175
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" whitespace characters
" other listchars:
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
"set listchars=tab:\|\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
set list
set showbreak=↪\
if &encoding == "utf-8"
  set listchars=tab:│\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
else
  set listchars=tab:\|\ ,nbsp:·,trail:·,extends:⟩,precedes:⟨
endif
