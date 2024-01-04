if is_windows
  " use git bash for windows win32
  let $PATH = "C:\\Program\ Files\\Git\\usr\\bin;" . $PATH
endif

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
nnoremap <leader>b :Buffers<CR>
