local vscode = require('vscode')

local nmap = function(mapping, rhs, desc)
  vim.keymap.set('n', mapping, rhs, { desc = desc, noremap = true })
end

local nmap_leader = function(suffix, rhs, desc)
  nmap('<Leader>' .. suffix, rhs, desc)
end

nmap_leader('fe', function() vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } }) end, 'Grep')
