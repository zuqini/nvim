let g:goyo_width='85%'
let g:goyo_height = '85%'
let g:goyo_linenr = 1
nnoremap <leader>g :Goyo<CR>
nnoremap <leader>G :Limelight!!<CR>

let g:limelight_paragraph_span = 2
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 246
" Color name (:help gui-colors) or RGB color
" taken from tokyonight-custom.vim (Original Grey color)
let g:limelight_conceal_guifg = '#444b6a'

function! s:goyo_enter()
  Limelight
  " disable nu toggling for true zen
  let g:disable_nu_toggle = 1
  set nu nornu
endfunction

function! s:goyo_leave()
  Limelight!
  let g:disable_nu_toggle = 0
  set nu rnu
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
