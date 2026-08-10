local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback

local icons = {
    ui = require("utils.icons").get("ui"),
    dap = require("utils.icons").get("dap"),
}

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
        :dep("nvim-neotest/nvim-nio")
        :opts({
            force_buffers = true,
            icons = {
                expanded = icons.ui.ArrowOpen,
                collapsed = icons.ui.ArrowClosed,
                current_frame = icons.ui.Indicator,
            },
            mappings = {
                edit = "e",
                expand = { "<Tab>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t",
            },
            layouts = {
                {
                    elements = {
                        { id = "scopes",      size = 0.3 },
                        { id = "watches",     size = 0.3 },
                        { id = "stacks",      size = 0.3 },
                        { id = "breakpoints", size = 0.1 },
                    },
                    size = 0.34,
                    position = "right",
                },
                {
                    elements = {
                        { id = "repl",    size = 0.55 },
                        { id = "console", size = 0.45 },
                    },
                    position = "bottom",
                    size = 0.25,
                },
            },
            controls = {
                enabled = true,
                element = "repl",
                icons = {
                    pause = icons.dap.Pause,
                    play = icons.dap.Play,
                    step_into = icons.dap.StepInto,
                    step_over = icons.dap.StepOver,
                    step_out = icons.dap.StepOut,
                    step_back = icons.dap.StepBack,
                    run_last = icons.dap.RunLast,
                    terminate = icons.dap.Terminate,
                },
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            render = { indent = 1, max_value_lines = 85 },
        }))
    :dep("LiadOz/nvim-dap-repl-highlights")
    :dep(Plugin:new("theHamsta/nvim-dap-virtual-text")
        :opts({
            display_callback = function(variable, _, _, _, _)
                return " " .. variable.value
            end,
        }))
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
        require("plugins.tool.dap.config")
    end)
