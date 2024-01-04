return {
  "chrisgrieser/nvim-various-textobjs",
  event = "VeryLazy",
  config = function()
    require("various-textobjs").setup({
      useDefaultKeymaps = true,
      disabledKeymaps = {
        "gc" -- conflicts with Comment.nvim
      },
    })

    vim.keymap.set({ "o", "x" }, "gm", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>") -- originally gc
  end,
}
