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

-- https://github.com/neovim/neovim/pull/32820
local function enable_completion_documentation()
  vim.api.nvim_create_autocmd("CompleteChanged", {
    callback = function()
      local event = vim.v.event
      if not event or not event.completed_item then return end

      local cy = event.row
      local cx = event.col
      local cw = event.width
      local ch = event.height

      local item = event.completed_item
      local lsp_item = item.user_data and item.user_data.nvim and item.user_data.nvim.lsp.completion_item
      local client = vim.lsp.get_clients({ bufnr = 0 })[1]

      if not client or not lsp_item then return end

      client:request('completionItem/resolve', lsp_item, function(_, result)
        vim.cmd("pclose")

        if result and result.documentation then
          local docs = result.documentation.value or result.documentation
          if type(docs) == "table" then docs = table.concat(docs, "\n") end
          if not docs or docs == "" then return end

          local buf = vim.api.nvim_create_buf(false, true)
          vim.bo[buf].bufhidden = 'wipe'

          local contents = vim.lsp.util.convert_input_to_markdown_lines(docs)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
          vim.treesitter.start(buf, "markdown")

          local dx = cx + cw + 1
          local dw = 60
          local anchor = "NW"

          if dx + dw > vim.o.columns then
            dw = vim.o.columns - dx
            anchor = "NE"
          end

          local win = vim.api.nvim_open_win(buf, false, {
            relative = "editor",
            row = cy,
            col = dx,
            width = dw,
            height = ch,
            anchor = anchor,
            border = "none",
            style = "minimal",
            zindex = 60,
          })

          vim.wo[win].conceallevel = 2
          vim.wo[win].wrap = true
          vim.wo[win].previewwindow = true
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
      vim.cmd("pclose")
    end
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
    -- Trigger completion on any character
    local chars = {}
    for i = 32, 126 do
      table.insert(chars, string.char(i))
    end
    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    enable_completion_documentation()

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
