command! L :Lazy
command! LS :Lazy sync

" set current dir
command! CD :cd %:p:h

" literal search
command! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n
command! -nargs=1 S :let @/='\V'.escape(<q-args>, '\\')| normal! n

" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* SearchMulti call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>
command! -bang -nargs=* SM call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

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

augroup TransparentBackground
  " transparent bg
  autocmd vimenter * if g:transparent_background | hi Normal guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi NormalNC guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi Terminal guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi SignColumn guibg=NONE ctermbg=NONE

  autocmd vimenter * if g:transparent_background | hi TelescopeBorder guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi TelescopePromptNormal guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi TelescopePreviewNormal guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi TelescopeResultsNormal guibg=NONE ctermbg=NONE

  autocmd vimenter * if g:transparent_background | hi DiagnosticVirtualTextOk guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi DiagnosticVirtualTextHint guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi DiagnosticVirtualTextInfo guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi DiagnosticVirtualTextWarn guibg=NONE ctermbg=NONE
  autocmd vimenter * if g:transparent_background | hi DiagnosticVirtualTextError guibg=NONE ctermbg=NONE
augroup END
