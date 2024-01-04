if exists("g:neovide")
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
endif
