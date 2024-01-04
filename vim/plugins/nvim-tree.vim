" https://github.com/kyazdani42/nvim-tree.lua/issues/674

" Uncomment to disable icons
" let g:nvim_tree_show_icons = {
"     \ 'git': 0,
"     \ 'folders': 0,
"     \ 'files': 0,
"     \ 'folder_arrows': 0,
"     \ }

nnoremap <s-tab> :NvimTreeToggle<CR>
nnoremap <c-n> :NvimTreeFindFile<CR>

function! DisableST()
  return " "
endfunction
au BufEnter NvimTree setlocal statusline=%!DisableST()

autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
