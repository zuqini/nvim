nnoremap <s-tab> :NERDTreeToggle<CR>
nnoremap <c-n> :NERDTreeFind<CR>

let NERDTreeShowLineNumbers=0

" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
"autocmd BufWinEnter * silent NERDTreeMirror
