local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local plug_map = {
	-- Plugin: dial.nvim
	["n|<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "normal")
	end),
	["n|<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "normal")
	end),
	["v|<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "visual")
	end),
	["v|<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "visual")
	end),
	["n|g<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "gnormal")
	end),
	["n|g<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "gnormal")
	end),
	["v|g<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "gvisual")
	end),
	["v|g<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "gvisual")
	end),
	["n|<A-C-a>"] = map_cmd(require("dial.map").inc_normal("extra")):with_noremap(),
	["n|<A-C-x>"] = map_cmd(require("dial.map").dec_normal("extra")):with_noremap(),

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

	-- Plugin: flash
	["nv|s"] = map_cmd("<Cmd>lua require('flash').jump()<CR>"):with_noremap():with_desc("jump: Goto one char"),
	["nv|B"] = map_cmd("<Cmd>lua require('flash').treesitter()<CR>"):with_noremap():with_desc("jump: Goto one char"),
	["o|r"] = map_cmd("<Cmd>lua require('flash').remote()<CR>"):with_silent():with_noremap():with_desc("Remote Flash"),
	["ox|R"] = map_cmd("<Cmd>lua require('flash').treesitter_search()<CR>"),
	["c|<c-s>"] = map_cmd("<Cmd>lua require('flash').toggle()<CR>")
		:with_silent()
		:with_noremap()
		:with_desc("Toggle Flash Search"),

	-- Plugin: smart-splits.nvim
	["n|<A-h>"] = map_cu("SmartResizeLeft"):with_silent():with_noremap():with_desc("window: Resize -3 horizontally"),
	["n|<A-j>"] = map_cu("SmartResizeDown"):with_silent():with_noremap():with_desc("window: Resize -3 vertically"),
	["n|<A-k>"] = map_cu("SmartResizeUp"):with_silent():with_noremap():with_desc("window: Resize +3 vertically"),
	["n|<A-l>"] = map_cu("SmartResizeRight"):with_silent():with_noremap():with_desc("window: Resize +3 horizontally"),
	["n|<C-h>"] = map_cu("SmartCursorMoveLeft"):with_silent():with_noremap():with_desc("window: Focus left"),
	["n|<C-j>"] = map_cu("SmartCursorMoveDown"):with_silent():with_noremap():with_desc("window: Focus down"),
	["n|<C-k>"] = map_cu("SmartCursorMoveUp"):with_silent():with_noremap():with_desc("window: Focus up"),
	["n|<C-l>"] = map_cu("SmartCursorMoveRight"):with_silent():with_noremap():with_desc("window: Focus right"),
	["n|<leader>Wh"] = map_cu("SmartSwapLeft"):with_silent():with_noremap():with_desc("window: Move window leftward"),
	["n|<leader>Wj"] = map_cu("SmartSwapDown"):with_silent():with_noremap():with_desc("window: Move window downward"),
	["n|<leader>Wk"] = map_cu("SmartSwapUp"):with_silent():with_noremap():with_desc("window: Move window upward"),
	["n|<leader>Wl"] = map_cu("SmartSwapRight"):with_silent():with_noremap():with_desc("window: Move window rightward"),

	-- Plugin: nvim-treehopper
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

	-- Plugin: refactoring.nvim
	["v|<leader>Rt"] = map_cu(":Refactor extract_to_file ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Extract to file"),
	["v|<leader>Rf"] = map_cu(":Refactor extract ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Extract function"),
	["v|<leader>Rv"] = map_cu(":Refactor extract_var ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Extract variable"),
	["n|<leader>Rf"] = map_cu(":Refactor inlien_func ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Inline variable"),
	["n|<leader>Rv"] = map_cu(":Refactor inline_var ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Inline variable"),
}

bind.nvim_load_mapping(plug_map)
