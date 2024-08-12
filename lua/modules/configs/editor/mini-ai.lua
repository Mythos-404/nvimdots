return function()
	local mini_ai = require("mini.ai")
	local gen_spec = mini_ai.gen_spec
	local extra_ai_gen_spec = require("mini.extra").gen_ai_spec

	require("mini.ai").setup({
		-- Table with textobject id as fields, textobject specification as values.
		-- Also use this to disable builtin textobjects. See |MiniAi.config|.
		custom_textobjects = {
			x = { " %w+=[\"']().-()[\"']" },
			I = extra_ai_gen_spec.indent(),
			D = extra_ai_gen_spec.diagnostic(),

			f = gen_spec.function_call({ name_pattern = "[%w_]" }),
			F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			o = gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}, {}),
			C = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
		},

		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Main textobject prefixes
			around = "a",
			inside = "i",

			-- Next/last variants
			around_next = "an",
			inside_next = "in",
			around_last = "al",
			inside_last = "il",

			-- Move cursor to corresponding edge of `a` textobject
			goto_left = "g]",
			goto_right = "g[",
		},

		-- Number of lines within which textobject is searched
		n_lines = 500,

		-- How to search for object (first inside current line, then inside
		-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
		-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
		search_method = "cover_or_nearest",

		-- Whether to disable showing non-error feedback
		silent = true,
	})
end
