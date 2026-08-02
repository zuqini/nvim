command! L :ZPack
command! LS :ZPack sync

" message history: noice's own view, or the ui2 pager
command! H execute get(g:, 'ui_engine', '') ==# 'noice' ? 'Noice' : "normal! g<"
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
  au TextYankPost * lua vim.hl.hl_op {higroup="IncSearch", timeout=150, on_visual=true}
augroup END

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter,CmdlineLeave * if g:hybrid_nu && &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave,CmdlineEnter   * if g:hybrid_nu && &nu                  | set nornu | redraw | endif
augroup END
