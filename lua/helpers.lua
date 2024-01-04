function _G.close_all_float()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win);
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false);
            print('Closing window', win);
        end
    end
end

-- Searching in all windows (including the current one) on the tab page:
function _G.leap_all_windows()
  require'leap'.leap {
    target_windows = vim.tbl_filter(
      function (win) return vim.api.nvim_win_get_config(win).focusable end,
      vim.api.nvim_tabpage_list_wins(0)
    )
  }
end

-- Bidirectional search in the current window is just a specific case of the
-- multi-window mode - set `target-windows` to a table containing the current
-- window as the only element:
function _G.leap_bidirectional()
  require'leap'.leap { target_windows = { vim.api.nvim_get_current_win() } }
end
