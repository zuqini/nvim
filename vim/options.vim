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

set scrolloff=4
set synmaxcol=512

set cursorline

" Neovim bug, see https://github.com/neovim/neovim/issues/18576
if !g:transparent_background
  set winblend=8
endif

set splitbelow
set splitright

set nofixendofline
set undofile

" Indentation without hard tabs
" https://vim.fandom.com/wiki/Indenting_source_code
filetype plugin indent on
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=10

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
