" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" Augroups
augroup mainMiscCommands
  au!
  " disable automatic comment insertion
  au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  " highlight yank
  au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
  " using // instead of /* */ for vim-commentary
  au FileType c,cpp,cs,java setlocal commentstring=//\ %s
augroup END
