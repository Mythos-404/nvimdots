return function()
	vim.filetype.add({
		pattern = {
			["~/.config/hypr/.*%.conf"] = "hyprlang",
		},
	})
end
