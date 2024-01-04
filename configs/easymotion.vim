" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
nmap s <Plug>(easymotion-overwin-f2)

nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap <Leader>t <Plug>(easymotion-bd-t)

nmap <Leader>w <Plug>(easymotion-w)
nmap <Leader>W <Plug>(easymotion-W)
nmap <Leader>e <Plug>(easymotion-e)
nmap <Leader>E <Plug>(easymotion-E)
nmap <Leader>b <Plug>(easymotion-b)
nmap <Leader>B <Plug>(easymotion-B)

nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)
nmap <Leader>l <Plug>(easymotion-lineforward)

"overwin doesn't work in visual mode
vmap s <Plug>(easymotion-bd-f2)

vmap <Leader>f <Plug>(easymotion-bd-f)
vmap <Leader>t <Plug>(easymotion-bd-t)

vmap <Leader>w <Plug>(easymotion-w)
vmap <Leader>W <Plug>(easymotion-W)
vmap <Leader>e <Plug>(easymotion-e)
vmap <Leader>E <Plug>(easymotion-E)
vmap <Leader>b <Plug>(easymotion-b)
vmap <Leader>B <Plug>(easymotion-B)

vmap <Leader>j <Plug>(easymotion-j)
vmap <Leader>k <Plug>(easymotion-k)
vmap <Leader>h <Plug>(easymotion-linebackward)
vmap <Leader>l <Plug>(easymotion-lineforward)

" disables Coc when easymotion is active
" See: https://github.com/easymotion/vim-easymotion/pull/437
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd   silent! CocEnable
