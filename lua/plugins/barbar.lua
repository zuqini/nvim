require('bufferline').setup({
  animation = false,
  icon_pinned = '車',
  closable = false,
  -- icon_separator_active = '',
  -- icon_separator_inactive = '',
  maximum_padding = 1,

  -- colemak-dh
  -- semantic_letters = false,
  -- letters = 'arstneoigmqwfpluy;bjzxcdhvkARSTNEIOGMQWFPLUYBJZXCDHVK',
})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<left>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<right>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<leader><left>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<leader><right>', '<Cmd>BufferMoveNext<CR>', opts)
-- Pin/unpin buffer
map('n', ',p', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', ',q', '<Cmd>BufferClose<CR>', opts)
map('n', ',Q', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', ',t', '<Cmd>BufferPick<CR>', opts)
map('n', ',b', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
-- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
-- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
-- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
-- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)
