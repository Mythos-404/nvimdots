-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
return function()
    local dap = require("dap")
    local utils = require("utils.dap")
    local is_windows = require("core.global").is_windows
    local tools = require("core.tools")

    dap.adapters.python = function(callback, config)
        if config.request == "attach" then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or "127.0.0.1"
            callback({
                type = "server",
                port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                host = host,
                options = { source_filetype = "python" },
            })
        else
            local command = tools.executable("debugpy-adapter", true)
            local args = {}
            if not command then
                if tools.use_mason() then
                    local root = require("mason.settings").current.install_root_dir .. "/packages/debugpy/venv"
                    command = tools.executable(root .. (is_windows and "/Scripts/python.exe" or "/bin/python"), true)
                else
                    -- Keep the adapter interpreter separate from the debuggee's virtualenv.
                    for _, name in ipairs({ "python3", "python" }) do
                        local python = tools.executable(name, true)
                        if python then
                            local result = vim.system({ python, "-c", "import debugpy.adapter" }, { text = true })
                                :wait(3000)
                            if result.code == 0 then
                                command = python
                                break
                            end
                        end
                    end
                end
                args = { "-m", "debugpy.adapter" }
            end
            if not command then
                tools.missing("debugpy-adapter (or Python with debugpy)")
                return
            end
            callback({
                type = "executable",
                command = command,
                args = args,
                options = { source_filetype = "python" },
            })
        end
    end
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Debug",
            console = "integratedTerminal",
            program = function()
                return utils.input_file_path()
            end,
            pythonPath = function()
                local venv = vim.env.CONDA_PREFIX
                if venv then
                    return is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python"
                else
                    return is_windows and "pythonw.exe" or "python3"
                end
            end,
        },
        {
            type = "python",
            request = "launch",
            name = "Debug (using venv)",
            console = "integratedTerminal",
            program = function()
                return utils.input_file_path()
            end,
            pythonPath = function()
                local cwd, venv = vim.fn.getcwd(), vim.env.VIRTUAL_ENV
                local python = venv and (is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python") or ""
                if vim.fn.executable(python) == 1 then return python end

                venv = vim.fn.isdirectory(cwd .. "/venv") == 1 and cwd .. "/venv" or cwd .. "/.venv"
                python = is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                else
                    return is_windows and "pythonw.exe" or "python3"
                end
            end,
        },
    }
end
