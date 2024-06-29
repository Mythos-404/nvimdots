---@diagnostic disable: undefined-global

return {
	s(
		{ trig = "#!", dscr = "shebang" },
		fmt([[#!/usr/bin/env bash {}]], {
			c(1, {
				t("-eo pipefail"),
				t("-evxo pipefail"),
			}),
		})
	),
}
