return function()
	require("ultimate-autopair").init({
		require("ultimate-autopair").extend_default({
			tabout = {
				enable = true,
				hopout = true,
			},

			{ "[=[", "]=]", ft = { "lua" } },
		}),
	})
end
