-- friendly-snippets is data only -- zsnip reads the JSON off the runtimepath
-- itself, under either completion engine. Wanted by both, so no `enabled`
-- guard: blink declares it as a dependency, and zpack ANDs `enabled` across
-- specs for the same source, then disables the parent -- guarding here would
-- take blink.cmp down with it.
return {
  {
    'rafamadriz/friendly-snippets',
    cond = not vim.g.vscode,
    lazy = false,
  },
  {
    -- Loading only: expansion is vim.snippet's, under both engines.
    'zuqini/zsnip.nvim',
    cond = not vim.g.vscode,
    lazy = false,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      -- Both engines read the registry themselves, through zsnip's own sources:
      -- zsnip.blink for blink, zsnip.complete for the builtin one.
      require('zsnip').setup()
      require('zsnip.loaders.from_vscode').lazy_load()
      require('zsnip.loaders.from_snipmate').lazy_load()
    end,
  },
}
