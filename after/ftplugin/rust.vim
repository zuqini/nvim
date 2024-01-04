augroup rustWritePost
    autocmd!
    autocmd BufWritePost * !cargo fmt
augroup END
