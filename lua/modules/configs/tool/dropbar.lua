--- @param call_back function
local function dropbar_call(call_back)
	return function()
		local menu = require("dropbar.api").get_current_dropbar_menu()

		if not menu then
			return
		end

		call_back(menu)
	end
end

local function open_bar(menu)
	local cursor = vim.api.nvim_win_get_cursor(menu.win)
	local component = menu.entries[cursor[1]]:first_clickable(cursor[2])

	if component then
		menu:click_on(component, nil, 1, "l")
	end
end

local function exit_bar(menu)
	local prev_menu = menu.prev_menu
	local root_menu = nil

	while prev_menu do
		root_menu = prev_menu
		prev_menu = prev_menu.prev_menu
	end

	if root_menu then
		root_menu:close()
	else
		menu:close()
	end
end

return function()
	require("dropbar").setup({
		menu = {
			entry = { padding = { left = 0, right = 0 } },
			keymaps = {
				["q"] = dropbar_call(exit_bar),
				["Q"] = dropbar_call(exit_bar),
				["l"] = dropbar_call(open_bar),
				["h"] = "<C-w>c",
				["<Tab>"] = dropbar_call(open_bar),
				["<S-Tab>"] = "<C-w>c",
			},
		},
	})
end
