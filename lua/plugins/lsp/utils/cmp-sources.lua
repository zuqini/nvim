-- Snippet, buffer word and path completion, served as an in-process LSP server
-- (see |lsp-server|) so vim.lsp.completion merges it into the same menu as the
-- real servers attached to the buffer. The candidates themselves come from
-- cmp-candidates.lua, which native-cmp.lua serves a different way.
local api = vim.api

local candidates = require 'plugins.lsp.utils.cmp-candidates'

local NAME = 'cmp-sources'

---@param item table complete-item
---@return vim.lsp.Client?
local function client_of(item)
  local client_id = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'client_id')
  return client_id and vim.lsp.get_client_by_id(client_id) or nil
end

---Words the real servers offered for the menu on screen. The merge has no hook
---to drop duplicates, so the sources skip them instead; the menu lags a
---keystroke behind, so a fresh one can still show a word twice.
---complete_info() marshals the whole menu, thousands of items on a big response,
---so the client is resolved once up front rather than per item.
---@return table<string, true>
local function lsp_words()
  local ours = {}
  for _, client in ipairs(vim.lsp.get_clients { name = NAME }) do
    ours[client.id] = true
  end

  local words = {}
  for _, item in ipairs(vim.fn.complete_info({ 'items' }).items) do
    local client_id = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'client_id')
    if client_id and not ours[client_id] then
      words[item.word] = true
    end
  end
  return words
end

---A server can anchor its items before the keyword boundary -- lua_ls offers
---'plenary.async' for `require('plenary.asy` -- and vim.lsp.completion applies
---that one anchor to the whole merged menu. Our items carry no textEdit, so the
---missing-prefix correction skips them (see |vim.lsp.completion|), and accepting
---one deletes back to the server's anchor: 'require('asyncthing'. Standing down
---after a separator costs little, since the server's own members are what is
---wanted there anyway.
---@param ctx CmpContext
---@return boolean
local function server_anchored(ctx)
  local at = #ctx.before - #ctx.keyword
  local separator = at > 0 and ctx.before:sub(at, at) or ''
  if separator ~= '.' and separator ~= ':' and separator ~= '/' then
    return false
  end
  for _, client in ipairs(vim.lsp.get_clients { bufnr = ctx.bufnr }) do
    if client.name ~= NAME then
      return true
    end
  end
  return false
end

---@return lsp.CompletionItem[]
local function completion_items()
  local ctx = candidates.context()

  -- Deferred: complete_info() marshals every item in the menu, thousands of
  -- them on a big LSP response, and most requests bail before needing it.
  local words
  local function taken()
    words = words or lsp_words()
    return words
  end

  -- Inside a path, the other sources are just noise, even if nothing is left
  -- to offer.
  local paths = candidates.path(ctx, taken)
  if paths then
    return paths
  end

  if server_anchored(ctx) then
    return {}
  end

  return vim.list_extend(candidates.snippet(ctx, taken), candidates.buffer(ctx, taken))
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
  -- BufUnload too: an unloaded buffer keeps its entry otherwise, and its
  -- contents are re-read from disk if it comes back.
  api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout', 'BufUnload' }, {
    group = group,
    callback = function(args)
      candidates.forget(args.buf)
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
