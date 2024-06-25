let mapleader = " "
" unnofficial leader2 = "<BS>"

nnoremap <leader>w :up<CR>
nnoremap <leader>W :up<CR>:MT<CR>

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
nnoremap <silent> <c-l> :lua clear_floats_and_highlights()<CR><c-l>

nnoremap <silent><F5> :mod<CR>
vnoremap > >gv
vnoremap < <gv

" Tabs
nnoremap <silent><leader>t1 1gt
nnoremap <silent><leader>t2 2gt
nnoremap <silent><leader>t3 3gt
nnoremap <silent><leader>t4 4gt
nnoremap <silent><leader>t5 5gt
nnoremap <silent><leader>6 6gt
nnoremap <silent><leader>t7 7gt
nnoremap <silent><leader>t8 8gt
nnoremap <silent><leader>t9 9gt
nnoremap <silent><leader>t0 :tablast<cr>
nnoremap <silent><leader>th :tabm -1<CR>
nnoremap <silent><leader>tl :tabm +1<CR>
nnoremap <silent>[t gT
nnoremap <silent>]t gt

" Buffer management
nnoremap <silent><BS> <c-^>
nnoremap <silent><leader><BS> :%bd!\|e#\|bd!#<CR>
nnoremap <silent>[b :bp<CR>
nnoremap <silent>]b :bn<CR>

" go to file in new tab
nnoremap <silent> gF :tab split<CR>gf

" Windows
nnoremap <s-left> <C-W><
nnoremap <s-right> <C-W>>
nnoremap <s-down> <C-W>-
nnoremap <s-up> <C-W>+

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
vnoremap <silent><leader>v "+P
vnoremap <silent><leader>V "+p

" Delete into oblivion
nnoremap <silent><leader>d "_d
nnoremap <silent><leader>D "_D
vnoremap <silent><leader>d "_d
vnoremap <silent><leader>D "_D

" paste does not overwrite register by default
xnoremap p P
xnoremap P p

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

function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "lua require(\"utils\").open_url('" . s:uri . "')"
  else
    echo "No URI found in line."
  endif
endfunction
nnoremap gx :call HandleURI()<cr>
