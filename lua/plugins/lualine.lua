return {
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    config = function()
      local theme = require('utils.theme').get_current_lualine_theme()

      local no_seps = { left = '', right = '' }
      local winbar_no_seps = { left = ' ' } -- need to add an extra space, or else the component would take up the whole bar

      local angle_down_seps = { left = '', right = '' }
      local angle_up_seps = { left = '', right = '' }
      local triangle_seps = { left = '', right = '' }
      local circle_seps = { left = '', right = '' }

      local angle_down_thin_seps = { left = '\\', right = '/' }
      local angle_up_thin_seps = { left = '/', right = '\\' }
      local angle_down_thin2_seps = { left = '', right = '' }
      local angle_up_thin2_seps = { left = '', right = '' }
      local triangle_thin_seps = { left = '', right = '' }
      local circle_thin_seps = { left = '', right = '' }

      local symbols = { error = "󰅚  ", warn = "󰀪  ", hint = "󰌶 ", info = "󰋽  " }
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.HINT] = '󰌶',
            [vim.diagnostic.severity.INFO] = '󰋽',
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
        }
      })

      local winbar_file_info = {
        {
          'filetype',
          icon_only = true,
          padding = { left = 1, right = 0 },
          -- component_separators = no_seps,
          -- section_separators = angle_up_seps,
          section_separators = winbar_no_seps,
        },
        {
          'filename',
          file_status = true,
          path = 0,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '[]',
          },
          separator = '',
        },
      };

      local sections = {
        lualine_a = {
          {
            'mode',
            fmt = string.upper,
          }
        },
        lualine_b = {
          {
            'branch',
            icon = '',
            separator = ':'
          },
          { 'diff' },
        },
        lualine_c = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic', },

            sections = { 'error', 'warn', 'info', 'hint' },

            symbols = symbols,
            colored = true,           -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false,   -- Show diagnostics even if there are none.
          },
          -- {
          --   require("noice").api.status.mode.get,
          --   cond = require("noice").api.status.mode.has,
          --   color = { fg = "#ff9e64" },
          -- },
        },
        lualine_x = {
          -- {
          --   require("noice").api.status.command.get,
          --   cond = require("noice").api.status.command.has,
          --   color = { fg = "#ff9e64" },
          -- },
          {
            'filetype',
            icon = { align = 'right' }, -- Display filetype icon on the right hand side
            padding = { left = 1, right = 1 },
            separator = '·',
          },
          {
            'fileformat',
            symbols = {
              -- unix = '  ',
              unix = ' 󰀶 ',
              dos = '󰨡 ',
              mac = '󰀶 ',
            },
            separator = '·',
          },
          {
            'encoding',
            separator = '·',
          },
          {
            'filesize',
            separator = '·',
          },
        },
        lualine_y = {
          { 'progress' },
        },
        lualine_z = {
          { 'location' },
        },
      }

      require('lualine').setup {
        options = {
          theme = theme,
          -- component_separators = angle_down_thin2_seps,
          -- section_separators = angle_down_seps,
          component_separators = no_seps,
          section_separators = no_seps,
          icons_enabled = true,
          globalstatus = true,

          -- Uncomment to disable icons
          -- icons_enabled = false,

          disabled_filetypes = {
            statusline = {
              "dap-repl",
              "dapui_breakpoints",
              "dapui_console",
              "dapui_scopes",
              "dapui_watches",
              "dapui_stacks",
              "snacks_dashboard",
            },
            winbar = {
              "dap-repl",
              "dapui_breakpoints",
              "dapui_console",
              "dapui_scopes",
              "dapui_watches",
              "dapui_stacks",
              "snacks_dashboard",
            },
          },
        },
        tabline = {
          lualine_a = {
            {
              'tabs',
              mode = 0,
              show_modified_status = false,
              -- section_separators = angle_down_seps,
            },
          },
          lualine_z = {
            {
              'filetype',
              colored = false,
              icon_only = true,
              padding = { left = 1, right = 0 },
              -- component_separators = no_seps,
              -- section_separators = angle_down_seps,
            },
            {
              'filename',
              file_status = true,
              path = 1,
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[]',
              },
              separator = '',
            },
          },
        },
        winbar = {
          lualine_b = winbar_file_info
        },
        inactive_winbar = {
          lualine_c = winbar_file_info,
        },
        sections = sections,
        -- extensions = { 'fzf' },
      }
      -- vim.cmd("set showtabline=1") --https://github.com/nvim-lualine/lualine.nvim/issues/395
    end
  }
}
