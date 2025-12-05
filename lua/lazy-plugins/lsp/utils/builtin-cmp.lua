local docs_debounce_ms = 100
local timer = vim.uv.new_timer()

---For replacing certain <C-x>... keymaps.
---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

local function supertab()
  if pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    if next(vim.lsp.get_clients { bufnr = 0 }) then
      vim.lsp.completion.get()
    else
      if vim.bo.omnifunc == '' then
        feedkeys '<C-x><C-n>'
      else
        feedkeys '<C-x><C-o>'
      end
    end
  end
end

--- lifted from:
---   https://www.reddit.com/r/neovim/comments/1f02fp9/comment/ljtzucj/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
---   https://github.com/konradmalik/neovim-flake/blob/6dba374af89a294c976d72615cca6cfca583a9f2/config/native/lua/pde/lsp/completion.lua
---@param client vim.lsp.Client
---@param bufnr integer
local function enable_completion_documentation(client, bufnr)
  if not timer then
    vim.notify("cannot create timer", vim.log.levels.ERROR)
    return {}
  end

  vim.api.nvim_create_autocmd("CompleteChanged", {
    buffer = bufnr,
    callback = function()
      timer:stop()

      local client_id =
          vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "client_id")
      if client_id ~= client.id then return end

      local completion_item =
          vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
      if not completion_item then return end

      local complete_info = vim.fn.complete_info({ "selected" })
      if vim.tbl_isempty(complete_info) then return end

      timer:start(
        docs_debounce_ms,
        0,
        vim.schedule_wrap(function()
          client.request(
            vim.lsp.protocol.Methods.completionItem_resolve,
            completion_item,
            ---@param err lsp.ResponseError
            ---@param result any
            function(err, result)
              if err ~= nil then
                vim.notify(
                  "client " .. client.id .. vim.inspect(err),
                  vim.log.levels.ERROR
                )
                return
              end

              local docs = vim.tbl_get(result, "documentation", "value")
              if not docs then return end

              local wininfo =
                  vim.api.nvim__complete_set(complete_info.selected, { info = docs })
              if
                  vim.tbl_isempty(wininfo)
                  or not vim.api.nvim_win_is_valid(wininfo.winid)
              then
                return
              end

              vim.api.nvim_win_set_config(wininfo.winid, { border = "rounded" })
              vim.wo[wininfo.winid].conceallevel = 2
              vim.wo[wininfo.winid].concealcursor = "niv"

              if not vim.api.nvim_buf_is_valid(wininfo.bufnr) then return end

              vim.bo[wininfo.bufnr].syntax = "markdown"
              vim.treesitter.start(wininfo.bufnr, "markdown")
            end,
            bufnr
          )
        end)
      )
    end,
  })
end

local M = {}

---@param opts table
M.setup = function(opts)
  local client = opts.client
  local bufnr = opts.bufnr
  vim.o.completeopt = 'fuzzy,menuone,popup,noinsert'

  ---Utility for keymap creation.
  ---@param lhs string
  ---@param rhs string|function
  ---@param key_opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, key_opts, mode)
    key_opts = type(key_opts) == 'string' and { desc = key_opts }
        or vim.tbl_extend('error', key_opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, key_opts)
  end

  -- Enable completion and configure keybindings.
  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- enable_completion_documentation(client, bufnr)

    -- Use enter to accept completions.
    keymap('<cr>', function()
      return pumvisible() and '<C-y>' or '<cr>'
    end, { expr = true }, 'i')

    -- Use esc to dismiss the completion menu.
    keymap('<esc>', function()
      return pumvisible() and '<C-e>' or '<esc>'
    end, { expr = true }, 'i')

    -- Use <C-n> to navigate to the next completion or:
    -- - Trigger LSP completion.
    -- - If there's no one, fallback to vanilla omnifunc.
    keymap('<C-n>', supertab, 'Trigger/select next completion', 'i')
    keymap('<Tab>', supertab, {}, { 'i', 's' })

    -- Buffer completions.
    keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')

    -- Do something similar with <S-Tab>.
    keymap('<S-Tab>', function()
      if pumvisible() then
        feedkeys '<C-p>'
      elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
      else
        feedkeys '<S-Tab>'
      end
    end, {}, { 'i', 's' })

    -- Inside a snippet, use backspace to remove the placeholder.
    keymap('<BS>', '<C-o>s', {}, 's')
  end
end

return M
