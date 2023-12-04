-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
return {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		local nvim_workspace = path:find("nvim")

		if nvim_workspace then
			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				diagnostics = {
					globals = { "vim" },
					disable = { "different-requires" },
				},
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					pathStrict = true,
				},
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					},
					ignoreDir = { "types/stable" },
				},
			})
		end
		return true
	end,
	settings = {
		Lua = {
			workspace = {
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
			format = { enable = false },
			telemetry = { enable = false },
			-- Do not override treesitter lua highlighting with lua_ls's highlighting
			semantic = { enable = false },
		},
	},
}
