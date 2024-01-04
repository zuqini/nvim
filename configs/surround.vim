" see: https://github.com/tpope/vim-surround/blob/master/plugin/surround.vim#L599
let g:surround_no_mappings = 1

nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap cS  <Plug>CSurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
" changed from S to gs to avoid conflict with easymotion
xmap gs  <Plug>VSurround
xmap gS  <Plug>VgSurround
if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
  if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
    imap    <C-S> <Plug>Isurround
  endif
  imap      <C-G>s <Plug>Isurround
  imap      <C-G>S <Plug>ISurround
endif
