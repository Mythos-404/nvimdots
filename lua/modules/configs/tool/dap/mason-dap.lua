local M = {}

function M.setup()
	local mason_dap = require("mason-nvim-dap")

	---A handler to setup all clients defined under `tool/dap/clients/*.lua`
	---@param config table
	local function mason_dap_handler(config)
		local dap_name = config.name
		local ok, custom_handler = pcall(require, "tool.dap.clients." .. dap_name)
		if not ok then
			-- Default to use factory config for clients(s) that doesn't include a spec
			mason_dap.default_setup(config)
			return
		elseif type(custom_handler) == "function" then
			-- Case where the protocol requires its own setup
			-- Make sure to set
			-- * dap.adpaters.<dap_name> = { your config }
			-- * dap.configurations.<lang> = { your config }
			-- See `codelldb.lua` for a concrete example.
			custom_handler(config)
		else
			vim.notify(
				("Failed to setup [%s].\n\nClient definition under `tool/dap/clients` must return\na fun(opts) (got '%s' instead)"):format(
					config.name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-dap" }
			)
		end
	end

	mason_dap.setup({
		ensure_installed = require("core.settings").dap_deps,
		automatic_installation = true,
		handlers = { mason_dap_handler },
	})
end

return M
