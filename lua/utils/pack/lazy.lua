local state = require('utils.pack.state')
local hooks = require('utils.pack.hooks')
local keymap = require('utils.pack.keymap')

local M = {}

---@param spec Spec
---@return boolean
M.is_lazy = function(spec)
  if spec.lazy ~= nil then
    return spec.lazy
  end
  return (spec.event ~= nil) or (spec.cmd ~= nil) or (spec.keys ~= nil and #spec.keys > 0)
end

---@param plugin vim.pack.Spec
M.process_spec = function(plugin)
  local spec = state.src_spec[plugin.spec.src]

  if spec.init then
    hooks.try_call_hook(plugin.spec.src, 'init')
  end

  vim.cmd.packadd(plugin.spec.name)

  if spec.config then
    hooks.try_call_hook(plugin.spec.src, 'config')
  end

  if spec.build then
    hooks.execute_build(plugin.spec.src, spec.build)
  end

  if spec.keys then
    keymap.apply_keys(spec.keys)
  end
end

---@param events string[]
---@return boolean, string[]
local split_very_lazy = function(events)
  local has_very_lazy = false
  local other_events = {}

  for _, event in ipairs(events) do
    if event == "VeryLazy" then
      has_very_lazy = true
    else
      table.insert(other_events, event)
    end
  end

  return has_very_lazy, other_events
end

---@param plugin vim.pack.Spec
---@param spec Spec
local setup_event_loading = function(plugin, spec)
  local events = type(spec.event) == "string" and { spec.event } or spec.event --[[@as string[] ]]

  local has_very_lazy, other_events = split_very_lazy(events)

  if has_very_lazy then
    vim.api.nvim_create_autocmd("UIEnter", {
      group = state.lazy_group,
      once = true,
      callback = function()
        vim.schedule(function()
          M.process_spec(plugin)
        end)
      end,
    })
  end

  if #other_events > 0 then
    vim.api.nvim_create_autocmd(other_events, {
      group = state.lazy_group,
      once = true,
      pattern = spec.pattern or '*',
      callback = function()
        M.process_spec(plugin)
      end,
    })
  end
end

---@param plugin vim.pack.Spec
---@param spec Spec
local setup_cmd_loading = function(plugin, spec)
  local commands = type(spec.cmd) == "string" and { spec.cmd } or spec.cmd --[[@as string[] ]]

  for _, cmd in ipairs(commands) do
    vim.api.nvim_create_user_command(cmd, function(cmd_args)
      pcall(vim.api.nvim_del_user_command, cmd)

      M.process_spec(plugin)

      -- Re-execute the command
      vim.api.nvim_cmd({
        cmd = cmd,
        args = cmd_args.fargs,
        bang = cmd_args.bang,
        nargs = cmd_args.nargs,
        range = cmd_args.range ~= 0 and { cmd_args.line1, cmd_args.line2 } or nil,
        count = cmd_args.count ~= -1 and cmd_args.count or nil,
      }, {})
    end, {
      nargs = spec.nargs or '*',
      range = spec.range,
      bang = spec.bang,
      complete = spec.complete,
      count = spec.count,
    })
  end
end

---@param plugin vim.pack.Spec
---@param spec Spec
local setup_key_loading = function(plugin, spec)
  local keys = (spec.keys[1] and type(spec.keys[1]) == "string") and { spec.keys } or spec.keys --[[@as KeySpec[] ]]

  for _, key in ipairs(keys) do
    local lhs = key[1]
    local mode = key.mode or 'n'
    local modes = type(mode) == "string" and { mode } or mode --[[@as string[] ]]

    for _, m in ipairs(modes) do
      vim.keymap.set(m, lhs, function()
        vim.keymap.del(m, lhs)
        M.process_spec(plugin)
        -- Re-feed the key
        vim.api.nvim_feedkeys(vim.keycode(lhs), 'm', false)
      end, { desc = key.desc })
    end
  end
end

M.process_all = function()
  vim.pack.add(state.lazy_packs, {
    load = function(plugin)
      local spec = state.src_spec[plugin.spec.src]

      if spec.event then
        setup_event_loading(plugin, spec)
      end

      if spec.cmd then
        setup_cmd_loading(plugin, spec)
      end

      if spec.keys then
        setup_key_loading(plugin, spec)
      end
    end
  })
end

return M
