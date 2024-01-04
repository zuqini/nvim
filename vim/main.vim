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

" set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
"   \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"   \,sm:block-blinkwait175-blinkoff150-blinkon175
set guicursor=n-v-c-i-ci-ve:block,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" disable automatic comment insertion
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" disable F1 as it's easy to accidentally hit on the touchbar
nnoremap <F1> <nop>
inoremap <F1> <nop>

" buffers
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wq<CR>

nnoremap <leader>B :ls<cr>:bd<space>
nnoremap <leader><c-b> :%bd\|e#\|bd#<CR>

nnoremap <leader>R :so $MYVIMRC<CR>

" centering
" set scrolloff=999
nnoremap <leader>z :let &scrolloff=999-&scrolloff<CR>

" Esc in Terminal emulator
" See https://github.com/junegunn/fzf.vim/issues/544 for FZF
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

nnoremap <silent> <ESC><ESC> :nohlsearch \| :lua close_all_float()<CR>

" Movement
" nnoremap <C-k> 10k
" nnoremap <C-j> 10j
" vnoremap <C-k> 10k
" vnoremap <C-j> 10j

" more logical Y command (C => c$ and D => d$
" note: this is default in nvim. keeping mapping for vim compatibility
nnoremap Y y$

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}

nnoremap <silent><F5> :mod<CR>
vnoremap > >gv
vnoremap < <gv

" highlight without moving
nnoremap <silent><leader>u :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Using Tabs
nnoremap <silent><leader>gt :tab split<CR>
nnoremap <silent><leader>gT :tab new<CR>
nnoremap <silent><left> gT
nnoremap <silent><right> gt
nnoremap <silent><leader><left> :tabm -1<CR>
nnoremap <silent><leader><right> :tabm +1<CR>

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
" Yank Pasting only
nnoremap <silent><leader>d "0d
nnoremap <silent><leader>D "0D
vnoremap <silent><leader>d "0d
vnoremap <silent><leader>D "0D
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
nnoremap <silent>Q :call ToggleLocList()<CR>
nnoremap <silent><c-k> :lp<CR>
nnoremap <silent><c-j> :lne<CR>

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

" using // instead of /* */ for vim-commentary
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

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
