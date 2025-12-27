local M = {}

-- "lua-like" require instead of source
M.vrequire = function(path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path:gsub("%.", "/") .. '.vim')
end

M.open_url = function(url)
  vim.ui.open(url)
end

M.clear_reg = function()
  vim.notify('Clearing registers', vim.log.levels.INFO, { title = "utils.clear_reg" })
  vim.cmd [[
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
    call setreg(r, [])
    endfor
]]
end

M.set_transparent_background = function()
  if vim.g.transparent_background then
    vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
    vim.cmd('hi NormalNC guibg=NONE ctermbg=NONE')
    vim.cmd('hi Terminal guibg=NONE ctermbg=NONE')
    vim.cmd('hi SignColumn guibg=NONE ctermbg=NONE')

    vim.cmd('hi TelescopeBorder guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopePromptNormal guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopePreviewNormal guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopeResultsNormal guibg=NONE ctermbg=NONE')

    if vim.g.transparent_float_if_transparent then
      vim.cmd('hi! link NormalFloat Normal')
      vim.cmd('hi! link FloatBorder Normal')
    end

    if vim.g.colors_name ~= "gruvbox-material" then
      vim.cmd('hi DiagnosticVirtualTextError guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextWarn guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextInfo guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextHint guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextOk guibg=NONE ctermbg=NONE')
    end
  end
end

--- Trim trailing whitespace
M.trim_space = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)
  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

--- Trim last blank lines
M.trim_last_lines = function()
  local n_lines = vim.api.nvim_buf_line_count(0)
  local last_nonblank = vim.fn.prevnonblank(n_lines)
  if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
end

M.schedule_notify = function(msg, level)
  vim.schedule(function()
    vim.notify(msg, level)
  end)
end

return M
