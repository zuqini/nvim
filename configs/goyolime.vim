let g:goyo_width='160'
let g:goyo_height = '85%'
nnoremap <leader>g :Goyo<CR>

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = '#777777'

function! s:goyo_enter()
  Limelight
  " disable nu toggling for true zen
  let g:disable_nu_toggle = 1
  " goyo already does this implicitly, but nutoggle.viC-m overwrites this
  " setting because its autocmd runs later
  setlocal nonu nornu
endfunction

function! s:goyo_leave()
  Limelight!
  let g:disable_nu_toggle = 0
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
