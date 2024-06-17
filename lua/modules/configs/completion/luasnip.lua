return function()
	local snippet_path = vim.fn.stdpath("config") .. "/snips/"
	if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
		vim.opt.rtp:append(snippet_path)
	end

	local types = require("luasnip.util.types")
	require("luasnip").config.set_config({
		history = true,
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
		store_selection_keys = "<Tab>",
		-- Display a cursor-like placeholder in unvisited nodes
		-- of the snippet.
		ext_opts = {
			[types.insertNode] = {
				unvisited = {
					virt_text = { { "|", "Conceal" } },
					virt_text_pos = "inline",
				},
			},
			-- This is needed because LuaSnip differentiates between $0 and other
			-- placeholders (exitNode and insertNode). So this will highlight the last
			-- jump node.
			[types.exitNode] = {
				unvisited = {
					virt_text = { { "|", "Conceal" } },
					virt_text_pos = "inline",
				},
			},
		},
	})
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
end
