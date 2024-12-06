function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

function! ToggleLocList()
  if empty(filter(getwininfo(), 'v:val.loclist'))
    lua if vim.lsp.buf_is_attached() then vim.diagnostic.setloclist() elseif not pcall(vim.cmd, 'lopen') then print('No location list') end
  else
    lclose
  endif
endfunction

function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;\(\)]*')
  let s:uri = escape(s:uri, '?=')
  let s:uri = escape(s:uri, '\')
  echo s:uri
  if s:uri != ""
    silent exec "lua require(\"utils\").open_url('" . s:uri . "')"
  else
    echo "No URI found in line."
  endif
endfunction

" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
