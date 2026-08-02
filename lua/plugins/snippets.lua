-- Data only -- cmp-sources reads the JSON off the runtimepath directly, the
-- same way blink pulls it in through luasnip under the other engine. Wanted by
-- both engines, so no `enabled` guard: blink declares it as a dependency, and
-- zpack ANDs `enabled` across specs for the same source, then disables the
-- parent -- guarding here would take blink.cmp down with it.
return {
  'rafamadriz/friendly-snippets',
  cond = not vim.g.vscode,
  lazy = false,
}
