let mapleader = "\<space>"

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
set laststatus=2

nnoremap <down> gj
nnoremap <up> gk

" disable F1 as it's easy to accidentally hit on the touchbar
nnoremap <F1> <nop>
inoremap <F1> <nop>

" buffers
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wq<CR>

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>B :ls<cr>:bd<space>
nnoremap <leader><c-b> :%bd\|e#\|bd#<CR>

nnoremap <leader>R :so $MYVIMRC<CR>

" centering
nnoremap <leader>z :let &scrolloff=999-&scrolloff<CR>

" Esc in Terminal emulator
" See https://github.com/junegunn/fzf.vim/issues/544 for FZF
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

nnoremap <silent> <leader><leader> :nohlsearch \| :lua close_all_float()<CR>

" Movement
" nnoremap <C-k> 10k
" nnoremap <C-j> 10j
" vnoremap <C-k> 10k
" vnoremap <C-j> 10j

" more logical Y command (C => c$ and D => d$
" note: this is default in nvim. keeping mapping for vim compatibility
nnoremap Y y$

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=350, on_visual=true}

nnoremap <silent><F5> :mod<CR>
vnoremap > >gv
vnoremap < <gv

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
nnoremap <C-v> "+p
vnoremap <C-x> "+d
vnoremap <C-c> "+y
vnoremap <C-v> "+p
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

nnoremap <silent>Q :call ToggleQuickFix()<CR>
nnoremap <silent><c-k> :cp<CR>
nnoremap <silent><c-j> :cn<CR>
nnoremap <silent><leader>q :call ToggleLocList()<CR>
nnoremap <silent><leader>k :lp<CR>
nnoremap <silent><leader>j :lne<CR>

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
