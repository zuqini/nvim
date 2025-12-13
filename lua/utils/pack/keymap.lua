local M = {}

---@param mapping string
---@param rhs string|fun()
---@param noremap? boolean
---@param desc? string
---@param mode? string|string[]
---@param nowait? boolean
M.map = function(mapping, rhs, noremap, desc, mode, nowait)
  noremap = noremap or true
  desc = desc or ""
  mode = mode or { 'n' }
  nowait = nowait or false
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = noremap, nowait = nowait })
end

---@param keys KeySpec|KeySpec[]
M.apply_keys = function(keys)
  local key_list = (keys[1] and type(keys[1]) == "string") and { keys } or keys --[[@as KeySpec[] ]]

  for _, key in ipairs(key_list) do
    if key[2] ~= nil then
      M.map(key[1], key[2], key.noremap, key.desc, key.mode, key.nowait)
    end
  end
end

return M
