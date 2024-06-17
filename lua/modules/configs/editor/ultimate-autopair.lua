return function()
	require("ultimate-autopair").init({
		require("ultimate-autopair").extend_default({
			tabout = {
				enable = true,
				hopout = true,
			},
		}),
		{ profile = require("ultimate-autopair.experimental.cmpair").init },
	})
end
