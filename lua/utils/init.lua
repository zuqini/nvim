local M = {}

-- "lua-like" require instead of source
M.vrequire = function (path)
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vim/' .. path:gsub("%.", "/") .. '.vim')
end

return M
