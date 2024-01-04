" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-f)

nmap <Leader>f <Plug>(easymotion-f)
nmap <Leader>F <Plug>(easymotion-f)
nmap <Leader>t <Plug>(easymotion-t)
nmap <Leader>T <Plug>(easymotion-T)

nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)

"overwin doesn't work in visual mode
vmap s <Plug>(easymotion-bd-f2)
vmap S <Plug>(easymotion-bd-f)

vmap <Leader>f <Plug>(easymotion-f)
vmap <Leader>F <Plug>(easymotion-f)
vmap <Leader>t <Plug>(easymotion-t)
vmap <Leader>T <Plug>(easymotion-T)

vmap <Leader>j <Plug>(easymotion-j)
vmap <Leader>k <Plug>(easymotion-k)

" disables Coc when easymotion is active
" See: https://github.com/easymotion/vim-easymotion/pull/437
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd   silent! CocEnable
