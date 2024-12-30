vim.g.mapleader = ' '

local nmap = function(mapping, rhs, desc)
  vim.keymap.set('n', mapping, rhs, { desc = desc, noremap = true })
end
local xmap = function(mapping, rhs, desc)
  vim.keymap.set('x', mapping, rhs, { desc = desc, noremap = true })
end

local nmap_leader = function(suffix, rhs, desc)
  nmap('<Leader>' .. suffix, rhs, desc)
end
local xmap_leader = function(suffix, rhs, desc)
  xmap('<Leader>' .. suffix, rhs, desc)
end

nmap_leader('w', ':up<CR>', 'Save')
nmap_leader('W', ':up<CR>:MT<CR>', 'Save & CTags')
nmap_leader('C', ":put=execute(':')<left><left>", 'Put :Cmd')

nmap_leader('gQ', ':%!jq<CR>', 'JQ')
nmap_leader('gQ', ':%!jq<CR>', 'JQ')

xmap('p', 'P', 'Paste No Reg. Overwrite')
xmap('P', 'p', 'Paste Reg. Overwrite')

nmap_leader('y', '"+y', 'Clipboard Yank')
nmap_leader('Y', '"+Y', 'Clipboard Yank $')
xmap_leader('y', '"+y', 'Clipboard Yank')
xmap_leader('Y', '"+Y', 'Clipboard Yank $')
nmap_leader('d', '"+d', 'Clipboard Cut')
nmap_leader('D', '"+D', 'Clipboard Cut $')
xmap_leader('d', '"+d', 'Clipboard Cut')
xmap_leader('D', '"+D', 'Clipboard Cut $')
nmap_leader('v', '"+p', 'Clipboard Paste')
nmap_leader('V', '"+P', 'Clipboard Paste Before')
xmap_leader('v', '"+p', 'Clipboard Paste')
xmap_leader('V', '"+P', 'Clipboard Paste Before')
nmap_leader('p', '"0p', 'Yank Paste')
nmap_leader('P', '"0P', 'Yank Paste Before')
xmap_leader('p', '"0p', 'Yank Paste')
xmap_leader('P', '"0P', 'Yank Paste Before')

nmap_leader('u', ':UndotreeToggle<CR>', 'Undotree')

nmap_leader('c', ':call ToggleQuickFix()<CR>', 'Toggle QuickFix')
nmap_leader('k', ':cp<CR>', 'QuickFix Prev')
nmap_leader('j', ':cn<CR>', 'QuickFix Next')
nmap_leader('<up>', ':cp<CR>', 'QuickFix Prev')
nmap_leader('<down>', ':cn<CR>', 'QuickFix Next')

nmap_leader('x', ':call ToggleLocList()<CR>', 'Toggle LocList')
nmap('<C-k>', ':lp<CR>', 'LocList Prev')
nmap('<C-j>', ':lne<CR>', 'LocList Next')
nmap('<C-up>', ':lp<CR>', 'LocList Prev')
nmap('<C-down>', ':lne<CR>', 'LocList Next')
nmap('<CR>',  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", "New Line Prev")
nmap('<BS>', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", "New Line")

nmap('<C-l>', ':lua clear_floats_and_highlights()<CR><c-l>', 'Clear Floats & Highlights')
nmap('<F5>', ':mod<CR>', 'Clear * Redraw')

xmap('>', '>gv', 'Indent w/ Selection')
xmap('<', '<gv', 'Unindent w/ Selection')

nmap('<S-Left>', '<C-W><', '- Win Width')
nmap('<S-Right>', '<C-W>>', '+ Win Width')
nmap('<S-Down>', '<C-W>-', '- Win Height')
nmap('<S-Up>', '<C-W>+', '+ Win Height')

nmap('gz', ':call HandleURI()<CR>', 'Navigate URI')
