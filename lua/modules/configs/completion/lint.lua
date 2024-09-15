return function()
	local lint = require("lint")

	vim.filetype.add({
		pattern = {
			[".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
			[".*/.github/workflows/.*%.yaml"] = "yaml.ghaction",
		},
	})

	lint.linters_by_ft = {
		ghaction = { "actionlint" },

		sh = { "shellcheck" },
		bash = { "shellcheck" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			lint.try_lint()
		end,
	})
end
