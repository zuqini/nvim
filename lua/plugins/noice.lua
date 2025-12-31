return {
  {
    "folke/noice.nvim",
    cond = not vim.g.vscode,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      notify = { enabled = false },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "vim.pack", -- otherwise vim.pack messages get filtered for some reason
          },
          view = "mini",
        },
      },
      views = {
        mini = {
          align = "message-left",
          position = {
            col = 0,
          },
          win_options = {
            wrap = true,
          },
        },
        cmdline = {
          win_options = {
            winblend = 0,
          },
        },
      },
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { pattern = "^:", icon = " :", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "  /", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "  ?", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "󰘧 :!", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " :", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = " :" },
          inc_rename = { pattern = "^:%s*IncRename%s+", icon = " :" },
          input = { view = "cmdline_input", icon = "󰥻 :" }, -- Used by input()
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        -- signature handled by blink.cmp
        signature = {
          enabled = false,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = false,      -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      local map = function(mapping, rhs, desc)
        vim.keymap.set({ 'n', 'i', 's' }, mapping, rhs, { desc = desc, noremap = true })
      end
      require('noice').setup(opts)
      map("<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, "Scroll Signature Help Forward")
      map("<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, "Scroll Signature Help Back")
    end
  },
}
