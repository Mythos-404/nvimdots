return function()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },

			zsh = { "beautysh" },
			sh = { "beautysh" },

			vue = { "prettier" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			typescriptreact = { "prettier" },
			javascriptreact = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			markdown = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },

			rust = { "rustfmt" },

			lua = { "stylua" },
		},
	})

	conform.formatters.clang_format = {
		prepend_args = require("completion.formatters.clang_format"),
	}

	require("completion.formatting").configure_format_on_save()
end
