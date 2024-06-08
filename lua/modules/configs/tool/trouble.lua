return function()
	-- TODO: Trouble V3
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		diagnostics = require("modules.utils.icons").get("diagnostics"),
	}

	require("trouble").setup()
end
