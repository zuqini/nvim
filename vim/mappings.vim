let mapleader = " "

nnoremap <leader>w :w<CR>
nnoremap <leader>W :wq<CR>

nnoremap <silent> <c-s> :cd %:p:h<CR>
nnoremap <leader>R :put=execute(':')<left><left>

" format json
nnoremap <leader>gq :%!jq<CR>
vnoremap <leader>gq :%!jq<CR>

" centering
" set scrolloff=999
nnoremap <leader>z :let &scrolloff=999-&scrolloff<CR>

" Esc in Terminal emulator
" See https://github.com/junegunn/fzf.vim/issues/544 for FZF
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

nnoremap <silent> <Esc><Esc> :nohlsearch \| :lua close_all_float()<CR>

nnoremap <silent><F5> :mod<CR>
vnoremap > >gv
vnoremap < <gv

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
