command! L :Lazy
command! LS :Lazy sync

command! H :Noice
command! M :messages

command! -bang -nargs=* SearchMulti call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>
command! -bang -nargs=* SM call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

command! DM :delm! | delm A-Z0-9

" literal search
command! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n
command! -nargs=1 S :let @/='\V'.escape(<q-args>, '\\')| normal! n

" ctags
command! MakeTags !ctags -R --exclude=.git --exclude=node_modules --exclude=test
command! MT silent :MakeTags

" set current working directory
command! CD :cd %:p:h

" transparent bg
autocmd vimenter * lua require('utils').set_transparent_background()

" Augroups
augroup mainMiscCommands
  au!
  " disable automatic comment insertion
  au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  " highlight yank
  au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
augroup END

" Make sure this one goes before theme is loaded. Needed for LSP float
augroup CustomFloatColors
  au!
  au ColorScheme * highlight! link NormalFloat Normal
  au ColorScheme * highlight! link FloatBorder Normal
augroup END

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter,CmdlineLeave * if g:hybrid_nu && &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave,CmdlineEnter   * if g:hybrid_nu && &nu                  | set nornu | redraw | endif
augroup END
