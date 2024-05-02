return function()
	require("nvim-dap-virtual-text").setup({
		display_callback = function(variable, _, _, _, _)
			return " " .. variable.value
		end,
	})
end
