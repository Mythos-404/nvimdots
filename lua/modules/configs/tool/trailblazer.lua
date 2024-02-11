return function()
	require("trailblazer").setup({
		trail_mark_symbol_line_indicators_enabled = true,
		trail_options = {
			mark_symbol = "󰈿",
			newest_mark_symbol = "󰋲",
			cursor_mark_symbol = "󰻿",
			previous_mark_symbol = "",
			next_mark_symbol = "",
		},

		force_mappings = {
			n = {
				motions = {
					new_trail_mark = "<A-i>",
					track_back = "<A-b>",
					peek_move_next_down = "<A-C-k>",
					peek_move_previous_up = "<A-C-j>",
					move_to_nearest = "<A-n>",
					toggle_trail_mark_list = "<A-m>",
				},
				actions = {},
			},
		},
	})
end
