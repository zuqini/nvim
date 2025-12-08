---@class Spec
---@field [1] string
---@field url? string
---@field build? string|fun()
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field version? string
---@field keys? table<integer, {[1]: string, [2]: fun(), noremap?: boolean, desc?: string, mode?: string|string[], nowait?: boolean}>
---@field config? fun()

---@class InitializeParams
---@field build? string|fun()
---@field config? fun()

local utils = require('utils')
local M = {}

local debug = false

local packs = {}
local keys = {}
---@type { [string]: InitializeParams }
local src_initialize_params = {}
---@type string[]
local src_to_request_build = {}

local map = function(mapping, rhs, noremap, desc, mode, nowait)
  noremap = noremap or true
  desc = desc or ""
  mode = mode or { 'n' }
  nowait = nowait or false
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = noremap, nowait = nowait })
end


local import
---@param spec_item_or_list Spec|Spec[]
import = function(spec_item_or_list)
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
      src_initialize_params[src] = {}
      src_initialize_params[src].config = spec.config
      src_initialize_params[src].build = spec.build
    end


    if spec.keys then
      for _, key in ipairs(spec.keys) do
        table.insert(keys, key)
      end
    end
  end
end

local initialize = function()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.kind == "update" or event.data.kind == "install" then
        table.insert(src_to_request_build, event.data.spec.src)
      end
    end,
  })

  if debug then
    utils.schedule_notify("adding spec for " .. utils.dump_table(packs));
  end
  vim.pack.add(packs)

  for src, params in pairs(src_initialize_params) do
    if params.config then
      if debug then
        utils.schedule_notify("running config for " .. src);
      end
      local success, error_msg = pcall(params.config)
      if not success then
        utils.schedule_notify(("Failed to run config for %s: %s"):format(src, error_msg), vim.log.levels.ERROR);
      end
    end
  end

  vim.schedule(function()
    for _, src in ipairs(src_to_request_build) do
      local build = src_initialize_params[src].build
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
M.import_plugins = function(plugins_dir)
  local plugin_paths = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. plugins_dir .. '/*.lua', false, true)

  for _, plugin_path in ipairs(plugin_paths) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t:r")
    local success, spec = pcall(require, plugins_dir .. "." .. plugin_name)
    if not success then
      vim.schedule(function()
        vim.notify(("Failed to load plugin spec for %s: %s"):format(plugin_name, spec), vim.log.levels.ERROR)
      end)
    elseif type(spec) ~= "table" then
      vim.schedule(function()
        vim.notify(("Invalid spec for %s, not a table: %s"):format(plugin_name, spec), vim.log.levels.ERROR)
      end)
    else
      import(spec)
    end
  end

  initialize()
end

return M
