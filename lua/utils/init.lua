local M = {}

-- "lua-like" require instead of source
M.vrequire = function(path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path:gsub("%.", "/") .. '.vim')
end

-- opens a url in the correct OS
-- lifted from https://github.com/Almo7aya/openingh.nvim/blob/main/lua/openingh/utils.lua
M.open_url = function(url)
  -- when running in test env store the url
  if vim.g.test then
    vim.g.OPENINGH_RESULT = url
    return true
  end

  -- order here matters
  -- wsl must come before win
  -- wsl must come before linux

  if vim.fn.has("mac") == 1 then
    vim.fn.system("open " .. url)
    return true
  end

  if vim.fn.has("wsl") == 1 then
    vim.fn.system("explorer.exe " .. url)
    return true
  end

  if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    vim.fn.system("start " .. url)
    return true
  end

  if vim.fn.has("linux") == 1 then
    vim.fn.system("xdg-open " .. url)
    return true
  end

  return false
end

M.clear_reg = function()
  print('Clearing registers')
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

M.is_large_file = function(buf)
  local max_filesize = 1024 * 1024 -- 1MiB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
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

M.dump_dictionary = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. M.dump_dictionary(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

return M
