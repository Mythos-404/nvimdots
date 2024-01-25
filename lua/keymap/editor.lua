local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local plug_map = {
	-- Plugin: accelerate-jk
	["n|j"] = map_callback(function()
		return et("<Plug>(accelerated_jk_gj)")
	end):with_expr(),
	["n|k"] = map_callback(function()
		return et("<Plug>(accelerated_jk_gk)")
	end):with_expr(),

	-- Plug nvim-spider
	["nox|w"] = map_cmd("<Cmd>lua require('spider').motion('w', { skipInsignificantPunctuation = false })<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("Spider-w"),
	["nox|e"] = map_cmd("<Cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("Spider-w"),
	["nox|b"] = map_cmd("<Cmd>lua require('spider').motion('b')<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("Spider-w"),

	-- Plugin persisted.nvim
	["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("session: Save"),
	["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("session: Load current"),
	["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("session: Delete"),

	-- Plugin: nvim-bufdel
	["n|<A-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("buffer: Close current"),

	-- Plugin: comment.nvim
	["n|gcc"] = map_callback(function()
			return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
				or et("<Plug>(comment_toggle_linewise_count)")
		end)
		:with_silent()
		:with_noremap()
		:with_expr()
		:with_desc("edit: Toggle comment for line"),
	["n|gbc"] = map_callback(function()
			return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
				or et("<Plug>(comment_toggle_blockwise_count)")
		end)
		:with_silent()
		:with_noremap()
		:with_expr()
		:with_desc("edit: Toggle comment for block"),
	["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
		:with_silent()
		:with_noremap()
		:with_desc("edit: Toggle comment for line with operator"),
	["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
		:with_silent()
		:with_noremap()
		:with_desc("edit: Toggle comment for block with operator"),
	["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
		:with_silent()
		:with_noremap()
		:with_desc("edit: Toggle comment for line with selection"),
	["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
		:with_silent()
		:with_noremap()
		:with_desc("edit: Toggle comment for block with selection"),

	-- Plugin: diffview
	["n|<leader>gd"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("git: Show diff"),
	["n|<leader>gD"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("git: Close diff"),

	-- Plugin: flash
	["nv|S"] = map_cmd("<Cmd>lua require('flash').jump()<CR>"):with_noremap():with_desc("jump: Goto one char"),
	["nv|B"] = map_cmd("<Cmd>lua require('flash').treesitter()<CR>"):with_noremap():with_desc("jump: Goto one char"),
	["o|r"] = map_cmd("<Cmd>lua require('flash').remote()<CR>"):with_silent():with_noremap():with_desc("Remote Flash"),
	["ox|R"] = map_cmd("<Cmd>lua require('flash').treesitter_search()<CR>"),
	["c|<c-s>"] = map_cmd("<Cmd>lua require('flash').toggle()<CR>")
		:with_silent()
		:with_noremap()
		:with_desc("Toggle Flash Search"),

	-- Plugin: treehopper
	["o|m"] = map_cu("lua require('tsht').nodes()"):with_silent():with_desc("jump: Operate across syntax tree"),

	-- Plugin suda.vim
	["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("editn: Save file using sudo"),

	-- Plugin neogen
	["n|gcd"] = map_cmd("<Cmd>lua require('neogen').generate()<CR>")
		:with_silent()
		:with_noremap()
		:with_desc("editor: Add documentation comments"),

	-- Plugin: ufo
	["n|zR"] = map_callback(function()
			require("ufo").openAllFolds()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("edit: Open all folds"),
	["n|zM"] = map_callback(function()
			require("ufo").closeAllFolds()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("edit: Close all folds"),
	["n|zp"] = map_callback(function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
		:with_silent()
		:with_noremap()
		:with_desc("edit: Preview all folds"),
}

bind.nvim_load_mapping(plug_map)
