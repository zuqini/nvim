return {
  'hiphish/rainbow-delimiters.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  main = 'rainbow-delimiters.setup',
  opts = {
    -- Neovim 0.11+ returns nil from vim.treesitter.get_parser() instead of
    -- throwing; rainbow-delimiters doesn't guard against this, crashing on
    -- scratch buffers (e.g. noice/nui popups) that lack a treesitter parser.
    condition = function(bufnr)
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      return ok and parser ~= nil
    end,
  },
}
