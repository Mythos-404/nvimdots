local editor = {}

editor["rainbowhxch/accelerated-jk.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("editor.accelerated-jk"),
}
editor["chrisgrieser/nvim-spider"] = {
	lazy = true,
	event = "VeryLazy",
}
editor["olimorris/persisted.nvim"] = {
	lazy = true,
	cmd = {
		"SessionToggle",
		"SessionStart",
		"SessionStop",
		"SessionSave",
		"SessionLoad",
		"SessionLoadLast",
		"SessionLoadFromFile",
		"SessionDelete",
	},
	config = require("editor.persisted"),
}
editor["altermo/ultimate-autopair.nvim"] = {
	lazy = true,
	branch = "development",
	event = { "InsertEnter", "CmdlineEnter" },
	config = require("editor.ultimate-autopair"),
}
editor["max397574/better-escape.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.better-escape"),
}
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
editor["sindrets/diffview.nvim"] = {
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
}
editor["folke/flash.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("editor.flash"),
}
editor["RRethy/vim-illuminate"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.vim-illuminate"),
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	config = require("editor.suda"),
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
	event = "VeryLazy",
	config = require("editor.mini-surround"),
}
editor["echasnovski/mini.move"] = {
	lazy = true,
	version = false,
	event = "VeryLazy",
	config = require("editor.mini-move"),
}
editor["chrisgrieser/nvim-recorder"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("editor.recorder"),
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
		{ "andymass/vim-matchup" }, -- NOTE: https://github.com/andymass/vim-matchup/issues/328 Bug Fix On Open
		{ "chrisgrieser/nvim-puppeteer" },
		{ "mfussenegger/nvim-treehopper" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{
			"danymat/neogen",
			config = require("editor.neogen"),
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"NvChad/nvim-colorizer.lua",
			config = require("editor.colorizer"),
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
		{ "IndianBoy42/tree-sitter-just", config = true },
	},
}

return editor
