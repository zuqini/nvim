local M = {}

local debug = false

local packs = {}
local configs = {}
local keys = {}
local builds = {}

local map = function(mapping, rhs, noremap, desc, mode, nowait)
  noremap = noremap or true
  desc = desc or ""
  mode = mode or { 'n' }
  nowait = nowait or false
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = noremap, nowait = nowait })
end

local import
---@class Spec
---@field [1] string
---@field url? string
---@field build? string
---@field ft? string
---@field dependencies? string[]
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field version? string
---@field keys? table<integer, {[1]: string, [2]: fun(), noremap?: boolean, desc?: string, mode?: string|string[], nowait?: boolean}>
---@field config? fun()

---@param specs Spec|Spec[]
import = function(specs)
  if type(specs[1]) == "string" then
    specs = { specs }
  else
    specs = specs
  end

  if debug then
    print(require'utils'.dump_table(specs))
  end

  for _, spec in ipairs(specs) do
    if spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()) then
      return
    end

    if spec.dependencies then
      import(spec.dependencies)
    end

    local src
    if spec.url then
      src = spec.url
    else
      src = 'https://github.com/' .. spec[1]
    end

    table.insert(packs, { src = src, version = spec.version })

    if spec.ft and vim.bo.filetype == spec.ft then
      return
    end

    if spec.cond == false or (type(spec.cond) == "function" and not spec.cond()) then
      return
    end

    if spec.config then
      configs[src] = spec.config
    end

    if spec.build then
      table.insert(builds, spec.build)
    end

    if spec.keys then
      for _, key in ipairs(spec.keys) do
        table.insert(keys, key)
      end
    end
  end
end

local initialize = function()
  if debug then
    print("adding spec for " .. require'utils'.dump_table(packs));
  end
  vim.pack.add(packs)

  for src, config in pairs(configs) do
    if debug then
      print("running config for " .. src);
    end
    local success, error_msg = pcall(config)
    if not success then
      vim.schedule(function()
        vim.notify(("Failed to run config for %s: %s"):format(src, error_msg), vim.log.levels.ERROR)
      end)
    end
  end

  for _, build in ipairs(builds) do
    vim.schedule(function() 
      vim.cmd(build) 
    end)
  end

  for _, key in ipairs(keys) do
    map(key[1], key[2], key.noremap, key.desc, key.mode, key.nowait)
  end
end

---@param plugins_dir string
M.import_plugins = function(plugins_dir)
  local plugin_paths = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. plugins_dir .. '/*.lua', false, true)

  for _, plugin_path in ipairs(plugin_paths) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t:r")
    local success, spec = pcall(require, plugins_dir .. "." .. plugin_name)
    if not success then
      vim.schedule(function()
        vim.notify(("Failed to load plugin spec for %s"):format(plugin_name), vim.log.levels.ERROR)
      end)
    elseif type(spec) ~= "table" then
      vim.schedule(function()
        vim.notify(("Invalid spec for %s, not a table"):format(plugin_name), vim.log.levels.ERROR)
      end)
    else
      import(spec)
    end
  end

  initialize()
end

return M
