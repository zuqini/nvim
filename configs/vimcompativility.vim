" source: https://gist.github.com/laggardkernel/9013f948345212563ede9c9ee56c6b42
"
" We need to make vim reuse nvim's plugin manager, plugins, by changing runtimepath and packpath.
" In fact, the plugin paths are reused automatically, the following fix is reusing the plugin manger.

let g:is_nvim = has('nvim')
let g:is_vim8 = v:version >= 800 ? 1 : 0

" Reuse nvim's runtimepath and packpath in vim
if !g:is_nvim && g:is_vim8
  set runtimepath-=~/.vim
    \ runtimepath^=~/.local/share/nvim/site runtimepath^=~/.vim 
    \ runtimepath-=~/.vim/after
    \ runtimepath+=~/.local/share/nvim/site/after runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif
