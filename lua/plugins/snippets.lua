-- Data only -- cmp-sources reads the JSON off the runtimepath directly, the
-- same way blink pulls it in through luasnip under the other engine.
return {
  'rafamadriz/friendly-snippets',
  enabled = vim.g.cmp_engine == 'builtin',
  cond = not vim.g.vscode,
  lazy = false,
}
