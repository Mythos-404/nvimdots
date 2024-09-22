return function()
	local types = require("luasnip.util.types")
	require("luasnip").config.set_config({
		history = true,
		enable_autosnippets = true,
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
		store_selection_keys = "<Tab>",

		ext_opts = {
			[types.insertNode] = {
				unvisited = {
					virt_text = { { "|", "Conceal" } },
					virt_text_pos = "inline",
				},
			},
			[types.exitNode] = {
				unvisited = {
					virt_text = { { "|", "Conceal" } },
					virt_text_pos = "inline",
				},
			},
			[types.choiceNode] = {
				active = {
					virt_text = { { "●", "GruvboxOrange" } },
					priority = 0,
				},
			},
		},

		snip_env = {
			tsp = require("luasnip.extras.treesitter_postfix").treesitter_postfix,
			dl = require("luasnip.extras").dynamic_lambda,
		},
	})

	local ls_path_config = {
		paths = "./snippets",
		fs_event_providers = {
			autocmd = true,
			libuv = true,
		},
	}
	require("luasnip.loaders.from_lua").lazy_load(ls_path_config)
	require("luasnip.loaders.from_snipmate").lazy_load(ls_path_config)
end
