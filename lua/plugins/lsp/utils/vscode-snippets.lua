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

local M = {}

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
