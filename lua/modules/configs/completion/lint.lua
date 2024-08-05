return function()
	local lint = require("lint")

	lint.linters_by_ft = {
		yaml = { "actionlint" },

		python = { "ruff" },

		sh = { "shellcheck" },
		bash = { "shellcheck" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			lint.try_lint()
		end,
	})
end
