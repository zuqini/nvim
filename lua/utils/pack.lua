---@class Spec
---@field [1] string
---@field url? string
---@field init? fun()
---@field build? string|fun()
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field version? string
---@field keys? table<integer, {[1]: string, [2]: fun(), noremap?: boolean, desc?: string, mode?: string|string[], nowait?: boolean}>
---@field config? fun()

local utils = require('utils')
local M = {}

local debug = false

local packs = {}
local keys = {}
---@type { [string]: Spec }
local src_spec = {}
---@type string[]
local src_to_request_build = {}
---@type string[]
local src_to_request_init = {}
---@type string[]
local src_to_request_config = {}

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
      return
    end

    local src = spec.url and spec.url or 'https://github.com/' .. spec[1]
    table.insert(packs, { src = src, version = spec.version })

    if spec.cond == false or (type(spec.cond) == "function" and not spec.cond()) then
      return
    end

    if src then
      src_spec[src] = spec
      if spec.config then
        table.insert(src_to_request_config, src)
      end
      if spec.init then
        table.insert(src_to_request_init, src)
      end
    end

    if spec.keys then
      for _, key in ipairs(spec.keys) do
        table.insert(keys, key)
      end
    end
  end
end

local process_specs = function()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.kind == "update" or event.data.kind == "install" then
        table.insert(src_to_request_build, event.data.spec.src)
      end
    end,
  })

  for _, src in ipairs(src_to_request_init) do
    try_call_hook(src, 'init')
  end

  if debug then
    utils.schedule_notify("adding spec for " .. utils.dump_table(packs));
  end
  vim.pack.add(packs)

  for _, src in ipairs(src_to_request_config) do
    try_call_hook(src, 'config')
  end

  vim.schedule(function()
    for _, src in ipairs(src_to_request_build) do
      local build = src_spec[src].build
      if build then
        if type(build) == "string" then
          vim.cmd(build)
        elseif type(build) == "function" then
          build()
        end
      end
    end
  end)

  for _, key in ipairs(keys) do
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

  process_specs()
end

return M
