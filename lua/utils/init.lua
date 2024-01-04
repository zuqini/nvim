local M = {}

-- "lua-like" require instead of source
M.vrequire = function (path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path:gsub("%.", "/") .. '.vim')
end

-- opens a url in the correct OS
-- lifted from https://github.com/Almo7aya/openingh.nvim/blob/main/lua/openingh/utils.lua
M.open_url = function (url)
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

return M
