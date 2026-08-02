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
    'zuqini/ZSnip.nvim',
    cond = not vim.g.vscode,
    lazy = false,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      -- Both engines read the registry themselves: blink through the
      -- zsnip.blink source, the builtin one through cmp-sources, which dedupes
      -- against what the real servers already offered.
      require('zsnip').setup()
      require('zsnip.loaders.from_vscode').lazy_load()
      require('zsnip.loaders.from_snipmate').lazy_load()
    end,
  },
}
