let mapleader = " "

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
set incsearch
set hlsearch
set ignorecase smartcase
set laststatus=3
set nofixendofline
set cursorline
set scrolloff=8
set synmaxcol=512
set undofile

" block insert
" set guicursor=n-v-c-i-ci-ve:block,r-cr:hor20,o:hor50
"   \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"   \,sm:block-blinkwait175-blinkoff150-blinkon175
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

nnoremap <left> h
nnoremap <down> j
nnoremap <up> k
nnoremap <right> l

nnoremap <leader>w :w<CR>
nnoremap <leader>W :wq<CR>

nnoremap <leader>R :so $MYVIMRC<CR>
nnoremap <silent> <c-s> :cd %:p:h<CR>

" format json
nnoremap <leader>nq :%!jq<CR>
vnoremap <leader>nq :%!jq<CR>

" centering
" set scrolloff=999
nnoremap <leader>z :let &scrolloff=999-&scrolloff<CR>

" Esc in Terminal emulator
" See https://github.com/junegunn/fzf.vim/issues/544 for FZF
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

nnoremap <silent> <ESC><ESC> :nohlsearch \| :lua close_all_float()<CR>

nnoremap <silent><F5> :mod<CR>
vnoremap > >gv
vnoremap < <gv

" Using Tabs
" nnoremap <silent><leader>t :tab split<CR>
" nnoremap <silent><leader>T :tab new<CR>
" nnoremap <silent><left> gT
" nnoremap <silent><right> gt
" nnoremap <silent><leader><left> :tabm -1<CR>
" nnoremap <silent><leader><right> :tabm +1<CR>

" Buffer management
nnoremap <silent>,q :bd<CR>
nnoremap <silent>,Q :bd!<CR>
nnoremap <silent>,b :ls<cr>:bd<space>
nnoremap <silent>,B :%bd!\|e#\|bd!#<CR>
nnoremap <silent>[b :bp<CR>
nnoremap <silent>]b :bn<CR>

" go to file in new tab
nnoremap <silent> gF :tab split<CR>gf

" Windows
set splitbelow
set splitright
nnoremap <S-left> <C-W>4<
nnoremap <S-right> <C-W>4>
nnoremap <S-up> <C-W>4+
nnoremap <S-down> <C-W>4-

" Clipboard Copy Pasting
nnoremap <silent><leader>y "+y
nnoremap <silent><leader>Y "+y$
vnoremap <silent><leader>y "+y
vnoremap <silent><leader>Y "+Y
nnoremap <silent><leader>c "+y
nnoremap <silent><leader>C "+y$
vnoremap <silent><leader>c "+y
vnoremap <silent><leader>C "+Y
nnoremap <silent><leader>x "+d
nnoremap <silent><leader>X "+D
vnoremap <silent><leader>x "+d
vnoremap <silent><leader>X "+D
nnoremap <silent><leader>v "+p
nnoremap <silent><leader>V "+P
vnoremap <silent><leader>v "+p
vnoremap <silent><leader>V "+P

" Delete into oblivion
nnoremap <silent><leader>d "_d
nnoremap <silent><leader>D "_D
vnoremap <silent><leader>d "_d
vnoremap <silent><leader>D "_D

" Yank Pasting only
nnoremap <silent><leader>p "0p
nnoremap <silent><leader>P "0P
vnoremap <silent><leader>p "0p
vnoremap <silent><leader>P "0P

" quickfix
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

function! ToggleLocList()
  if empty(filter(getwininfo(), 'v:val.loclist'))
    lua vim.diagnostic.setloclist()
  else
    lclose
  endif
endfunction

nnoremap <silent><leader>q :call ToggleQuickFix()<CR>
nnoremap <silent><leader>k :cp<CR>
nnoremap <silent><leader>j :cn<CR>
nnoremap <silent><leader><up> :cp<CR>
nnoremap <silent><leader><down> :cn<CR>

nnoremap <silent>Q :call ToggleLocList()<CR>
nnoremap <silent><c-k> :lp<CR>
nnoremap <silent><c-j> :lne<CR>
nnoremap <silent><c-up> :lp<CR>
nnoremap <silent><c-down> :lne<CR>
nnoremap <silent><leader><left> :lp<CR>
nnoremap <silent><leader><right> :lne<CR>

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

" Augroups
augroup mainMiscCommands
  au!
  " disable automatic comment insertion
  au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  " highlight yank
  au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
  " using // instead of /* */ for vim-commentary
  au FileType c,cpp,cs,java setlocal commentstring=//\ %s
augroup END
