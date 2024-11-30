return {
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    enabled = false,
    config = function()
      require("various-textobjs").setup({
        useDefaultKeymaps = true,
        disabledKeymaps = {
          "gc" -- conflicts with Comment.nvim
        },
      })

      vim.keymap.set({ "o", "x" }, "gm", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>") -- originally gc
    end,
  },
  {
    'echasnovski/mini.ai',
    version = false,
    opts = {
      config = function()
        local ai = require('mini.ai')
        ai.setup({
          custom_textobjects = {
            s = { '%[%[().-()%]%]' },
          }
        })
      end,
    },
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    config = function()
      vim.g.miniindentscope_disable = true
      require('mini.indentscope').setup()
    end
  },
}
