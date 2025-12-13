local utils = require('utils')
local state = require('utils.pack.state')

local M = {}

---@param src string
---@param hook_name string
---@return boolean
M.try_call_hook = function(src, hook_name)
  local spec = state.src_spec[src]
  if not spec then
    utils.schedule_notify("expected spec missing for " .. src, vim.log.levels.ERROR)
    return false
  end

  local hook = spec[hook_name] --[[@as fun()]]
  if not hook then
    utils.schedule_notify("expected " .. hook_name .. " missing for " .. src, vim.log.levels.ERROR)
    return false
  end

  if not type(hook) == "function" then
    utils.schedule_notify("Hook " .. hook_name .. " is not a function for " .. src, vim.log.levels.ERROR)
    return false
  end

  if state.debug then
    utils.schedule_notify("running hook for " .. src)
  end

  local success, error_msg = pcall(hook)
  if not success then
    utils.schedule_notify(("Failed to run hook for %s: %s"):format(src, error_msg), vim.log.levels.ERROR)
    return false
  end

  return true
end

---@param src string
---@param build string|fun()
M.execute_build = function(src, build)
  if not state.src_to_request_build[src] then
    return
  end

  if type(build) == "string" then
    vim.schedule(function()
      vim.cmd(build)
    end)
  elseif type(build) == "function" then
    vim.schedule(function()
      build()
    end)
  end
end

return M
