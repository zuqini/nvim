if exists("g:neovide")
  set guifont=FiraCode\ Nerd\ Font\ Mono:h18
  let g:neovide_transparency=0.95
  let g:neovide_scroll_animation_length=0.3
  let g:neovide_cursor_animation_length=0.15
  let g:neovide_cursor_trail_size=0.1

  " system clipboard
  nmap <d-c> "+y
  vmap <d-c> "+y
  nmap <d-v> "+p
  inoremap <d-v> <c-r>+
  cnoremap <d-v> <c-r>+
  tnoremap <expr> <d-v> "<c-\><c-n>\"+Pi"

  nnoremap <D-Up> :silent! let &guifont = substitute(
   \ &guifont,
   \ ':h\zs\d\+',
   \ '\=eval(submatch(0)+1)',
   \ '')<CR>
  nnoremap <D-Down> :silent! let &guifont = substitute(
   \ &guifont,
   \ ':h\zs\d\+',
   \ '\=eval(submatch(0)-1)',
   \ '')<CR>
endif
