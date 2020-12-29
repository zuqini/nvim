" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
nmap <leader>s <Plug>(easymotion-bd-t2)
nmap <leader>S <Plug>(easymotion-bd-t)
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-f)
nmap <Leader>l <Plug>(easymotion-lineforward)
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)

" disables Coc when easymotion is active
" See: https://github.com/easymotion/vim-easymotion/pull/437
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd   silent! CocEnable
