return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  denpenencies = {
    "nvim-treesitter-textobjects"
  },
  build = ':TSUpdate',
  config = function()
    local Set = require 'utils.set';

    require 'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all"
      ensure_installed = { 'regex' },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      -- List of parsers to ignore installing (for "all")
      ignore_install = {},

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable "help" which breaks :h formatting
        disable = function(lang, buf)
          -- First check languages that should be disabled
          -- local disabled_lang = Set.init { "help" }
          local disabled_lang = Set.init {}
          if disabled_lang[lang] then
            return true
          end

          -- Then check max file size
          if require('utils').is_large_file(buf) then
            return true
          end

          -- Then check line nbr
          -- return vim.api.nvim_buf_line_count(buf) > 50000
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "gnu",
          scope_incremental = "gnc",
          node_decremental = "gnd",
        },
      },
      textobjects = {
        select = {
          enable = false, -- use mini.ai
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]o"] = "@block.outer",
            ["]S"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
            ["]O"] = "@block.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[o"] = "@block.outer",
            ["[S"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[O"] = "@block.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          peek_definition_code = {
            ["<leader>gf"] = "@function.outer",
            ["<leader>gF"] = "@class.outer",
          },
        },
      },
    }
  end
}
