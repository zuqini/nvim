return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  config = function()
    local nmap = function(mapping, rhs, desc)
      vim.keymap.set('n', mapping, rhs, { desc = desc, noremap = true })
    end
    local dap = require("dap")
    local ui = require("dapui")

    ui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.adapters.codelldb = {
      type = 'server',
      host = '127.0.0.1',
      port = 13000 -- 💀 Use the port printed out or specified with `--port`
    }

    nmap("<space>gb", dap.toggle_breakpoint, "Toggle breakpoint")
    nmap("<space>gB", dap.run_to_cursor, "Run to Cursor")
    vim.api.nvim_create_user_command('D', "lua require('dapui').toggle()<CR>", { bang = true })

    -- Eval var under cursor
    nmap("<space>?", function()
      require("dapui").eval(nil, { enter = true })
    end, "Eval Var under Cursor")
    nmap("<F1>", dap.continue, "Continue")
    nmap("<F2>", dap.step_into, "Step Into")
    nmap("<F3>", dap.step_over, "Step Over")
    nmap("<F4>", dap.step_out, "Step Out")
    nmap("<F5>", dap.step_back, "Step Back")
    nmap("<F13>", dap.restart, "Restart DAP")

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end
}
