-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
return function()
    local dap = require("dap")
    local utils = require("utils.dap")
    local is_windows = require("core.global").is_windows

    dap.adapters.codelldb = function(callback)
        local command = require("core.tools").executable("codelldb")
        if not command then return end
        callback({
            type = "server",
            port = "${port}",
            executable = {
                command = command,
                args = { "--port", "${port}" },
                detached = not is_windows,
            },
        })
    end
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
