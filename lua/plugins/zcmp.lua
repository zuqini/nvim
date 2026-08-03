-- Neovim's own completion under 'autocomplete' (see |ins-autocompletion|): a
-- path source, zsnip's snippets, core's buffer scanners and the LSP omnifunc,
-- fuzzy-ranked into one menu. Selected with vim.g.cmp_engine = 'zcmp'.
--
-- zsnip is not declared as a dependency on purpose: it is already an eager
-- spec in snippets.lua, and a dependency under an `enabled` guard is what took
-- blink.cmp down in 459efc3. Nothing here needs it loaded first -- the source
-- is required at the first buffer attach, which is scheduled.
return {
  {
    'zuqini/zcmp.nvim',
    enabled = vim.g.cmp_engine == 'zcmp',
    cond = not vim.g.vscode,

    config = function()
      ---@module 'zcmp'
      ---@type zcmp.Config
      local opts = {
        -- Order is the time-slicing priority. 'lsp' last: it is the omnifunc,
        -- and the three ahead of it answer without leaving the process.
        sources = { default = { 'path', 'snippets', 'buffer', 'lsp' } },

        keymap = {
          -- 'enter' gives <CR> = accept and <C-e>/<C-y>/<C-b>/<C-f>; the rest
          -- is the supertab behaviour blink was configured for.
          preset = 'enter',
          ['<Tab>'] = { 'select_next', 'snippet_forward', 'show_on_keyword', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          ['<C-n>'] = { 'select_next', 'snippet_forward', 'fallback' },
          -- <C-e> cancels the menu and *stays* in insert mode. The cost is that
          -- <esc> no longer leaves insert mode while a menu is open; that takes
          -- a second one.
          ['<Esc>'] = { 'hide', 'fallback' },
          -- Inside a snippet, backspace removes the placeholder.
          ['<BS>'] = { 'snippet_delete', 'fallback' },
        },
      }
      require('zcmp').setup(opts)
    end,
  },
}
