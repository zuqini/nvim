if is_windows
  " use git bash for windows win32
  let $PATH = "C:\\Program\ Files\\Git\\usr\\bin;" . $PATH
endif

nnoremap S :Files<CR>

nnoremap <leader>s :Rg<CR>
nnoremap <leader>b :Buffers<CR>
