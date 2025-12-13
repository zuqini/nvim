---@class Spec
---@field [1] string
---@field url? string
---@field init? fun()
---@field build? string|fun()
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field lazy? boolean
---@field version? string
---@field keys? table<integer, {[1]: string, [2]: fun(), noremap?: boolean, desc?: string, mode?: string|string[], nowait?: boolean}>
---@field config? fun()
---@field event? string|string[]
---@field pattern? string|string[]
---@field cmd? string|string[]
---@field nargs? string
---@field range? boolean
---@field bang? boolean
---@field complete? string
---@field count? boolean

local utils = require('utils')
local M = {}

local debug = false

local lazy_group = vim.api.nvim_create_augroup('LazyPack', { clear = true })
local startup_group = vim.api.nvim_create_augroup('StartupPack', { clear = true })

local startup_packs = {}
local lazy_packs = {}
local startup_keys = {}
---@type { [string]: Spec }
local src_spec = {}
---@type { [string]: boolean }
local src_to_request_build = {}
---@type string[]
local src_with_startup_init = {}
---@type string[]
local src_with_startup_config = {}

local map = function(mapping, rhs, noremap, desc, mode, nowait)
  noremap = noremap or true
  desc = desc or ""
  mode = mode or { 'n' }
  nowait = nowait or false
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = noremap, nowait = nowait })
end

local try_call_hook = function(src, hook_name)
  local spec = src_spec[src]
  if not spec then
    utils.schedule_notify("expected spec missing for " .. src, vim.log.levels.ERROR);
    return
  end
  local hook = spec[hook_name] --[[@as fun()]]
  if not hook then
    utils.schedule_notify("expected " .. hook_name .. " missing for " .. src, vim.log.levels.ERROR);
    return
  end

  if not type(hook) == "function" then
    utils.schedule_notify("Hook " .. hook_name .. " is not a function for " .. src, vim.log.levels.ERROR);
    return
  end

  if debug then
    utils.schedule_notify("running hook for " .. src);
  end
  local success, error_msg = pcall(hook)
  if not success then
    utils.schedule_notify(("Failed to run hook for %s: %s"):format(src, error_msg), vim.log.levels.ERROR);
  end
end

