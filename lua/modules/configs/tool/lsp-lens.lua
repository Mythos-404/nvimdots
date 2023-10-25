return function()
	require("lsp-lens").setup({
		enable = true,
		include_declaration = false, -- Reference include declaration
		ignore_filetype = {
			"prisma",
		},
	})
end
