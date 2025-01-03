local map = function(mode, mapping, rhs, desc)
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
end

--- Retrieves the topmost tree-sitter node under the current cursor position.
-- The top node is determined by traversing the AST (abstract syntax tree) upwards
-- from the node under the cursor position, stopping at the first ancestor node
-- which does not begin at the same position as its own parent. This recursion
-- is limited by a predefined maximum depth.
--
-- @return top_node, row, col
--   - `top_node`: the topmost tree-sitter Node, or `nil` if no node is found.
--   - `row`: the starting row index of the top node.
--   - `col`: the starting column index of the top node.
local function get_current_top_node()
  local function search_parent(node, depth)
    -- Stop recursion if node is nil or max depth is reached
    if not node or depth <= 0 then
      return node
    end

    local parent = node:parent()

    if not parent then
      return node
    end

    local start_row, start_col = node:range()
    local parent_start_row, parent_start_col = parent:range()

    -- If the node does not start at the same position as its parent, return the node
    if start_row ~= parent_start_row or start_col ~= parent_start_col then
        return node
    end

    -- If it does start at the same position, recurse with reduced depth
    return search_parent(parent, depth - 1)
  end

  local node = vim.treesitter.get_node()

  if not node then
    return nil
  end

  local top_node =  search_parent(node, 100)

  local row, col = top_node:range()
  return top_node, row, col
end

return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  config = function()
    local Set = require 'utils.set';
    local ts_utils = require 'nvim-treesitter.ts_utils'

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
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aF"] = "@function.outer",
            ["iF"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]["] = "@function.outer",
            ["]l"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]]"] = "@function.outer",
            ["]L"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@function.outer",
            ["[l"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@function.outer",
            ["[L"] = "@class.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          peek_definition_code = {
            ["<leader>gp"] = "@function.outer",
            ["<leader>gP"] = "@class.outer",
          },
        },
      },
    }

    local function swap_prev()
      local node = get_current_top_node()
      if not node then
        return
      end

      local prev_node = node:prev_named_sibling()
      if prev_node then
        ts_utils.swap_nodes(node, prev_node, 0, true)
      end
    end

    local function swap_next()
      local node = get_current_top_node()
      if not node then
        return
      end

      local next_node = node:next_named_sibling()
      if next_node then
        ts_utils.swap_nodes(node, next_node, 0, true)
      end
    end

    map('n', '<leader>tp', function() swap_prev() end, 'Swap Prev')
    map('n', '<leader>tn', function() swap_next() end, 'Swap Next')
  end
}
