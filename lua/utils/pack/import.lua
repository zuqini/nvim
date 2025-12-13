local utils = require('utils')
local state = require('utils.pack.state')
local lazy = require('utils.pack.lazy')

local M = {}

---@param spec Spec
---@return boolean
local is_enabled = function(spec)
  if spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()) then
    return false
  end
  return true
end

---@param spec Spec
---@return boolean
local check_condition = function(spec)
  if spec.cond == false or (type(spec.cond) == "function" and not spec.cond()) then
    return false
  end
  return true
end

---@param spec Spec
---@return string
local get_source_url = function(spec)
  return spec.url and spec.url or 'https://github.com/' .. spec[1]
end

---@param spec Spec
---@param src string
local categorize_spec = function(spec, src)
  if lazy.is_lazy(spec) then
    table.insert(state.lazy_packs, { src = src, version = spec.version })
  else
    table.insert(state.startup_packs, { src = src, version = spec.version })

    if spec.config then
      table.insert(state.src_with_startup_config, src)
    end

    if spec.init then
      table.insert(state.src_with_startup_init, src)
    end

    if spec.keys then
      for _, key in ipairs(spec.keys) do
        table.insert(state.startup_keys, key)
      end
    end
  end
end

---@param spec_item_or_list Spec|Spec[]
M.import_specs = function(spec_item_or_list)
  local specs = (type(spec_item_or_list[1]) == "string" or spec_item_or_list.url)
      and { spec_item_or_list }
      or spec_item_or_list --[[@as Spec[] ]]

  if state.debug then
    utils.schedule_notify(utils.dump_table(specs))
  end

  for _, spec in ipairs(specs) do
    if not is_enabled(spec) then
      goto continue
    end

    if not check_condition(spec) then
      goto continue
    end

    local src = get_source_url(spec)
    state.src_spec[src] = spec
    categorize_spec(spec, src)

    ::continue::
  end
end

return M
