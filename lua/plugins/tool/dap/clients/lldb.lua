-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
return function()
    local dap = require("dap")
    local utils = require("utils.dap")

    dap.adapters.lldb = {
        type = "executable",
        command = vim.fn.exepath("lldb-vscode"),
    }
    dap.configurations.c = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return utils.input_exec_path()
            end,
            cwd = "${workspaceFolder}",
            args = function()
                return utils.input_args()
            end,
            env = utils.get_env(),
            runInTerminal = false,
        },
    }

    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c
end
