return function()
	require("nvim-highlight-colors").setup({
		---Render style
		---@usage 'background'|'foreground'|'virtual'
		render = "background",

		---Set virtual symbol (requires render to be set to 'virtual')
		-- virtual_symbol = "■",

		---Highlight tailwind colors, e.g. 'bg-blue-500'
		enable_tailwind = true,
	})
end
