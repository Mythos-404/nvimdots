-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")
	local is_windows = require("core.global").is_windows

	local function get_exec_path()
		if vim.g.loaded_xmake then
			require("xmake.async").exec_commnd({ "xmake", "config", "--mode=debug" }, "")
			vim.cmd([[ XmakeBuild ]])
			return require("xmake.project").info.target.exec_path
		else
			return require("modules.utils.dap").input_exec_path()
		end
	end

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.exepath("codelldb"), -- Find codelldb on $PATH
			args = { "--port", "${port}" },
			detached = is_windows and false or true,
		},
	}
	dap.configurations.c = {
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			program = get_exec_path(),
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "integrated",
		},
		{
			name = "Debug (with args)",
			type = "codelldb",
			request = "launch",
			program = get_exec_path(),
			args = utils.input_args(),
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "integrated",
		},
		{
			name = "Attach to a running process",
			type = "codelldb",
			request = "attach",
			program = get_exec_path(),
			stopOnEntry = false,
			waitFor = true,
		},
	}
	dap.configurations.cpp = dap.configurations.c
	dap.configurations.rust = dap.configurations.c
end
