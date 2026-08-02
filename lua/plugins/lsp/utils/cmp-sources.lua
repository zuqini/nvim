-- Snippet, buffer word and path completion, served as an in-process LSP server
-- (see |lsp-server|) so vim.lsp.completion merges it into the same menu as the
-- real servers attached to the buffer.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind
local Format = vim.lsp.protocol.InsertTextFormat

local snippets = require 'plugins.lsp.utils.vscode-snippets'

local NAME = 'cmp-sources'
local MIN_WORD_LEN = 3
local MAX_SCAN_LINES = 20000
local RESCAN_INTERVAL_NS = 5e9
local MAX_BUFFER_ITEMS = 200
local MAX_PATH_ITEMS = 250
local MAX_SNIPPET_ITEMS = 30

---@type table<string, { word: string, prefix: string }>
local kw_patterns = {}

---vim.lsp.completion filters the merged menu against the trailing 'iskeyword'
---run, so the sources have to agree on what a word is. In css (iskeyword+=-) a
---plain [%w_] prefix offers candidates for 'di' while the menu filters on
---'flex-di', and every one of them gets dropped again.
---Reads the current buffer's 'iskeyword' -- '\k' is buffer-local.
---@return { word: string, prefix: string }
local function patterns()
  local iskeyword = vim.bo.iskeyword
  local cached = kw_patterns[iskeyword]
  if cached then
    return cached
  end

  local extra = {}
  for byte = 33, 126 do
    local char = string.char(byte)
    -- '%' turns any punctuation into a literal inside a Lua character class.
    if not char:match '[%w_]' and vim.fn.match(char, '\\k') == 0 then
      extra[#extra + 1] = '%' .. char
    end
  end
  extra = table.concat(extra)

  cached = { word = ('[%%a_%s][%%w_%s]*'):format(extra, extra), prefix = ('[%%w_%s]*$'):format(extra) }
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
---@param pattern string
---@return string[]
local function rescan(bufnr, pattern)
  if not api.nvim_buf_is_valid(bufnr) then
    word_cache[bufnr] = nil
    return {}
  end
  local words = words_in(api.nvim_buf_get_lines(bufnr, 0, MAX_SCAN_LINES, false), pattern)
  word_cache[bufnr] = { tick = vim.b[bufnr].changedtick, time = vim.uv.hrtime(), words = words, pattern = pattern }
  return words
end

---A full scan costs ~10ms on a 20k line buffer, too much to spend on the
---keystroke that wants the words, so a stale cache is served and refreshed on
---the next tick. Words typed since then are picked up by visible_words().
---@param bufnr integer
---@param pattern string
---@return string[]
local function buffer_words(bufnr, pattern)
  local cached = word_cache[bufnr]
  if not cached or cached.pattern ~= pattern then
    return rescan(bufnr, pattern)
  end

  local stale = cached.tick ~= vim.b[bufnr].changedtick
  if stale and not cached.scanning and vim.uv.hrtime() - cached.time >= RESCAN_INTERVAL_NS then
    cached.scanning = true
    vim.schedule(function()
      rescan(bufnr, pattern)
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

---@param item table complete-item
---@return vim.lsp.Client?
local function client_of(item)
  local client_id = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'client_id')
  return client_id and vim.lsp.get_client_by_id(client_id) or nil
end

---Words the real servers offered for the menu on screen. The merge has no hook
---to drop duplicates, so the sources skip them instead; the menu lags a
---keystroke behind, so a fresh one can still show a word twice.
---@return table<string, true>
local function lsp_words()
  local words = {}
  for _, item in ipairs(vim.fn.complete_info({ 'items' }).items) do
    local client = client_of(item)
    if client and client.name ~= NAME then
      words[item.word] = true
    end
  end
  return words
end

---@param prefix string keyword under the cursor
---@param pattern string
---@param taken fun(): table<string, true> words already in the menu
---@return lsp.CompletionItem[]
local function buffer_source(prefix, pattern, taken)
  -- An empty prefix would dump the whole buffer into the menu.
  if prefix == '' then
    return {}
  end

  local seen = taken()
  local items, added = {}, {}
  local function add(words)
    local limit = MAX_BUFFER_ITEMS - #items
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

  add(visible_words(pattern))
  for _, buf in ipairs(visible_buffers()) do
    -- Checked here too: Lua evaluates buffer_words() before add() can bail, so
    -- a filled menu would still pay for a full scan of every other buffer.
    if #items >= MAX_BUFFER_ITEMS then
      break
    end
    add(buffer_words(buf, pattern))
  end
  return items
end

---friendly-snippets and friends. The bodies are already LSP snippet syntax, so
---insertTextFormat is enough for vim.lsp.completion to expand them.
---@param prefix string keyword under the cursor
---@param bufnr integer
---@param taken fun(): table<string, true> triggers already in the menu
---@return lsp.CompletionItem[]
local function snippet_source(prefix, bufnr, taken)
  if prefix == '' then
    return {}
  end

  local seen = taken()
  local by_trigger = {}
  local triggers = {}
  for _, snippet in ipairs(snippets.get(vim.bo[bufnr].filetype)) do
    if not seen[snippet.prefix] and not by_trigger[snippet.prefix] then
      by_trigger[snippet.prefix] = snippet
      triggers[#triggers + 1] = snippet.prefix
    end
  end

  local items = {}
  for _, trigger in ipairs(vim.fn.matchfuzzy(triggers, prefix, { limit = MAX_SNIPPET_ITEMS })) do
    local snippet = by_trigger[trigger]
    -- No detail/documentation on purpose: without them the popup previews the
    -- expanded snippet, which beats friendly-snippets' terse descriptions.
    items[#items + 1] = {
      label = trigger,
      kind = Kind.Snippet,
      insertText = snippet.body,
      insertTextFormat = Format.Snippet,
      sortText = ('%04d'):format(#items),
    }
  end
  return items
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

---@param before string line up to the cursor
---@param bufnr integer
---@param taken fun(): table<string, true> entries already in the menu
---@return lsp.CompletionItem[]? items nil when the cursor is not inside a path
local function path_source(before, bufnr, taken)
  local token = before:match '[%w%._%-%+@~$/]*$'
  local dir = token:match '^(.*/)'
  -- Nothing but slashes ahead of the last one is a comment marker ('//'), a
  -- division ('a /') or the scheme of a url, not a path worth listing '/' for.
  if not dir or not dir:sub(1, -2):match '[^/]' then
    return nil
  end

  local path = resolve_dir(dir, bufnr)
  local scanner = path and vim.uv.fs_scandir(path)
  if not scanner then
    return nil
  end

  -- Completion replaces the trailing 'iskeyword' run, so in './lualine.lua'
  -- only 'lua' is replaceable; the rest is ours to filter on and trim off.
  -- Must be the same run vim.lsp.completion computes, or the insert is offset.
  local segment = token:sub(#dir + 1)
  local keyword = vim.fn.matchstr(before, '\\k*$')
  -- Filetypes with '/' in 'iskeyword' (clojure, dune) leave that run reaching
  -- back past the separator, so there is nothing here we can anchor to.
  if #keyword > #segment then
    return nil
  end

  local typed = segment:sub(1, #segment - #keyword)
  local wanted = segment:lower()
  local hidden = vim.startswith(segment, '.')

  local seen = taken()
  local items = {}
  while #items < MAX_PATH_ITEMS do
    local name, type = vim.uv.fs_scandir_next(scanner)
    if not name then
      break
    end
    local is_dir = type == 'directory'
    local label = is_dir and name .. '/' or name
    -- Only the replaceable run can be case-corrected; `typed` stays in the
    -- buffer verbatim, so an entry it doesn't literally prefix would insert a
    -- path that does not exist. A server offering the same entry may not have
    -- kept the slash.
    if
      vim.startswith(name:lower(), wanted)
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
        kind = is_dir and Kind.Folder or Kind.File,
      }
    end
  end
  return items
end

---A server can anchor its items before the keyword boundary -- lua_ls offers
---'plenary.async' for `require('plenary.asy` -- and vim.lsp.completion applies
---that one anchor to the whole merged menu. Our items carry no textEdit, so the
---missing-prefix correction skips them (see |vim.lsp.completion|), and accepting
---one deletes back to the server's anchor: 'require('asyncthing'. Standing down
---after a separator costs little, since the server's own members are what is
---wanted there anyway.
---@param before string line up to the cursor
---@param bufnr integer
---@return boolean
local function server_anchored(before, bufnr)
  local keyword = vim.fn.matchstr(before, '\\k*$')
  local at = #before - #keyword
  local separator = at > 0 and before:sub(at, at) or ''
  if separator ~= '.' and separator ~= ':' and separator ~= '/' then
    return false
  end
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name ~= NAME then
      return true
    end
  end
  return false
end

---@return lsp.CompletionItem[]
local function completion_items()
  local bufnr = api.nvim_get_current_buf()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])

  -- Deferred: complete_info() marshals every item in the menu, thousands of
  -- them on a big LSP response, and most requests bail before needing it.
  local words
  local function taken()
    words = words or lsp_words()
    return words
  end

  -- Inside a path, the other sources are just noise, even if nothing is left
  -- to offer.
  local paths = path_source(before, bufnr, taken)
  if paths then
    return paths
  end

  if server_anchored(before, bufnr) then
    return {}
  end

  local pattern = patterns()
  local prefix = before:match(pattern.prefix)
  return vim.list_extend(snippet_source(prefix, bufnr, taken), buffer_source(prefix, pattern.word, taken))
end

local methods = {
  initialize = function(_, callback)
    callback(nil, {
      capabilities = {
        -- builtin-cmp adds the word characters on top of these.
        completionProvider = { triggerCharacters = { '/', '.', '~' } },
      },
    })
  end,
  shutdown = function(_, callback)
    callback(nil, nil)
  end,
  ['textDocument/completion'] = function(_, callback)
    callback(nil, { isIncomplete = false, items = completion_items() })
  end,
}

---@param dispatchers vim.lsp.rpc.Dispatchers
---@return vim.lsp.rpc.Client
local function cmd(dispatchers)
  local closing, request_id = false, 0

  ---Both a graceful 'exit' and a forced stop land here; without on_exit the
  ---client is never removed and the next BufEnter starts a second one.
  local function exit()
    if not closing then
      closing = true
      dispatchers.on_exit(0, 15)
    end
  end

  return {
    ---notify_reply_callback is what clears the request from client.requests;
    ---skipping it leaks a pending entry per keystroke.
    request = function(method, params, callback, notify_reply_callback)
      request_id = request_id + 1
      local id = request_id
      local function reply(err, result)
        callback(err, result, id)
        if notify_reply_callback then
          notify_reply_callback(id)
        end
      end

      local impl = methods[method]
      if impl then
        impl(params, reply)
      else
        reply({ code = -32601, message = 'Method not found: ' .. method }, nil)
      end
      return true, id
    end,
    notify = function(method)
      if method == 'exit' then
        exit()
      end
      -- False means "shut down" to the caller, which suppresses LspNotify.
      return not closing
    end,
    is_closing = function()
      return closing
    end,
    terminate = exit,
  }
end

local M = { name = NAME }

---@param item table complete-item
---@return boolean
M.owns = function(item)
  local client = client_of(item)
  return client ~= nil and client.name == NAME
end

---Terminal, quickfix and plugin scratch buffers are still buftype '' at
---BufEnter and only settle afterwards, so decide on the next tick.
---@param bufnr integer
local function attach(bufnr)
  vim.schedule(function()
    if api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == '' then
      vim.lsp.start({ name = NAME, cmd = cmd }, { bufnr = bufnr })
    end
  end)
end

M.enable = function()
  local group = api.nvim_create_augroup(NAME, {})
  api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args)
      attach(args.buf)
    end,
  })
  api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args)
      word_cache[args.buf] = nil
    end,
  })

  -- Buffers opened before this ran never see BufEnter.
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      attach(buf)
    end
  end
end

return M
