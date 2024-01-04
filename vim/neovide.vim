if !exists("g:neovide")
  finish
endif

let g:neovide_input_macos_alt_is_meta=v:true
if !g:is_windows
  set guifont=FiraCode\ Nerd\ Font\ Mono:h18
else
  set guifont=FiraCode\ NF:h12
endif
let g:neovide_transparency=0.95
let g:neovide_scroll_animation_length=0.3
let g:neovide_cursor_animation_length=0.15
let g:neovide_cursor_trail_size=0.2

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

nnoremap <A-Up> :let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nnoremap <A-Down> :let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>
