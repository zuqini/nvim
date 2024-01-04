augroup rustWritePost
    autocmd!
    autocmd BufWritePost * exe ':!cargo fmt' | redraw
augroup END
