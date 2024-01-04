" Auto-toggle hybrid/absolute line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if !exists('g:disable_nu_toggle') || !g:disable_nu_toggle | set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * if !exists('g:disable_nu_toggle') || !g:disable_nu_toggle | set norelativenumber
augroup END
