-- Snippet, buffer word and path candidates, as LSP completion items. Knows
-- nothing about how they reach the menu: cmp-sources.lua serves them through an
-- in-process LSP server, native-cmp.lua through 'complete' functions.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

local zsnip = require 'zsnip'

local MIN_WORD_LEN = 3
local MAX_SCAN_LINES = 20000
local RESCAN_INTERVAL_NS = 5e9
local MAX_CACHED_DIRS = 64

local M = {}

---How many items each source will return. Also what native-cmp hands 'complete'
---as its per-source '^{count}', so the two cannot drift apart.
M.limits = { path = 250, snippet = 30, buffer = 200 }

---@type table<string, string>
local kw_patterns = {}

---The scan has to agree with what '\k' calls a word, since vim.lsp.completion
---filters the merged menu against the trailing 'iskeyword' run: in css
---(iskeyword+=-) a plain [%w_] scan offers 'direction' while the menu filters on
---'flex-di'. Only the scan needs a Lua pattern -- the prefix comes from
---matchstr('\k*$'), which is the run nvim itself computes.
---@param bufnr integer
---@return string
local function word_pattern(bufnr)
  local iskeyword = vim.bo[bufnr].iskeyword
  local cached = kw_patterns[iskeyword]
  if cached then
    return cached
  end

  local extra = {}
  -- '\k' is buffer-local, so the probe has to run in that buffer.
  api.nvim_buf_call(bufnr, function()
    for byte = 33, 126 do
      local char = string.char(byte)
      -- '%' turns any punctuation into a literal inside a Lua character class.
      if not char:match '[%w_]' and vim.fn.match(char, '\\k') == 0 then
        extra[#extra + 1] = '%' .. char
      end
    end
    -- A byte range is as close as a Lua pattern gets to 'iskeyword' 192-255,
    -- which is in every default value ('\195\169' is 'é'). Without it 'café_x'
    -- scans as 'caf' plus '_x' and never matches the menu's own 'café_x' filter.
    -- It also swallows non-Latin-1 punctuation, which costs only a candidate
    -- that the same filter drops again.
    if vim.fn.match('\195\169', '\\k') == 0 then
      extra[#extra + 1] = '\128-\255'
    end
  end)
  extra = table.concat(extra)

  cached = ('[%%a_%s][%%w_%s]*'):format(extra, extra)
  kw_patterns[iskeyword] = cached
  return cached
end

---@param lines string[]
---@param pattern string
---@return string[]
local function words_in(lines, pattern)
  local seen, words = {}, {}
  for _, line in ipairs(lines) do
    for word in line:gmatch(pattern) do
      if #word >= MIN_WORD_LEN and not seen[word] then
        seen[word] = true
        words[#words + 1] = word
      end
    end
  end
  return words
end

---@type table<integer, { tick: integer, time: integer, words: string[], pattern: string, scanning: boolean? }>
local word_cache = {}

---@param bufnr integer
---@return string[]
local function rescan(bufnr)
  if not api.nvim_buf_is_valid(bufnr) then
    word_cache[bufnr] = nil
    return {}
  end
  local pattern = word_pattern(bufnr)
  local words = words_in(api.nvim_buf_get_lines(bufnr, 0, MAX_SCAN_LINES, false), pattern)
  word_cache[bufnr] = { tick = vim.b[bufnr].changedtick, time = vim.uv.hrtime(), words = words, pattern = pattern }
  return words
end

---A full scan costs ~10ms on a 20k line buffer, too much to spend on the
---keystroke that wants the words, so a stale cache is served and refreshed on
---the next tick. Words typed since then are picked up by visible_words().
---Each buffer is scanned with its own 'iskeyword', so entering a window with a
---different one no longer invalidates every other visible buffer at once.
---@param bufnr integer
---@return string[]
local function buffer_words(bufnr)
  local cached = word_cache[bufnr]
  if not cached or cached.pattern ~= word_pattern(bufnr) then
    return rescan(bufnr)
  end

  local stale = cached.tick ~= vim.b[bufnr].changedtick
  if stale and not cached.scanning and vim.uv.hrtime() - cached.time >= RESCAN_INTERVAL_NS then
    cached.scanning = true
    vim.schedule(function()
      rescan(bufnr)
    end)
  end
  return cached.words
end

---@param pattern string
---@return string[]
local function visible_words(pattern)
  local top, bot = vim.fn.line 'w0' - 1, vim.fn.line 'w$'
  return words_in(api.nvim_buf_get_lines(0, top, bot, false), pattern)
end

---@return integer[]
local function visible_buffers()
  local cur = api.nvim_get_current_buf()
  local bufs, seen = { cur }, { [cur] = true }
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    local buf = api.nvim_win_get_buf(win)
    if not seen[buf] and vim.bo[buf].buftype == '' then
      seen[buf] = true
      bufs[#bufs + 1] = buf
    end
  end
  return bufs
end

---Relative tokens are anchored to the buffer's own directory, cwd otherwise.
---@param dir string trailing directory part of the token, always ends in '/'
---@param bufnr integer
---@return string?
local function resolve_dir(dir, bufnr)
  if vim.startswith(dir, '/') then
    return dir
  elseif vim.startswith(dir, '~/') then
    return vim.fs.normalize(dir)
  end

  local name = api.nvim_buf_get_name(bufnr)
  local root = name ~= '' and vim.fs.dirname(name) or vim.uv.cwd()
  return root and root .. '/' .. dir or nil
end

---@class DirListing
---@field mtime number
---@field labels string[] name, with a '/' appended for directories
---@field names string[] the same names, without it
---@field lowers string[] and lowercased, for the case-insensitive match

---@type table<string, DirListing>
local dir_cache = {}

---A scandir costs ~9ms in a 20k entry directory (node_modules, build output, a
---monorepo target/) and the filter below only stops after limits.path *matches*,
---so a narrow prefix walked the whole thing on every keystroke.
---A directory's mtime changes whenever an entry is added or removed, which is
---all this listing depends on. The three forms are derived once here rather
---than rebuilt per entry per keystroke; for a lowercase file name Lua interns
---all three to the same string.
---@param path string
---@return DirListing? nil when the path is not a readable directory
local function dir_entries(path)
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= 'directory' then
    return nil
  end

  local mtime = stat.mtime.sec + stat.mtime.nsec / 1e9
  local cached = dir_cache[path]
  if cached and cached.mtime == mtime then
    return cached
  end

  local scanner = vim.uv.fs_scandir(path)
  if not scanner then
    return nil
  end
  local listing = { mtime = mtime, labels = {}, names = {}, lowers = {} }
  local n = 0
  while true do
    local name, type = vim.uv.fs_scandir_next(scanner)
    if not name then
      break
    end
    n = n + 1
    listing.labels[n] = type == 'directory' and name .. '/' or name
    listing.names[n] = name
    listing.lowers[n] = name:lower()
  end

  if not cached and vim.tbl_count(dir_cache) >= MAX_CACHED_DIRS then
    dir_cache = {}
  end
  dir_cache[path] = listing
  return listing
end

---@class CmpContext
---@field bufnr integer
---@field before string line up to the cursor
---@field keyword string the run each source is being asked to replace

---@type table<string, true>
local nothing_taken = {}

---@param taken? fun(): table<string, true>
---@return table<string, true>
local function words_taken(taken)
  return taken and taken() or nothing_taken
end

---The context every source shares: the cursor position, and the trailing
---'iskeyword' run as the run being replaced. Engines that can anchor a source
---somewhere else -- native-cmp does, per source -- overwrite `keyword` with the
---text between their own anchor and the cursor.
---@return CmpContext
function M.context()
  local bufnr = api.nvim_get_current_buf()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])
  -- Taken from '\k' rather than reconstructed, so it cannot drift from the run
  -- vim.lsp.completion filters the merged menu against.
  return { bufnr = bufnr, before = before, keyword = vim.fn.matchstr(before, '\\k*$') }
end

---Where the path token before the cursor splits into a directory to list and a
---segment to match against. Shared with native-cmp, whose findstart has to
---agree with M.path() on what counts as a path at all.
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
---@param taken? fun(): table<string, true> entries already in the menu
---@return lsp.CompletionItem[]? items nil when the cursor is not inside a path
function M.path(ctx, taken)
  local dir, segment = M.path_split(ctx.before)
  if not dir or not segment then
    return nil
  end

  local path = resolve_dir(dir, ctx.bufnr)
  local listing = path and dir_entries(path)
  if not listing then
    return nil
  end

  -- Only ctx.keyword is replaceable, so in './lualine.lua' an engine anchored at
  -- the 'iskeyword' run can replace only 'lua'; the rest is ours to filter on
  -- and trim off. An engine that anchors at the segment passes the whole segment
  -- as the keyword, and `typed` falls out empty.
  -- Filetypes with '/' in 'iskeyword' (clojure, dune) leave that run reaching
  -- back past the separator, so there is nothing here we can anchor to.
  if #ctx.keyword > #segment then
    return nil
  end

  local typed = segment:sub(1, #segment - #ctx.keyword)
  local wanted = segment:lower()
  local hidden = vim.startswith(segment, '.')

  local seen = words_taken(taken)
  local items = {}
  local labels, names, lowers = listing.labels, listing.names, listing.lowers
  for i = 1, #labels do
    if #items >= M.limits.path then
      break
    end
    local label, name = labels[i], names[i]
    -- Only the replaceable run can be case-corrected; `typed` stays in the
    -- buffer verbatim, so an entry it doesn't literally prefix would insert a
    -- path that does not exist. A server offering the same entry may not have
    -- kept the slash.
    if
      vim.startswith(lowers[i], wanted)
      and vim.startswith(name, typed)
      -- Nothing left to insert: complete() falls back to the label and would
      -- duplicate what the buffer already holds.
      and #label > #typed
      and (hidden or not vim.startswith(name, '.'))
      and not seen[label]
      and not seen[name]
    then
      items[#items + 1] = {
        label = label,
        insertText = label:sub(#typed + 1),
        filterText = label:sub(#typed + 1),
        kind = label ~= name and Kind.Folder or Kind.File,
      }
    end
  end
  return items
end

---friendly-snippets and friends, discovered and read by zsnip. The bodies are
---already LSP snippet syntax, so insertTextFormat is enough for
---vim.lsp.completion to expand them.
---@param ctx CmpContext
---@param taken? fun(): table<string, true> triggers already in the menu
---@return lsp.CompletionItem[]
function M.snippet(ctx, taken)
  if ctx.keyword == '' then
    return {}
  end

  local seen = words_taken(taken)
  return zsnip.completion_items({
    prefix = ctx.keyword,
    bufnr = ctx.bufnr,
    limit = M.limits.snippet,
    -- No detail/documentation on purpose: without them the popup previews the
    -- expanded snippet, which beats friendly-snippets' terse descriptions.
    documentation = false,
    -- Filtered before the limit is spent, so a trigger a real server already
    -- offered does not cost a slot.
    filter = function(snippet)
      return not seen[snippet.prefix]
    end,
  })
end

---@param ctx CmpContext
---@param taken? fun(): table<string, true> words already in the menu
---@param check? fun(): boolean asked between buffers whether to give up scanning
---@return lsp.CompletionItem[]
function M.buffer(ctx, taken, check)
  -- An empty prefix would dump the whole buffer into the menu.
  if ctx.keyword == '' then
    return {}
  end

  local prefix = ctx.keyword
  local seen = words_taken(taken)
  local items, added = {}, {}
  local function add(words)
    local limit = M.limits.buffer - #items
    if limit <= 0 then
      return
    end
    -- Filter before matchfuzzy: its limit caps the input, and the words we drop
    -- are the ones a real server already offered, i.e. the best matches.
    local candidates = vim.tbl_filter(function(word)
      return word ~= prefix and not seen[word] and not added[word]
    end, words)
    for _, word in ipairs(vim.fn.matchfuzzy(candidates, prefix, { limit = limit })) do
      added[word] = true
      items[#items + 1] = { label = word, kind = Kind.Text, sortText = ('%04d'):format(#items) }
    end
  end

  add(visible_words(word_pattern(ctx.bufnr)))
  for _, buf in ipairs(visible_buffers()) do
    -- Checked here too: Lua evaluates buffer_words() before add() can bail, so
    -- a filled menu would still pay for a full scan of every other buffer.
    if #items >= M.limits.buffer or (check and check()) then
      break
    end
    add(buffer_words(buf))
  end
  return items
end

---Drop a buffer's cached word list; the engines call this from their own
---BufDelete/BufWipeout/BufUnload autocmds.
---@param bufnr integer
function M.forget(bufnr)
  word_cache[bufnr] = nil
end

return M