---@param spec Spec
local is_lazy = function(spec)
  if spec.lazy ~= nil then
    return spec.lazy
  end
  return spec.event or spec.cmd or (spec.keys and #spec.keys > 0)
end

local lazy_process_spec = function(plugin)
  local spec = src_spec[plugin.spec.src]

  if spec.init then
    try_call_hook(plugin.spec.src, 'init')
  end

  vim.cmd.packadd(plugin.spec.name)

  if spec.config then
    try_call_hook(plugin.spec.src, 'config')
  end

  if src_to_request_build[plugin.spec.src] and spec.build then
    if type(spec.build) == "string" then
      vim.schedule(function()
        vim.cmd(spec.build)
      end)
    elseif type(spec.build) == "function" then
      vim.schedule(function()
        spec.build()
      end)
    end
  end

  if spec.keys then
    for _, key in ipairs(spec.keys) do
      map(key[1], key[2], key.noremap, key.desc, key.mode, key.nowait)
    end
  end
end

local process_lazy_specs = function()
  vim.pack.add(lazy_packs, {
    load = function(plugin)
      local spec = src_spec[plugin.spec.src]
      if spec.event then
        local events = type(spec.event) == "string" and { spec.event } or spec.event --[[@as string[] ]]

        -- Handle VeryLazy event specially
        local has_very_lazy = false
        local other_events = {}
        for _, event in ipairs(events) do
          if event == "VeryLazy" then
            has_very_lazy = true
          else
            table.insert(other_events, event)
          end
        end

        if has_very_lazy then
          vim.api.nvim_create_autocmd("UIEnter", {
            group = lazy_group,
            once = true,
            callback = function()
              vim.schedule(function()
                lazy_process_spec(plugin)
              end)
            end,
          })
        end

        if #other_events > 0 then
          vim.api.nvim_create_autocmd(other_events, {
            group = lazy_group,
            once = true,
            pattern = spec.pattern or '*',
            callback = function()
              lazy_process_spec(plugin)
            end,
          })
        end
      end

      if spec.cmd then
        local commands = type(spec.cmd) == "string" and { spec.cmd } or spec.cmd --[[@as string[] ]]
        for _, cmd in ipairs(commands) do
          vim.api.nvim_create_user_command(cmd, function(cmd_args)
            pcall(vim.api.nvim_del_user_command, cmd)

            lazy_process_spec(plugin)
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

      if spec.keys then
        for _, key in ipairs(spec.keys) do
          local lhs = key[1]
          local mode = key.mode or 'n'
          local modes = type(mode) == "string" and { mode } or mode --[[@as string[] ]]

          for _, m in ipairs(modes) do
            vim.keymap.set(m, lhs, function()
              vim.keymap.del(m, lhs)
              lazy_process_spec(plugin)
              -- Re-feed the key
              vim.api.nvim_feedkeys(vim.keycode(lhs), 'm', false)
            end, { desc = key.desc })
          end
        end
      end
    end
  })
end

local import_specs
---@param spec_item_or_list Spec|Spec[]
import_specs = function(spec_item_or_list)
  local specs = (type(spec_item_or_list[1]) == "string" or spec_item_or_list.url)
      and { spec_item_or_list }
      or spec_item_or_list --[[@as Spec[] ]]

  if debug then
    utils.schedule_notify(utils.dump_table(specs))
  end

  for _, spec in ipairs(specs) do
    if spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()) then
      goto continue
    end

    if spec.cond == false or (type(spec.cond) == "function" and not spec.cond()) then
      goto continue
    end

    local src = spec.url and spec.url or 'https://github.com/' .. spec[1]

    src_spec[src] = spec

    if is_lazy(spec) then
      table.insert(lazy_packs, { src = src, version = spec.version })
    else
      table.insert(startup_packs, { src = src, version = spec.version })

      if spec.config then
        table.insert(src_with_startup_config, src)
      end
      if spec.init then
        table.insert(src_with_startup_init, src)
      end

      if spec.keys then
        for _, key in ipairs(spec.keys) do
          table.insert(startup_keys, key)
        end
      end
    end

    ::continue::
  end
end

local process_specs = function()
  vim.api.nvim_create_autocmd('PackChanged', {
    group = startup_group,
    callback = function(event)
      if event.data.kind == "update" or event.data.kind == "install" then
        src_to_request_build[event.data.spec.src] = true
      end
    end,
  })

  for _, src in ipairs(src_with_startup_init) do
    try_call_hook(src, 'init')
  end

  if debug then
    utils.schedule_notify("adding spec for " .. utils.dump_table(startup_packs));
  end
  vim.pack.add(startup_packs)

  for _, src in ipairs(src_with_startup_config) do
    try_call_hook(src, 'config')
  end

  vim.schedule(function()
    for src, _ in pairs(src_to_request_build) do
      local build = src_spec[src].build
      if not is_lazy(src_spec[src]) and build then
        if type(build) == "string" then
          vim.cmd(build)
        elseif type(build) == "function" then
          build()
        end
      end
    end
  end)

  for _, key in ipairs(startup_keys) do
    map(key[1], key[2], key.noremap, key.desc, key.mode, key.nowait)
  end
end

---@param plugins_dir string
M.import_specs_from_dir = function(plugins_dir)
  local plugin_paths = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. plugins_dir .. '/*.lua', false, true)

  for _, plugin_path in ipairs(plugin_paths) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t:r")
    local success, spec_item_or_list = pcall(require, plugins_dir .. "." .. plugin_name)
    if not success then
      utils.schedule_notify(("Failed to load plugin spec for %s: %s"):format(plugin_name, spec_item_or_list),
        vim.log.levels.ERROR)
    elseif type(spec_item_or_list) ~= "table" then
      utils.schedule_notify(("Invalid spec for %s, not a table: %s"):format(plugin_name, spec_item_or_list),
        vim.log.levels.ERROR)
    else
      import_specs(spec_item_or_list)
    end
  end

  process_lazy_specs()
  process_specs()
end

return M
