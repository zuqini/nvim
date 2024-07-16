return {
  'folke/which-key.nvim',
  config = function ()
    local wk = require("which-key")
    wk.setup({
      layout = {
        height = { min = 4, max = 15 }, -- min and max height of the columns
        width = { min = 20, max = 35 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
    })
    -- vim.opt.timeoutlen = 500

    vim.api.nvim_set_keymap('n', '<leader><leader>', '<Cmd>WhichKey<CR>', { noremap = true, silent = true })

    wk.add({
      { "!", hidden = true },

      { "<leader>C", desc = "Clipboard Y" },
      { "<leader>P", desc = "Last Yanked P" },
      { "<leader>R", desc = "Read :cmd" },
      { "<leader>V", desc = "Clipboard P" },
      { "<leader>W", desc = "Save & Quit" },
      { "<leader>X", desc = "Clipboard D" },
      { "<leader>Y", desc = "Clipboard Y" },
      { "<leader>c", desc = "Clipboard y" },
      { "<leader>gH", desc = "Open GH repo" },
      { "<leader>gh", desc = "Open GH file" },
      { "<leader>j", desc = "Quickfix Next" },
      { "<leader>k", desc = "Quickfix Prev" },
      { "<leader>p", desc = "Last Yanked p" },
      { "<leader>u", desc = "UndoTree" },
      { "<leader>v", desc = "Clipboard p" },
      { "<leader>w", desc = "Save" },
      { "<leader>x", desc = "Clipboard d" },
      { "<leader>y", desc = "Clipboard y" },
      { "<leader>z", desc = "Auto Center" },

      { "<BS>B", desc = "Del All Others" },
      { "<BS>Q", desc = "Quit! Cur" },
      { "<BS>b", desc = "Del Buf" },
      { "<BS>q", desc = "Quit Cur" },

      { "[b", desc = "Prev Buffer" },
      { "]b", desc = "Next Buffer" },
      { "s", desc = "Search (Leap)" },
    })

    local reg = require("which-key.plugins.registers")
    reg.registers = '0123456789*+"-:.%/#=_abcdefghijklmnopqrstuvwxyz'

  end
}
