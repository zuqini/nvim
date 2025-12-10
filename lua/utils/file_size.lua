local M = {}

local max_file_size = 1024 * 1024 -- 1MiB
local file_size_cache = {}
local ignored_buf_substrs = { "oil://", "undotree", "Grug FAR", "health://", "any-jump" }

local function buf_should_be_ignored(buf_name)
  for _, ignored_buf_substr in ipairs(ignored_buf_substrs) do
    if string.find(buf_name, ignored_buf_substr) then
      return true
    end
  end
end

M.is_large_file = function(buf)
  local buf_name = vim.api.nvim_buf_get_name(buf)
  if buf_name == nil or buf_name == '' then
    return false
  end

  if file_size_cache[buf_name] == nil then
    if buf_should_be_ignored(buf_name) then
      file_size_cache[buf_name] = 0
    else
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats then
        file_size_cache[buf_name] = stats.size
      else
        vim.notify("Failed to fetch file size for " .. buf_name, vim.log.levels.WARN, { title = "utils.is_large_file" })
      end
    end
  end

  if file_size_cache[buf_name] ~= nil and file_size_cache[buf_name] > max_file_size then
    return true
  end
end

return M
