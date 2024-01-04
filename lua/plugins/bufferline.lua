return {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = "v3.*",
    event = 'VeryLazy',
    config = function ()
      require('bufferline').setup({
        options = {
          separator_style = 'slant',
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          groups = {
            items = {
                require('bufferline.groups').builtin.pinned:with({ icon = "" })
            }
          }
        },
      })

      local bufopts = { noremap = true, silent = true }
      vim.keymap.set('n', '<bs>1', function () require("bufferline").go_to_buffer(1, false) end, bufopts)
      vim.keymap.set('n', '<bs>2', function () require("bufferline").go_to_buffer(2, false) end, bufopts)
      vim.keymap.set('n', '<bs>3', function () require("bufferline").go_to_buffer(3, false) end, bufopts)
      vim.keymap.set('n', '<bs>4', function () require("bufferline").go_to_buffer(4, false) end, bufopts)
      vim.keymap.set('n', '<bs>5', function () require("bufferline").go_to_buffer(5, false) end, bufopts)
      vim.keymap.set('n', '<bs>6', function () require("bufferline").go_to_buffer(6, false) end, bufopts)
      vim.keymap.set('n', '<bs>7', function () require("bufferline").go_to_buffer(7, false) end, bufopts)
      vim.keymap.set('n', '<bs>8', function () require("bufferline").go_to_buffer(8, false) end, bufopts)
      vim.keymap.set('n', '<bs>9', function () require("bufferline").go_to_buffer(9, false) end, bufopts)
      vim.keymap.set('n', '<bs>$', function () require("bufferline").go_to_buffer(-1, false) end, bufopts)
      vim.keymap.set('n', '<bs>p', ':BufferLineTogglePin<CR>', bufopts)
      vim.keymap.set('n', ']b', ':BufferLineCycleNext<CR>', bufopts)
      vim.keymap.set('n', '[b', ':BufferLineCyclePrev<CR>', bufopts)
    end,
}
