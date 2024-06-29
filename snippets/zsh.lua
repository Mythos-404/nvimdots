---@diagnostic disable: undefined-global

return {
	s(
		{ trig = "#!", dscr = "shebang" },
		fmt([[#!/usr/bin/env zsh {}]], {
			c(1, {
				t("-o pipefail"),
				t("-vxo pipefail"),
			}),
		})
	),
}
