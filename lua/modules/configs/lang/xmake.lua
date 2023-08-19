local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local xmake_keymap = {
	["n|<leader>xt"] = map_cmd("<Cmd>XmakeSetTarget<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Option target"),
	["n|<leader>xm"] = map_cmd("<Cmd>XmakeSetMode<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Option build mode"),

	["n|<leader>xbb"] = map_cmd("<Cmd>XmakeBuild<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Build current target"),
	["n|<leader>xbt"] = map_cmd("<Cmd>XmakeBuildTarget<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Option build target"),
	["n|<leader>xba"] = map_cmd("<Cmd>XmakeBuildAll<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Build all target"),
	["n|<leader>xcc"] = map_cmd("<Cmd>XmakeClean<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Clean current target"),
	["n|<leader>xct"] = map_cmd("<Cmd>XmakeCleanTarget<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Option clean target"),
	["n|<leader>xca"] = map_cmd("<Cmd>XmakeCleanAll<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("xmake: Clean all target"),
}

return function()
	require("xmake").setup()

	bind.nvim_load_mapping(xmake_keymap)
end
