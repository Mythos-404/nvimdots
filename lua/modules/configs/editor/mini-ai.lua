return function()
	local mini_ai = require("mini.ai")
	local gen_spec = mini_ai.gen_spec
	local spec_treesitter = gen_spec.treesitter
	require("mini.ai").setup({
		-- Table with textobject id as fields, textobject specification as values.
		-- Also use this to disable builtin textobjects. See |MiniAi.config|.
		custom_textobjects = {
			q = { "[`'\"]().-()[`'\"]" },
			x = { " %w+=[\"']().-()[\"']" },
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
			g = function() -- Whole buffer, similar to `gg` and 'G' motion
				local from = { line = 1, col = 1 }
				local to = {
					line = vim.fn.line("$"),
					col = math.max(vim.fn.getline("$"):len(), 1),
				}
				return { from = from, to = to }
			end,
			-- Tweak function call to not detect dot in function name
			f = gen_spec.function_call({ name_pattern = "[%w_]" }),
			F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
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
		search_method = "cover_or_next",

		-- Whether to disable showing non-error feedback
		silent = false,
	})
end
