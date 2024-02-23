return function()
	vim.filetype.add({
		pattern = {
			["~/dotfiles/.config/hypr/.*%.conf"] = "hyprlang",
		},
	})
end
