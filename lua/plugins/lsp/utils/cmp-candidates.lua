-- Path candidates, as LSP completion items; builtin-cmp.lua serves them as a
-- 'complete' function. Buffer words and snippets belong to core and zsnip, and
-- the listing to getcompletion() -- what is left is finding where a path token
-- starts, which takes a cursor and so cannot be asked of it.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

---getcompletion() has no limit of its own; a wide directory answers with all of it.
local PATH_LIMIT = 250

---Longest path token recognised, and the bound on path_split's scan.
local MAX_TOKEN = 256

local M = {}

local function before_cursor()
  return api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])
end

---Relative tokens anchor to the buffer's directory; getcompletion() resolves
---against cwd alone. Keeps the trailing '/' for the caller to concatenate onto.
---@param dir string ends in '/'
---@return string? dir resolved, ending in '/'
local function resolve_dir(dir)
  if vim.startswith(dir, '/') then
    return dir
  elseif vim.startswith(dir, '~/') then
    return vim.fs.normalize(dir) .. '/'
  end

  local name = api.nvim_buf_get_name(0)
  local root = name ~= '' and vim.fs.dirname(name) or vim.uv.cwd()
  return root and root .. '/' .. dir or nil
end

---Splits the path token into a directory to list and a segment to match. The
---character class also keeps globs out of getcompletion(); \128-\255 admits
---multibyte components. Only the last MAX_TOKEN bytes are scanned: a '$'-anchored
---run restarts at every position, and the class covers the base64 alphabet, so a
---long data URI would otherwise cost milliseconds per keystroke.
---@param before string
---@return string? dir ends in '/'
---@return string? segment possibly empty
local function path_split(before)
  local token = before:sub(-MAX_TOKEN):match '[%w%._%-%+@~$/\128-\255]*$'
  local dir = token:match '^(.*/)'
  -- A comment marker ('//'), a division ('a /'), or a url scheme -- not a path
  -- worth listing '/' for.
  if not dir or dir:find('//', 1, true) or not dir:sub(1, -2):match '[^/]' then
    return nil
  end
  return dir, token:sub(#dir + 1)
end

---@return integer? col 0-based start of the path token, nil outside one
function M.path_start()
  local before = before_cursor()
  local dir, segment = path_split(before)
  return dir and #before - #dir - #segment or nil
end

---Derived from the live line rather than the 'complete' function's `base`, which
---is frozen at the first call of a cycle and goes stale the moment you type.
---@return lsp.CompletionItem[]? items nil when the cursor is not inside a path
function M.path()
  local dir, segment = path_split(before_cursor())
  if not dir then
    return nil
  end

  local root = resolve_dir(dir)
  if not root then
    return nil
  end

  local items = {}
  for _, match in ipairs(vim.fn.getcompletion(root .. segment, 'file')) do
    if #items >= PATH_LIMIT then
      break
    end
    -- Answers in terms of the pattern it was handed, so the token's own prefix
    -- goes back on in place of the resolved one.
    items[#items + 1] = {
      label = dir .. match:sub(#root + 1),
      kind = vim.endswith(match, '/') and Kind.Folder or Kind.File,
    }
  end
  return items
end

return M
