local M = {}

M.from_array = function(array)
  local set = {}
  for _, l in ipairs(array) do set[l] = true end
  return set
end

return M
