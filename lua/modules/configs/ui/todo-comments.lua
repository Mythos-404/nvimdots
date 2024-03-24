return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		ui = require("modules.utils.icons").get("ui"),
	}
	require("todo-comments").setup({
		keywords = {
			FIX = { icon = icons.ui.Bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = icons.ui.Accepted, color = "info" },
			HACK = { icon = icons.ui.Fire, color = "warning" },
			WARN = { icon = icons.diagnostics.Warning, color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = icons.ui.Perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = icons.ui.Note, color = "hint", alt = { "INFO" } },
		},
		highlight = {
			multiline = false, -- enable multine todo comments
		},
	})
end
