local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local plug_map = {
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
	["nv|S"] = map_cmd("<Cmd>lua require('flash').jump()<CR>"):with_noremap():with_desc("jump: Goto one char"),
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

	-- Plugin: nvim-spectre
	["n|<leader>Ss"] = map_callback(function()
			require("spectre").toggle()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("editn: Toggle search & replace panel"),
	["n|<leader>Sp"] = map_callback(function()
			require("spectre").open_visual({ select_word = true })
		end)
		:with_silent()
		:with_noremap()
		:with_desc("editn: search&replace current word (project)"),
	["v|<leader>Sp"] = map_callback(function()
			require("spectre").open_visual()
		end)
		:with_silent()
		:with_noremap()
		:with_desc("edit: search & replace current word (project)"),
	["n|<leader>Sf"] = map_callback(function()
			require("spectre").open_file_search({ select_word = true })
		end)
		:with_silent()
		:with_noremap()
		:with_desc("editn: search & replace current word (file)"),

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
	["v|<leader>Ref"] = map_cu(":Refactor extract ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Extract function"),
	["v|<leader>Rev"] = map_cu(":Refactor extract_var ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Extract variable"),
	["n|<leader>Rlf"] = map_cu(":Refactor inlien_func ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Inline variable"),
	["n|<leader>Rlv"] = map_cu(":Refactor inline_var ")
		:with_silent()
		:with_noremap()
		:with_desc("refactoring: Inline variable"),
}

bind.nvim_load_mapping(plug_map)
