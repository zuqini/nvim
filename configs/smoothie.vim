let g:smoothie_no_default_mappings = 1

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : smoothie#forwards()
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : smoothie#backwards()
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : smoothie#forwards()
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : smoothie#backwards()
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : smoothie#forwards()
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : smoothie#backwards()

  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1, 1) : smoothie#downwards()
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0, 1) : smoothie#upwards()
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : smoothie#downwards()
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : smoothie#upwards()
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1, 1) : smoothie#downwards()
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0, 1) : smoothie#upwards()
else
  silent! map <unique> <C-D>      <Plug>(SmoothieDownwards)
  silent! map <unique> <C-U>      <Plug>(SmoothieUpwards)
  silent! map <unique> <C-B>      <Plug>(SmoothieBackwards)
  silent! map <unique> <C-F>      <Plug>(SmoothieForwards)
endif

silent! map <unique> <S-Down>   <Plug>(SmoothieForwards)
silent! map <unique> <PageDown> <Plug>(SmoothieForwards)
silent! map <unique> <S-Up>     <Plug>(SmoothieBackwards)
silent! map <unique> <PageUp>   <Plug>(SmoothieBackwards)
silent! map <unique> gg         <Plug>(Smoothie_gg)
silent! map <unique> G          <Plug>(Smoothie_G)
