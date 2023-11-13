return function()
	require("ultimate-autopair").setup({
		tabout = { -- *ultimate-autopair-map-tabout-config*
			enable = true,
			map = "<A-l>", --string or table
			cmap = "<A-l>", --string or table
			conf = {},
			--contains extension config
			multi = false,
			--use multiple configs (|ultimate-autopair-map-multi-config|)
			hopout = true,
			-- (|) > tabout > ()|
			do_nothing_if_fail = true,
			--add a module so that if close fails
			--then a `\t` will not be inserted
		},
	})
end
