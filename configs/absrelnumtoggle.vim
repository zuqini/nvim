" Auto-toggle hybrid/absolute line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber | let NERDTreeShowLineNumbers=0
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber | let NERDTreeShowLineNumbers=0
augroup END
