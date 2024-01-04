if has("win64") || has("win32") || has("win16")
  " use git bash for windows win32
  let $PATH = "C:\\Program\ Files\\Git\\usr\\bin;" . $PATH
endif

nnoremap S <cmd>lua require('fzf-lua').files()<CR>
nnoremap <leader>s <cmd>lua require('fzf-lua').live_grep()<CR>
nnoremap <leader>S <cmd>lua require('fzf-lua').live_grep_native()<CR>

nnoremap <leader>o <cmd>lua require('fzf-lua').oldfiles()<CR>

nnoremap <leader>gf <cmd>lua require('fzf-lua').git_files()<CR>
nnoremap <leader>gs <cmd>lua require('fzf-lua').git_status()<CR>
nnoremap <leader>gc <cmd>lua require('fzf-lua').git_commits()<CR>
nnoremap <leader>gb <cmd>lua require('fzf-lua').git_branches()<CR>

nnoremap <leader>t <cmd>lua require('fzf-lua').tabs()<CR>
nnoremap <leader>b <cmd>lua require('fzf-lua').buffers()<CR>

nnoremap <leader>fq <cmd>lua require('fzf-lua').quickfix()<CR>
nnoremap <leader>fQ <cmd>lua require('fzf-lua').loclist()<CR>

nnoremap <leader>lr <cmd>lua require('fzf-lua').lsp_references()<CR>
nnoremap <leader>ld <cmd>lua require('fzf-lua').lsp_definitions()<CR>
nnoremap <leader>lD <cmd>lua require('fzf-lua').lsp_declarations()<CR>
nnoremap <leader>lt <cmd>lua require('fzf-lua').lsp_typedefs()<CR>
nnoremap <leader>li <cmd>lua require('fzf-lua').lsp_implementations()<CR>
nnoremap <leader>lc <cmd>lua require('fzf-lua').lsp_code_actions()<CR>
nnoremap <leader>lsd <cmd>lua require('fzf-lua').lsp_document_symbols()<CR>
nnoremap <leader>lsw <cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>
nnoremap <leader>lsW <cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>

nnoremap <leader>lg <cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>
nnoremap <leader>lG <cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>

