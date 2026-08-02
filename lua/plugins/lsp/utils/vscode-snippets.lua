-- VSCode-format snippet packages on the runtimepath -- rafamadriz/friendly-snippets
-- and anything shaped like it. A package.json says which languages each file
-- covers, and the bodies are already LSP snippet syntax, so they need no
-- translation to go straight into the completion menu.
--
-- Discovery matches what luasnip's from_vscode loader does, so the same plugins
-- are picked up under either completion engine.

---@class VscodeSnippet
---@field prefix string
---@field body string

---@param path string
---@return table?
local function read_json(path)
  local ok, text = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local decoded, result = pcall(vim.json.decode, table.concat(text, '\n'), { luanil = { object = true } })
  return decoded and result or nil
end

-- vim.snippet.expand() raises on a body it cannot parse, and vim.lsp.completion
-- deletes the typed word *before* expanding, so an unparseable snippet takes the
-- word with it and leaves an error behind. ~4% of friendly-snippets' bodies do
-- not parse, so they are dropped here rather than at accept time.
local has_grammar, grammar = pcall(require, 'vim.lsp._snippet_grammar')

---@param body string
---@return boolean
local function expandable(body)
  return not has_grammar or (pcall(grammar.parse, body))
end

-- VSCode variables nvim does not resolve. It knows the TM_* set and turns
-- everything else into a placeholder, which is why `copyright` used to insert a
-- literal CURRENT_YEAR. Whitelisted on purpose: plenty of bodies contain things
-- like LaTeX's $C$ or a bare $NAME that are text, not variables, and those have
-- to keep falling through to nvim untouched.
local DATE_FORMAT = {
  CURRENT_YEAR = '%Y',
  CURRENT_YEAR_SHORT = '%y',
  CURRENT_MONTH = '%m',
  CURRENT_MONTH_NAME = '%B',
  CURRENT_MONTH_NAME_SHORT = '%b',
  CURRENT_DATE = '%d',
  CURRENT_DAY_NAME = '%A',
  CURRENT_DAY_NAME_SHORT = '%a',
  CURRENT_HOUR = '%H',
  CURRENT_MINUTE = '%M',
  CURRENT_SECOND = '%S',
  CURRENT_TIMEZONE_OFFSET = '%z',
}

---@param name string
---@return string?
local function variable(name)
  local format = DATE_FORMAT[name]
  if format then
    return tostring(os.date(format))
  elseif name == 'CURRENT_SECONDS_UNIX' then
    return tostring(os.time())
  elseif name == 'RANDOM' then
    return ('%06d'):format(math.random(0, 999999))
  elseif name == 'RANDOM_HEX' then
    return ('%06x'):format(math.random(0, 0xffffff))
  elseif name == 'UUID' then
    return (('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'):gsub('[xy]', function(char)
      return ('%x'):format(char == 'x' and math.random(0, 15) or math.random(8, 11))
    end))
  elseif name == 'CLIPBOARD' then
    return table.concat(vim.fn.getreg('+', 1, true), '\n')
  end
  return nil
end

---Returning nil leaves the whole match alone, which is what both an escaped
---`\${VAR}` and a name we do not know should do.
---@param escape string
---@param name string
---@return string?
local function substitute(escape, name)
  if escape == '\\' then
    return nil
  end
  local value = variable(name)
  -- The result is re-parsed as snippet text, so a '$' or '}' out of a clipboard
  -- has to stop being syntax.
  return value and (value:gsub('[\\%$}]', '\\%0'))
end

---Resolved per request rather than at parse time: the cache lives for the whole
---session, and a stale CURRENT_MINUTE is worse than no cache.
---@param body string
---@return string
local function resolve(body)
  if not body:find('$', 1, true) then
    return body
  end
  body = body:gsub('(\\?)%${([A-Z_][A-Z_0-9]*)}', substitute)
  return (body:gsub('(\\?)%$([A-Z_][A-Z_0-9]*)', substitute))
end

---`${0:text}` is a placeholder sitting on the final tabstop, and nvim treats $0
---strictly as the exit point -- jumping to it ends the session rather than
---selecting the text, so the default lands in the buffer with no way to tab onto
---it, and a body whose only tabstop is $0 gets no session at all. Renumbering it
---past the last real tabstop makes it editable; nvim re-adds the implicit $0 at
---the end of the snippet.
---@param body string
---@return string
local function editable_final_tabstop(body)
  if not body:find('${0:', 1, true) then
    return body
  end

  local last = 0
  for index in body:gmatch '%$(%d+)' do
    last = math.max(last, tonumber(index) or 0)
  end
  for index in body:gmatch '%${(%d+)[:|}]' do
    last = math.max(last, tonumber(index) or 0)
  end

  return (body:gsub('%${0:', ('${%d:'):format(last + 1)))
end

---@param value string|string[]|nil
---@return string?
local function joined(value)
  if type(value) == 'table' then
    return table.concat(value, '\n')
  end
  return value
end

---@param path string
---@return VscodeSnippet[]
local function parse(path)
  local snippets = {}
  for name, def in pairs(read_json(path) or {}) do
    local body = joined(def.body)
    -- A prefix list means several triggers expand the same body.
    body = body and editable_final_tabstop(body)
    local prefixes = type(def.prefix) == 'table' and def.prefix or { def.prefix or name }
    if body and expandable(body) then
      for _, prefix in ipairs(prefixes) do
        if type(prefix) == 'string' then
          snippets[#snippets + 1] = { prefix = prefix, body = body }
        end
      end
    end
  end
  return snippets
end

---@return table<string, string[]> language to the files contributing to it
local function scan_manifests()
  local by_language = {}
  for _, manifest in ipairs(vim.api.nvim_get_runtime_file('package.json', true)) do
    local root = vim.fs.dirname(manifest)
    for _, entry in ipairs(vim.tbl_get(read_json(manifest) or {}, 'contributes', 'snippets') or {}) do
      local languages = type(entry.language) == 'table' and entry.language or { entry.language }
      -- Every plugin's package.json is read, not just snippet packs, so an
      -- entry that declares a language but no file has to be skipped.
      if type(entry.path) == 'string' then
        for _, language in ipairs(languages) do
          by_language[language] = by_language[language] or {}
          local files = by_language[language]
          files[#files + 1] = vim.fs.normalize(root .. '/' .. entry.path)
        end
      end
    end
  end
  return by_language
end

---@type table<string, string[]>?
local manifests = nil
---@type table<string, VscodeSnippet[]>
local cache = {}

local M = { resolve = resolve }

---Parsed on first use per filetype: scanning every package.json on the
---runtimepath and decoding the files is too slow to do at startup.
---@param filetype string
---@return VscodeSnippet[]
M.get = function(filetype)
  if cache[filetype] then
    return cache[filetype]
  end

  manifests = manifests or scan_manifests()
  local snippets, seen = {}, {}
  -- 'all' is the catch-all bucket every language inherits.
  for _, language in ipairs({ filetype, 'all' }) do
    for _, path in ipairs(manifests[language] or {}) do
      if not seen[path] then
        seen[path] = true
        vim.list_extend(snippets, parse(path))
      end
    end
  end

  cache[filetype] = snippets
  return snippets
end

return M
