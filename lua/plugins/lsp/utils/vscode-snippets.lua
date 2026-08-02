-- Snippet packages on the runtimepath, in both formats plugins ship:
-- VSCode (rafamadriz/friendly-snippets and anything shaped like it), where a
-- package.json says which languages each file covers, and snipmate
-- (apple/pkl-neovim), where the filename is the filetype. Either way the bodies
-- are already LSP snippet syntax and need no translation to reach the menu.
--
-- Discovery matches luasnip's from_vscode and from_snipmate loaders between
-- them, so the same plugins are picked up under either completion engine.

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
  -- '/' catches ${N/regex/format/}, the one form that names a tabstop without
  -- ever writing it plainly.
  for index in body:gmatch '%${(%d+)[:|}/]' do
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
local function parse_vscode(path)
  local snippets = {}
  for name, def in pairs(read_json(path) or {}) do
    -- Every value is someone else's JSON: a non-table entry would raise from
    -- inside the completion handler, on every keystroke, since the failure
    -- happens before the filetype is cached.
    if type(def) == 'table' then
      local body = joined(def.body)
      -- A prefix list means several triggers expand the same body.
      local prefixes = type(def.prefix) == 'table' and def.prefix or { def.prefix or name }
      if body then
        for _, prefix in ipairs(prefixes) do
          if type(prefix) == 'string' then
            snippets[#snippets + 1] = { prefix = prefix, body = body }
          end
        end
      end
    end
  end
  return snippets
end

---snipmate escapes a quote or a backtick that the LSP grammar has no meaning
---for, so `thr` would otherwise insert `throw \"message\"` verbatim. Only those
---two: the grammar passes any other stray backslash straight through (`\d+`
---parses to `\d+`), so a wider rule would eat the backslash out of a regex, a
---LaTeX macro or a Windows path.
---@param body string
---@return string
local function unescape(body)
  return (body:gsub('\\(["`])', '%1'))
end

---snipmate: '#' comments, `snippet <trigger> [description]` headers, and a body
---indented one tab per line. The bodies are already LSP snippet syntax, so only
---the container needs reading.
---@param path string
---@return VscodeSnippet[]
local function parse_snipmate(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return {}
  end

  local snippets, trigger, body, indent, blanks = {}, nil, {}, nil, 0
  local function flush()
    if trigger and #body > 0 then
      snippets[#snippets + 1] = { prefix = trigger, body = unescape(table.concat(body, '\n')) }
    end
    trigger, body, indent, blanks = nil, {}, nil, 0
  end

  for _, line in ipairs(lines) do
    local next_trigger = line:match '^snippet%s+(%S+)'
    if next_trigger then
      flush()
      trigger = next_trigger
    elseif trigger and line:match '^[\t ]' then
      -- The first body line sets the indent the rest is measured against, so a
      -- space-indented file works and deeper nesting keeps its own indent.
      indent = indent or line:match '^[\t ]+'
      -- Held back until a body line follows: blank lines *between* entries are
      -- just spacing, blank lines inside one are part of the snippet.
      for _ = 1, blanks do
        body[#body + 1] = ''
      end
      blanks = 0
      body[#body + 1] = vim.startswith(line, indent) and line:sub(#indent + 1) or line
    elseif line:match '^%s*$' then
      blanks = blanks + 1
    else
      -- A comment or anything else unindented ends the body.
      flush()
    end
  end
  flush()
  return snippets
end

---@param path string
---@return VscodeSnippet[]
local function parse(path)
  local parsed = vim.endswith(path, '.snippets') and parse_snipmate(path) or parse_vscode(path)
  local snippets = {}
  for _, snippet in ipairs(parsed) do
    local body = editable_final_tabstop(snippet.body)
    if expandable(body) then
      snippets[#snippets + 1] = { prefix = snippet.prefix, body = body }
    end
  end
  return snippets
end

---@return table<string, string[]> language to the files contributing to it
local function scan_manifests()
  local by_language = {}
  local function add(language, path)
    by_language[language] = by_language[language] or {}
    local files = by_language[language]
    files[#files + 1] = vim.fs.normalize(path)
  end

  for _, manifest in ipairs(vim.api.nvim_get_runtime_file('package.json', true)) do
    local root = vim.fs.dirname(manifest)
    local declared = vim.tbl_get(read_json(manifest) or {}, 'contributes', 'snippets')
    -- Every plugin's package.json is read, not just snippet packs, so nothing
    -- about the shape can be assumed: `"snippets": "x"` would raise out of
    -- ipairs() and take the completion request with it.
    for _, entry in ipairs(vim.islist(declared) and declared or {}) do
      if type(entry) == 'table' and type(entry.path) == 'string' then
        local languages = type(entry.language) == 'table' and entry.language or { entry.language }
        for _, language in ipairs(languages) do
          if type(language) == 'string' then
            add(language, root .. '/' .. entry.path)
          end
        end
      end
    end
  end

  -- snipmate names its files after the filetype, either directly or as a
  -- directory of them. pkl-neovim ships one and no package.json.
  for _, path in ipairs(vim.api.nvim_get_runtime_file('snippets/*.snippets', true)) do
    add(vim.fn.fnamemodify(path, ':t:r'), path)
  end
  for _, path in ipairs(vim.api.nvim_get_runtime_file('snippets/*/*.snippets', true)) do
    add(vim.fn.fnamemodify(path, ':h:t'), path)
  end

  return by_language
end

---@type table<string, string[]>?
local manifests = nil
---@type string?
local scanned_rtp = nil
---@type table<string, VscodeSnippet[]>
local cache = {}

local M = { resolve = resolve }

---Parsed on first use per filetype: scanning every package.json on the
---runtimepath and decoding the files is too slow to do at startup.
---@param filetype string
---@return VscodeSnippet[]
M.get = function(filetype)
  -- Checked ahead of the cache, not behind it: a plugin loaded on a filetype --
  -- pkl-neovim, say -- joins the runtimepath after we may already have cached an
  -- answer for that very filetype. Reading and comparing costs ~0.1us, and
  -- OptionSet does not fire for 'runtimepath', so there is nothing to hook.
  local rtp = vim.o.runtimepath
  if not manifests or scanned_rtp ~= rtp then
    manifests, scanned_rtp, cache = scan_manifests(), rtp, {}
  end

  if cache[filetype] then
    return cache[filetype]
  end
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
