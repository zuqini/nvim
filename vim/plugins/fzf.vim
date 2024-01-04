" https://github.com/junegunn/fzf.vim/issues/185
" CTRL-W CTRL-Q to select all and build quickfix list
let $FZF_DEFAULT_OPTS = '--bind ctrl-w:select-all'
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

" junegunn/fzf.vim{{{
let g:fzf_colors = {
      \ 'fg': ['fg', 'CursorLine'],
      \ 'bg': ['bg', 'Normal'],
      \ 'hl': ['fg', 'Comment'],
      \ 'fg+': ['fg', 'Normal'],
      \ 'bg+': ['bg', 'CursorLine'],
      \ 'hl+': ['fg', 'Statement'],
      \ 'info': ['fg', 'PreProc'],
      \ 'prompt': ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker': ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header': ['fg', 'Comment'],
      \ 'gutter': ['bg', 'Normal']
      \ }
" }}}

nnoremap S :Files<CR>
nnoremap <leader>s :Rg<CR>
nnoremap <leader>o :History<CR>

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>,f :GFiles<CR>
nnoremap <leader>,s :GFiles?<CR>
nnoremap <leader>,c :Commits<CR>
nnoremap <leader>,x :BCommits<CR>

nnoremap <leader>nh :Helptags<CR>
nnoremap <leader>n; :History;<CR>
nnoremap <leader>n/ :History/<CR>
