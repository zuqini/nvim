-- Path candidates, as LSP completion items. Knows nothing about how they reach
-- the menu -- builtin-cmp.lua serves them as a 'complete' function.
--
-- Buffer words and snippets are not here: core's own '.', 'w' and 'b' scan
-- buffers, and zsnip ships a 'complete' source for snippets. The listing is
-- vim.fn.getcompletion()'s too. What is left is deciding where a path token
-- starts in a line, which takes a cursor and so cannot be asked of it.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

---How many items the source will return. getcompletion() has no limit of its
---own and a wide directory answers with all of it.
local PATH_LIMIT = 250

local M = {}

---Relative tokens are anchored to the buffer's own directory, cwd otherwise --
---which is what getcompletion() cannot do, since it resolves against cwd alone.
---The result keeps its trailing '/': the caller concatenates the segment onto
---it, and normalize() would otherwise drop it and glue the two together.
---@param dir string trailing directory part of the token, always ends in '/'
---@param bufnr integer
---@return string? dir resolved, ending in '/'
local function resolve_dir(dir, bufnr)
  if vim.startswith(dir, '/') then
    return dir
  elseif vim.startswith(dir, '~/') then
    return vim.fs.normalize(dir) .. '/'
  end

  local name = api.nvim_buf_get_name(bufnr)
  local root = name ~= '' and vim.fs.dirname(name) or vim.uv.cwd()
  return root and root .. '/' .. dir or nil
end

---@class CmpContext
---@field bufnr integer
---@field before string line up to the cursor
---@field keyword string the run the source is being asked to replace

---The cursor position, and the run being replaced. A source anchored somewhere
---other than the trailing 'iskeyword' run passes the text between its own
---anchor and the cursor.
---@param keyword? string defaults to the trailing 'iskeyword' run
---@return CmpContext
function M.context(keyword)
  local bufnr = api.nvim_get_current_buf()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])
  return { bufnr = bufnr, before = before, keyword = keyword or vim.fn.matchstr(before, '\\k*$') }
end

---Where the path token before the cursor splits into a directory to list and a
---segment to match against. Shared with the findstart in builtin-cmp, which has
---to agree with M.path() on what counts as a path at all.
---
---The character class is also what keeps a glob out of getcompletion(): no '*',
---'?' or '[' can reach it.
---@param before string line up to the cursor
---@return string? dir trailing directory part, always ends in '/'
---@return string? segment the part after it, possibly empty
function M.path_split(before)
  local token = before:match '[%w%._%-%+@~$/]*$'
  local dir = token:match '^(.*/)'
  -- Nothing but slashes ahead of the last one is a comment marker ('//'), a
  -- division ('a /') or the scheme of a url, not a path worth listing '/' for.
  if not dir or not dir:sub(1, -2):match '[^/]' then
    return nil
  end
  return dir, token:sub(#dir + 1)
end

---@param ctx CmpContext
---@return lsp.CompletionItem[]? items nil when the cursor is not inside a path
function M.path(ctx)
  local dir, segment = M.path_split(ctx.before)
  if not dir or not segment then
    return nil
  end

  -- The source anchors at the whole token, so the token is what gets replaced.
  -- If the two ever disagree -- the cursor moved between findstart and here --
  -- offering nothing beats inserting a path that does not exist.
  if ctx.keyword ~= dir .. segment then
    return nil
  end

  local root = resolve_dir(dir, ctx.bufnr)
  if not root then
    return nil
  end

  local items = {}
  for _, match in ipairs(vim.fn.getcompletion(root .. segment, 'file')) do
    if #items >= PATH_LIMIT then
      break
    end
    -- getcompletion() answers in terms of the pattern it was handed, so the
    -- token's own prefix goes back on in place of the resolved one. It appends
    -- '/' to a directory, hides dotfiles until one is asked for, and expands
    -- '~/' -- every rule this file used to carry itself.
    items[#items + 1] = {
      label = dir .. match:sub(#root + 1),
      kind = vim.endswith(match, '/') and Kind.Folder or Kind.File,
    }
  end
  return items
end

return M
