---@module 'utils.pack'

local utils = require('utils')
local import = require('utils.pack.import')
local lazy = require('utils.pack.lazy')
local startup = require('utils.pack.startup')

local M = {}

---@param plugins_dir string
M.import_specs_from_dir = function(plugins_dir)
  local plugin_paths = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. plugins_dir .. '/*.lua', false, true)

  for _, plugin_path in ipairs(plugin_paths) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t:r")
    local success, spec_item_or_list = pcall(require, plugins_dir .. "." .. plugin_name)

    if not success then
      utils.schedule_notify(
        ("Failed to load plugin spec for %s: %s"):format(plugin_name, spec_item_or_list),
        vim.log.levels.ERROR
      )
    elseif type(spec_item_or_list) ~= "table" then
      utils.schedule_notify(
        ("Invalid spec for %s, not a table: %s"):format(plugin_name, spec_item_or_list),
        vim.log.levels.ERROR
      )
    else
      import.import_specs(spec_item_or_list)
    end
  end

  lazy.process_all()
  startup.process_all()
end

return M
