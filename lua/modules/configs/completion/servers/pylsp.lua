-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/pylsp.lua
return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	settings = {
		pylsp = {
			plugins = {
				-- Lint
				ruff = {
					enabled = true,
					select = {
						-- enable pycodestyle
						"E",
						-- enable pyflakes
						"F",
					},
					ignore = {},
					extendSelect = { "I" },
					severities = {
						-- Hint, Information, Warning, Error
						F401 = "I",
						E501 = "I",
						F841 = "H",
					},

					format = { "I" },
					formatEnabled = true,
					preview = false,
					lineLength = 120,
					linelength = 120,
				},
				flake8 = { enabled = false },
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
				mccabe = { enabled = false },

				-- Code refactor
				rope = { enabled = true },

				-- Formatting
				black = { enabled = false, preview = false },
				pyls_isort = { enabled = false },
				autopep8 = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}
