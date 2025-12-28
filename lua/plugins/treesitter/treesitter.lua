return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- zsh parser is not very good as of late 2025
    vim.treesitter.language.register('bash', { 'zsh' })

    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local treesitter = require('nvim-treesitter')
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.list_contains(treesitter.get_available(), lang) then
          if not vim.list_contains(treesitter.get_installed(), lang) then
            treesitter.install(lang):wait()
          end
          vim.treesitter.start(args.buf)
        end
      end,
      desc = "Enable nvim-treesitter and install parser if not installed"
    })
  end
}
