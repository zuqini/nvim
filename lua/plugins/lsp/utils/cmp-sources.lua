-- Buffer word and path completion, served as an in-process LSP server (see
-- |lsp-server|) so vim.lsp.completion merges it into the same menu as the real
-- servers attached to the buffer.
local api = vim.api
local Kind = vim.lsp.protocol.CompletionItemKind

local NAME = 'cmp-sources'
local WORD_PATTERN = '[%a_][%w_]*'
local MIN_WORD_LEN = 3
local MAX_SCAN_LINES = 20000
local RESCAN_INTERVAL_NS = 5e9
local MAX_BUFFER_ITEMS = 200
local MAX_PATH_ITEMS = 250

---@param lines string[]
---@return string[]
local function words_in(lines)
  local seen, words = {}, {}
  for _, line in ipairs(lines) do
    for word in line:gmatch(WORD_PATTERN) do
      if #word >= MIN_WORD_LEN and not seen[word] then
        seen[word] = true
        words[#words + 1] = word
      end
    end
  end
  return words
end

---@type table<integer, { tick: integer, time: integer, words: string[] }>
local word_cache = {}

---Throttled: a full scan costs ~10ms on a 20k line buffer, and words typed
---since the last one are picked up by visible_words().
---@param bufnr integer
---@return string[]
local function buffer_words(bufnr)
  local cached = word_cache[bufnr]
  local tick = vim.b[bufnr].changedtick
  local now = vim.uv.hrtime()
  if cached and (cached.tick == tick or now - cached.time < RESCAN_INTERVAL_NS) then
    return cached.words
  end

  local words = words_in(api.nvim_buf_get_lines(bufnr, 0, MAX_SCAN_LINES, false))
  word_cache[bufnr] = { tick = tick, time = now, words = words }
  return words
end

---@return string[]
local function visible_words()
  local top, bot = vim.fn.line 'w0' - 1, vim.fn.line 'w$'
  return words_in(api.nvim_buf_get_lines(0, top, bot, false))
end

---@return integer[]
local function visible_buffers()
  local cur = api.nvim_get_current_buf()
  local bufs, seen = { cur }, { [cur] = true }
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    if not seen[buf] and vim.bo[buf].buftype == '' then
      seen[buf] = true
      bufs[#bufs + 1] = buf
    end
  end
  return bufs
end

---Words the real servers offered for the menu on screen. The merge has no hook
---to drop duplicates, so the sources skip them instead; the menu lags a
---keystroke behind, so a fresh one can still show a word twice.
---@return table<string, true>
local function lsp_words()
  local words = {}
  for _, item in ipairs(vim.fn.complete_info({ 'items' }).items) do
    local client_id = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'client_id')
    local client = client_id and vim.lsp.get_client_by_id(client_id)
    if client and client.name ~= NAME then
      words[item.word] = true
    end
  end
  return words
end

---@param prefix string keyword under the cursor
---@param taken table<string, true> words already in the menu
---@return lsp.CompletionItem[]
local function buffer_source(prefix, taken)
  -- An empty prefix would dump the whole buffer into the menu.
  if prefix == '' then
    return {}
  end

  local items = {}
  local function add(words)
    local limit = MAX_BUFFER_ITEMS - #items
    if limit <= 0 then
      return
    end
    for _, word in ipairs(vim.fn.matchfuzzy(words, prefix, { limit = limit })) do
      if word ~= prefix and not taken[word] then
        taken[word] = true
        items[#items + 1] = { label = word, kind = Kind.Text, sortText = ('%04d'):format(#items) }
      end
    end
  end

  add(visible_words())
  for _, buf in ipairs(visible_buffers()) do
    add(buffer_words(buf))
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
---@param taken table<string, true> entries already in the menu
---@return lsp.CompletionItem[]? items nil when the cursor is not inside a path
local function path_source(before, bufnr, taken)
  local token = before:match '[%w%._%-%+@~$/]*$'
  local dir = token:match '^(.*/)'
  if not dir then
    return nil
  end

  local path = resolve_dir(dir, bufnr)
  local scanner = path and vim.uv.fs_scandir(path)
  if not scanner then
    return nil
  end

  -- Completion replaces from the last keyword character, so in './lualine.lua'
  -- only 'lua' is replaceable; the rest is ours to filter on and trim off.
  local segment = token:sub(#dir + 1)
  local typed = segment:sub(1, #segment - #segment:match '[%w_]*$')
  local wanted = segment:lower()
  local hidden = vim.startswith(segment, '.')

  local items = {}
  while #items < MAX_PATH_ITEMS do
    local name, type = vim.uv.fs_scandir_next(scanner)
    if not name then
      break
    end
    local is_dir = type == 'directory'
    local label = is_dir and name .. '/' or name
    -- A server offering the same entry may not have kept the slash.
    if
      vim.startswith(name:lower(), wanted)
      and (hidden or not vim.startswith(name, '.'))
      and not taken[label]
      and not taken[name]
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

---@return lsp.CompletionItem[]
local function completion_items()
  local bufnr = api.nvim_get_current_buf()
  local before = api.nvim_get_current_line():sub(1, api.nvim_win_get_cursor(0)[2])

  local taken = lsp_words()

  -- Inside a path, buffer words are just noise, even if nothing is left to offer.
  return path_source(before, bufnr, taken) or buffer_source(before:match '[%w_]*$', taken)
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
  return {
    request = function(method, params, callback)
      local impl = methods[method]
      if impl then
        impl(params, callback)
      end
      request_id = request_id + 1
      return true, request_id
    end,
    notify = function(method)
      if method == 'exit' then
        dispatchers.on_exit(0, 15)
      end
      return false
    end,
    is_closing = function()
      return closing
    end,
    terminate = function()
      closing = true
    end,
  }
end

local M = { name = NAME }

---@param bufnr integer
local function attach(bufnr)
  if vim.bo[bufnr].buftype == '' then
    vim.lsp.start({ name = NAME, cmd = cmd }, { bufnr = bufnr })
  end
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
