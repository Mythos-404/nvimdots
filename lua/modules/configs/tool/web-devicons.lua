return function()
	local devicons = require("nvim-web-devicons")
	local icons = devicons.get_icons()
	devicons.setup({
		override_by_extension = {
			["scm"] = icons["query"],
			["ss"] = icons["scm"],
		},
	})
end
