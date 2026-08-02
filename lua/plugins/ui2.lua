-- Neovim's builtin message + cmdline UI (`:h ui2`). Replaces the parts of
-- noice.nvim this config actually used: a bottom cmdline that shares the
-- statusline row, no hit-enter prompts, and a pager for message history (`g<`).
-- Not a plugin, so this file registers no specs -- see vim.g.ui_engine.
if vim.g.ui_engine ~= 'ui2' or vim.g.vscode then
  return {}
end

-- Experimental API, already renamed once (vim._extui -> vim._core.ui2).
local ok, ui2 = pcall(require, 'vim._core.ui2')
if not ok then
  vim.notify('vim._core.ui2 not available; falling back to the legacy UI', vim.log.levels.WARN)
  return {}
end

-- The cmdline window is anchored `relative = 'laststatus'` and stays hidden
-- until the cmdline is active, so cmdheight=0 is what makes it share a row
-- with lualine.
vim.o.cmdheight = 0

ui2.enable({
  msg = {
    -- Output of a typed `:cmd` expands the cmdline window over the statusline.
    -- Everything else (async echoes, LSP notices) has to go to the msg window,
    -- since at cmdheight=0 the cmdline window is hidden and would swallow it.
    targets = { default = 'msg', typed_cmd = 'cmd' },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ui2-config', {}),
  pattern = { 'cmd', 'msg', 'pager', 'dialog' },
  desc = 'Keep the ui2 windows opaque, the global winblend is 10',
  callback = function()
    -- ui2 fires this inside the window it just built, and bufwinid() would only
    -- find it while that window is in the current tabpage.
    vim.wo[vim.api.nvim_get_current_win()].winblend = 0
  end,
})

return {}
