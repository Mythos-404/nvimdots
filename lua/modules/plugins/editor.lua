local editor = {}

editor["chrisgrieser/nvim-spider"] = {
	lazy = true,
	event = "VeryLazy",
}
editor["olimorris/persisted.nvim"] = {
	lazy = false,
	config = require("editor.persisted"),
}
editor["altermo/ultimate-autopair.nvim"] = {
	lazy = true,
	branch = "development",
	event = { "InsertEnter", "CmdlineEnter" },
	config = require("editor.ultimate-autopair"),
}
-- editor["max397574/better-escape.nvim"] = {
-- 	lazy = true,
-- 	event = { "CursorHold", "CursorHoldI" },
-- 	config = require("editor.better-escape"),
-- }
editor["LunarVim/bigfile.nvim"] = {
	lazy = false,
	config = require("editor.bigfile"),
	cond = require("core.settings").load_big_files_faster,
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.comment"),
}
editor["folke/flash.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("editor.flash"),
}
editor["tzachar/local-highlight.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.local-highlight"),
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	init = require("editor.suda"),
}
editor["tzachar/highlight-undo.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.highlight-undo"),
}
editor["kevinhwang91/nvim-ufo"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.ufo"),
	dependencies = {
		{ "kevinhwang91/promise-async" },
		{
			"luukvbaal/statuscol.nvim",
			branch = "0.10",
			config = require("editor.statuscol"),
		},
	},
}
editor["echasnovski/mini.surround"] = {
	lazy = true,
	version = false,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.mini-surround"),
}
editor["echasnovski/mini.align"] = {
	lazy = true,
	version = false,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.mini-align"),
}
editor["echasnovski/mini.move"] = {
	event = "VeryLazy",
	version = false,
	config = require("editor.mini-move"),
}
editor["echasnovski/mini.ai"] = {
	event = "VeryLazy",
	version = false,
	config = require("editor.mini-ai"),
}
-- editor["chrisgrieser/nvim-recorder"] = {
-- 	lazy = true,
-- 	event = { "BufReadPost", "BufAdd", "BufNewFile" },
-- 	config = require("editor.recorder"),
-- }
editor["brenoprata10/nvim-highlight-colors"] = {
	lazy = true,
	event = "BufReadPre",
	config = require("editor.highlight-colors"),
}
editor["tpope/vim-sleuth"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPost", "BufFilePost" },
}
editor["nvim-pack/nvim-spectre"] = {
	lazy = true,
	cmd = "Spectre",
}
editor["mrjones2014/smart-splits.nvim"] = {
	lazy = true,
	event = { "CursorHoldI", "CursorHold" },
	config = require("editor.smart-splits"),
}

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = true,
	build = function()
		if #vim.api.nvim_list_uis() ~= 0 then
			vim.api.nvim_command([[ TSUpdate ]])
		end
	end,
	event = "BufReadPre",
	config = require("editor.treesitter"),
	dependencies = {
		{ "chrisgrieser/nvim-puppeteer" },
		{ "mfussenegger/nvim-treehopper" },
		{
			"danymat/neogen",
			config = require("editor.neogen"),
		},
		{
			"andymass/vim-matchup",
			init = require("editor.vim-matchup"),
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"ThePrimeagen/refactoring.nvim",
			config = require("editor.refacotring"),
		},
		{
			"hiphish/rainbow-delimiters.nvim",
			config = require("editor.rainbow_delims"),
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = require("editor.ts-context"),
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			config = require("editor.ts-context-commentstring"),
		},
	},
}

return editor
