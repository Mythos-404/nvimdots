return function()
	require("mini.surround").setup({
		custom_surroundings = {
			["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
			[")"] = { input = { "%b()", "^.%s*().-()%s*.$" }, output = { left = "( ", right = " )" } },
			["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
			["]"] = { input = { "%b[]", "^.%s*().-()%s*.$" }, output = { left = "[ ", right = " ]" } },
			["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
			["}"] = { input = { "%b{}", "^.%s*().-()%s*.$" }, output = { left = "{ ", right = " }" } },
			[">"] = { input = { "%b<>", "^.%s*().-()%s*.$" }, output = { left = "< ", right = " >" } },
			["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
		},
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			add = "ya", -- Add surrounding in Normal and Visual modes
			delete = "yd", -- Delete surrounding
			find = "", -- Find surrounding (to the right)
			find_left = "", -- Find surrounding (to the left)
			highlight = "", -- Highlight surrounding
			replace = "yr", -- Replace surrounding
			update_n_lines = "", -- Update `n_lines`

			suffix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},
	})
end
