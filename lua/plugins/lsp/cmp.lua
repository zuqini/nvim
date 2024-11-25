local luasnip = require('luasnip')
luasnip.setup({
  -- see: https://www.reddit.com/r/neovim/comments/12z0orb/unexpected_behavior_when_pressing_tab_in_insert/
  history = true,
  region_check_events = "InsertEnter",
  delete_check_events = "TextChanged,InsertLeave",
})

luasnip.add_snippets('lua', {
  luasnip.snippet("test_choice_node", luasnip.choice_node(1, {
    luasnip.text_node("1. text node"),
    luasnip.insert_node(nil, "2. insert node"),
    luasnip.function_node(function(_) return "3. function node" end, {})
  }))
})

require('luasnip.loaders.from_vscode').lazy_load()

-- Previous snippet region
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if luasnip.jumpable(-1) then luasnip.jump(-1) end
end, { silent = true })

-- Next snippet region
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if luasnip.jumpable(1) then luasnip.jump(1) end
end, { silent = true })

-- Cycle "choices" for current snippet region
vim.keymap.set({ "i", "s" }, "<c-e>", function()
  if luasnip.choice_active() then luasnip.change_choice(1) end
end)

-- nvim-cmp setup
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
cmp.setup {
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  view = {
    docs = {
      auto_open = true,
    },
    entries = { name = 'custom', selection_order = 'near_cursor' }
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = entry.source.name
      return vim_item
    end,
  }, -- formatting
  mapping = cmp.mapping.preset.insert({
    ['<up>'] = cmp.mapping.select_prev_item(),
    ['<down>'] = cmp.mapping.select_next_item(),
    ['<C-l>'] = function()
      -- close docs if it's blocking completion list
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm {
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    {
      name = "lazydev",
      group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    }
  }, {
    { name = 'buffer' },
  })
}

-- local feedkeys = require('cmp.utils.feedkeys')
-- local keymap = require('cmp.utils.keymap')
local cmdline_mapping = {
  ['<c-l>'] = {
    c = cmp.mapping.abort(),
  },
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(cmdline_mapping),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  -- <C-y> to confirm without selecting
  mapping = cmp.mapping.preset.cmdline(cmdline_mapping),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
