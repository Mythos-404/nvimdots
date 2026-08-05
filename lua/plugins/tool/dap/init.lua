local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback

return Plugin:new("mfussenegger/nvim-dap")
    :lazy(true)
    :cmd(
        "DapSetLogLevel",
        "DapShowLog",
        "DapContinue",
        "DapToggleBreakpoint",
        "DapToggleRepl",
        "DapStepOver",
        "DapStepInto",
        "DapStepOut",
        "DapTerminate"
    )
    :dep("jay-babu/mason-nvim-dap.nvim")
    :dep(Plugin:new("rcarriga/nvim-dap-ui")
        :dep("nvim-neotest/nvim-nio"))
    :dep("LiadOz/nvim-dap-repl-highlights")
    :dep("theHamsta/nvim-dap-virtual-text")
    :lazy_keys({
        ["n|<F5>"] = map_callback(function()
            require("dap").continue()
        end):with_desc("debug: Run/Continue"),
        ["n|<C-F5>"] = map_callback(function()
            require("dap").terminate()
        end):with_desc("debug: Stop"),
        ["n|<F6>"] = map_callback(function()
            require("dap").toggle_breakpoint()
        end):with_desc("debug: Toggle breakpoint"),
        ["n|<F7>"] = map_callback(function()
            require("dap").step_into()
        end):with_desc("debug: Step into"),
        ["n|<F8>"] = map_callback(function()
            require("dap").step_over()
        end):with_desc("debug: Step over"),
        ["n|<C-F8>"] = map_callback(function()
            require("dap").step_out()
        end):with_desc("debug: Step out"),
        ["n|<leader>db"] = map_callback(function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end):with_desc("debug: Set breakpoint with condition"),
        ["n|<leader>dc"] = map_callback(function()
            require("dap").run_to_cursor()
        end):with_desc("debug: Run to cursor"),
        ["n|<leader>dl"] = map_callback(function()
            require("dap").run_last()
        end):with_desc("debug: Run last"),
        ["n|<leader>do"] = map_callback(function()
            require("dap").repl.open()
        end):with_desc("debug: Open REPL"),
        ["n|<leader>dC"] = map_callback(function()
            require("dapui").close()
        end):with_desc("debug: Close debug UI"),
    })
    :config(function()
        require("plugins.tool.dap.setup")
    end)
