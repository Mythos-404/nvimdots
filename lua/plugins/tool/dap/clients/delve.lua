-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go
return function()
    local dap = require("dap")
    local utils = require("utils.dap")

    dap.adapters.go = function(callback)
        local command = require("core.tools").executable("dlv")
        if not command then return end
        callback({
            type = "server",
            port = "${port}",
            executable = {
                command = command,
                args = { "dap", "-l", "127.0.0.1:${port}" },
                detached = not require("core.global").is_windows,
            },
        })
    end
    -- VS Code's Go launch configurations use "go"; Mason also exposes "delve".
    dap.adapters.delve = dap.adapters.go
    dap.configurations.go = {
        {
            type = "go",
            name = "Debug (file)",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = function()
                return utils.input_file_path()
            end,
            console = "integratedTerminal",
            showLog = true,
            showRegisters = true,
            stopOnEntry = false,
        },
        {
            type = "go",
            name = "Debug (file with args)",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = function()
                return utils.input_file_path()
            end,
            args = function()
                return utils.input_args()
            end,
            console = "integratedTerminal",
            showLog = true,
            showRegisters = true,
            stopOnEntry = false,
        },
        {
            type = "go",
            name = "Debug (executable)",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = function()
                return utils.input_exec_path()
            end,
            args = function()
                return utils.input_args()
            end,
            console = "integratedTerminal",
            mode = "exec",
            showLog = true,
            showRegisters = true,
            stopOnEntry = false,
        },
        {
            type = "go",
            name = "Debug (test file)",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = function()
                return utils.input_file_path()
            end,
            console = "integratedTerminal",
            mode = "test",
            showLog = true,
            showRegisters = true,
            stopOnEntry = false,
        },
        {
            type = "go",
            name = "Debug (using go.mod)",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = "./${relativeFileDirname}",
            console = "integratedTerminal",
            mode = "test",
            showLog = true,
            showRegisters = true,
            stopOnEntry = false,
        },
    }
end
