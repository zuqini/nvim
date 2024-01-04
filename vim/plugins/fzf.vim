if has("win64") || has("win32") || has("win16")
  " use git bash for windows win32
  let $PATH = "C:\\Program\ Files\\Git\\usr\\bin;" . $PATH
endif

nnoremap S :Files<CR>
nnoremap <c-p> :Files<space>

nnoremap <leader>s :Rg<CR>
nnoremap <leader>S :Ag<CR>
