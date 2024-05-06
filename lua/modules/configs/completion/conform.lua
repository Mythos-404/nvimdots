return function()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			zsh = { "beautysh" },

			c = { "clang_format" },
			cpp = { "clang_format" },

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

			sh = { "shfmt" },

			lua = { "stylua" },

			["_"] = { "trim_whitespace" },
		},
	})

	for _, format_info in ipairs(conform.list_all_formatters()) do
		local ok, custom_handler = pcall(require, "completion.formatters." .. format_info.name)
		if ok then
			conform.formatters[format_info.name] = {
				prepend_args = custom_handler,
			}
		end
	end

	require("completion.formatting").configure_format_on_save()
end
