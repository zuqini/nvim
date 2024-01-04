return {
  'ggandor/leap.nvim', -- breaking changes: https://github.com/ggandor/leap.nvim/issues/18
  enabled = false,
  keys = {
    { "s", mode = { "x", "v", "n" } },
  },
  config = function()
    require('leap').setup {
      highlight_unlabeled_phase_one_targets = true,
    }

    -- Searching in all windows (including the current one) on the tab page.
    local leap_all_windows = function()
      require('leap').leap { target_windows = vim.tbl_filter(
        function(win) return vim.api.nvim_win_get_config(win).focusable end,
        vim.api.nvim_tabpage_list_wins(0)
      ) }
    end

    -- leap_all_windows defined in helpers.lua and used nvim-tree.lua
    vim.keymap.set('x', 's', leap_all_windows, { silent = true })
    vim.keymap.set('v', 's', leap_all_windows, { silent = true })
    vim.keymap.set('n', 's', leap_all_windows, { silent = true })

    -- custom highlights
    -- local function leap_highlight()
    --   vim.api.nvim_set_hl(0, 'LeapMatch', { fg = "#ccff88", ctermfg = "red", underline = true })
    --   vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg = "black", bg = "#ff8877", ctermfg = "black", ctermbg = "red" })
    --   vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg = "black", bg = "#99ccff", ctermfg = "black", ctermbg = "blue" })
    -- end

    -- leap_highlight()
    -- vim.api.nvim_create_autocmd("ColorScheme", {
    --   pattern = "*",
    --   callback = leap_highlight,
    -- })
  end
}
