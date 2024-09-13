local tool = {}
local is_windows = require("core.global").is_windows

tool["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = require("tool.nvim-tree"),
}
tool["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tool.trouble"),
}
tool["folke/which-key.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("tool.which-key"),
}
tool["pysan3/fcitx5.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	cond = vim.fn.executable("fcitx5-remote") == 1,
	config = require("tool.fcitx5"),
}
tool["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.smartyank"),
}
tool["gbprod/cutlass.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.cutlass"),
}
tool["akinsho/toggleterm.nvim"] = {
	lazy = true,
	cmd = {
		"ToggleTerm",
		"ToggleTermSetName",
		"ToggleTermToggleAll",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualSelection",
	},
	config = require("tool.toggleterm"),
}
tool["LeonHeidelbach/trailblazer.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.trailblazer"),
}
tool["chrisgrieser/nvim-rip-substitute"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("tool.rip-substitute"),
}
if not is_windows then
	tool["michaelb/sniprun"] = {
		lazy = true,
		build = "bash ./install.sh",
		cmd = { "SnipRun", "SnipReset", "SnipInfo" },
		config = require("tool.sniprun"),
	}
end
tool["traduire.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	dev = true,
	config = true,
	opt = {},
}

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tool.telescope"),
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "debugloop/telescope-undo.nvim" },
		{ "fdschmidt93/telescope-egrepify.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "FabianWirth/search.nvim", config = require("tool.search") },
		{
			"Mythos-404/project.nvim",
			event = { "CursorHold", "CursorHoldI" },
			config = require("tool.project"),
		},
		{
			"aaronhallaert/advanced-git-search.nvim",
			cmd = { "AdvancedGitSearch" },
			dependencies = {
				-- to show diff splits and open commits in browser
				"tpope/vim-fugitive",
				-- to open commits in browser with fugitive
				"tpope/vim-rhubarb",
				-- optional: to replace the diff from fugitive with diffview.nvim
				-- (fugitive is still needed to open in browser)
				"sindrets/diffview.nvim",
			},
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
tool["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("tool.dap"),
	dependencies = {
		{ "jay-babu/mason-nvim-dap.nvim" },
		{
			"rcarriga/nvim-dap-ui",
			config = require("tool.dap.dapui"),
			dependencies = { "nvim-neotest/nvim-nio" },
		},
		{
			"LiadOz/nvim-dap-repl-highlights",
			config = require("tool.dap.dap-repl-highlights"),
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			config = require("tool.dap.dap-virtual-text"),
		},
	},
}

return tool
