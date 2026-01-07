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

nmap_leader('w', ':w<CR>', 'Save')
nmap_leader('W', ':w<CR>:MT<CR>', 'Save & CTags')
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

nmap_leader('O', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", 'New Line Above')
nmap_leader('o', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", "New Line")

nmap("<M-u>", ":m .-2<CR>", 'Move line up')
nmap("<M-d>", ":m .+1<CR>", 'Move line down')

nmap_leader('c', ':call ToggleQuickFix()<CR>', 'Toggle QuickFix')
nmap('<C-p>', ':cp<CR>', 'QuickFix Prev')
nmap('<C-n>', ':cn<CR>', 'QuickFix Next')

nmap_leader('x', ':call ToggleLocList()<CR>', 'Toggle LocList')
nmap('<leader>lp', ':lp<CR>', 'LocList Prev')
nmap('<leader>ln', ':lne<CR>', 'LocList Next')

nmap('<C-l>', ':lua clear_floats_and_highlights()<CR><c-l>', 'Clear Floats & Highlights')
nmap('<F5>', ':mod<CR>', 'Clear * Redraw')

xmap('>', '>gv', 'Indent w/ Selection')
xmap('<', '<gv', 'Unindent w/ Selection')

nmap('<S-Left>', '<C-W><', '- Win Width')
nmap('<S-Right>', '<C-W>>', '+ Win Width')
nmap('<S-Down>', '<C-W>-', '- Win Height')
nmap('<S-Up>', '<C-W>+', '+ Win Height')

nmap('gz', ':call HandleURI()<CR>', 'Navigate URI')

-- diagnostics
vim.g.diagnostics_visible = true
local function toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable(true)
  end
end
local function toggle_virtual_lines()
  local new_config = vim.diagnostic.config().virtual_lines == false and
      { current_line = vim.g.virtual_line_current_line } or
      false
  vim.diagnostic.config({ virtual_lines = new_config })
end
local function toggle_virtual_lines_current_line()
  vim.g.virtual_line_current_line = not vim.g.virtual_line_current_line
  if vim.diagnostic.config().virtual_lines ~= false then
    vim.diagnostic.config({ virtual_lines = { current_line = vim.g.virtual_line_current_line } })
  end
end

local virtual_text_config = vim.diagnostic.config().virtual_text
local function toggle_virtual_text()
  vim.diagnostic.config({ virtual_text = vim.diagnostic.config().virtual_text == false and virtual_text_config or false })
end

nmap_leader('e', vim.diagnostic.open_float, 'Dignostic Float')
nmap_leader('gD', toggle_diagnostics, 'Toggle Dignostics')
nmap_leader('gK', toggle_virtual_lines, 'Toggle diagnostic virtual_lines')
nmap_leader('gL', toggle_virtual_lines_current_line, 'Toggle diagnostic virtual_lines current_line')
nmap_leader('gT', toggle_virtual_text, 'Toggle diagnostic virtual_text')
