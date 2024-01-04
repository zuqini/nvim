" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-f)
nmap <leader>s <Plug>(easymotion-bd-t2)
nmap <leader>S <Plug>(easymotion-bd-t)
nmap <Leader>l <Plug>(easymotion-lineforward)
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)

"overwin doesn't work in visual mode
vmap s <Plug>(easymotion-bd-f2)
vmap S <Plug>(easymotion-bd-f)
vmap <leader>s <Plug>(easymotion-bd-t2)
vmap <leader>S <Plug>(easymotion-bd-t)
vmap <Leader>l <Plug>(easymotion-lineforward)
vmap <Leader>j <Plug>(easymotion-j)
vmap <Leader>k <Plug>(easymotion-k)
vmap <Leader>h <Plug>(easymotion-linebackward)

" disables Coc when easymotion is active
" See: https://github.com/easymotion/vim-easymotion/pull/437
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd   silent! CocEnable
