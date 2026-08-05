-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
return function()
    local dap = require("dap")
    local utils = require("utils.dap")
    local is_windows = require("core.global").is_windows

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.exepath("codelldb"),
            args = { "--port", "${port}" },
            detached = is_windows and false or true,
        },
    }
    dap.configurations.c = {
        {
            name = "Debug",
            type = "codelldb",
            request = "launch",
            program = function()
                return utils.input_exec_path()
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            terminal = "integrated",
        },
        {
            name = "Debug (with args)",
            type = "codelldb",
            request = "launch",
            program = function()
                return utils.input_exec_path()
            end,
            args = function()
                return utils.input_args()
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            terminal = "integrated",
        },
        {
            name = "Attach to a running process",
            type = "codelldb",
            request = "attach",
            program = function()
                return utils.input_exec_path()
            end,
            stopOnEntry = false,
            waitFor = true,
        },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c
end
