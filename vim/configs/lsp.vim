fun! LspLocationList()
  lua vim.diagnostic.setloclist({open = false})
endfun

augroup LSP
    autocmd! BufWrite,BufEnter,InsertLeave * :call LspLocationList()
augroup END
