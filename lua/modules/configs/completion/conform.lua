return function()
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			awk = { "awk" },

			bash = { "shfmt" },
			sh = { "shfmt" },
			zsh = { "beautysh" },

			c = { "clang-format" },
			cpp = { "clang-format" },

			vue = { "prettier", "injected" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			typescriptreact = { "prettier" },
			javascriptreact = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier", "injected" },
			css = { "prettier" },
			scss = { "prettier" },
			markdown = { "prettier", "injected" },
			json = { "prettier" },
			jsonc = { "prettier" },

			just = { "just" },

			rust = { "rustfmt" },

			python = { "ruff_format", "ruff_organize_imports", "injected" },

			lua = { "stylua", "injected" },
		},
	})

	conform.formatters.injected = {
		options = {
			ignore_errors = true,
			lang_to_formatters = vim.tbl_extend("keep", {}, conform.formatters_by_ft),
		},
	}
	-- loader formatter config file
	for _, format_info in ipairs(conform.list_all_formatters()) do
		local ok, custom_handler = pcall(require, "completion.formatters." .. format_info.name)
		if ok then
			conform.formatters[format_info.name] = custom_handler
		end
	end

	require("completion.formatting").configure_format_on_save()
end
