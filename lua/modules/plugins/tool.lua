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
tool["echasnovski/mini.files"] = {
	event = "VeryLazy",
	version = false,
	config = require("tool.mini-files"),
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
tool["monaqa/dial.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("tool.dial"),
	dependencies = "nvim-lua/plenary.nvim",
}
if not is_windows then
	tool["michaelb/sniprun"] = {
		lazy = true,
		-- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
		-- if you encountered error about no executable sniprun found.
		build = "bash ./install.sh",
		cmd = { "SnipRun", "SnipReset", "SnipInfo" },
		config = require("tool.sniprun"),
	}
end
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
tool["Bekaboo/dropbar.nvim"] = {
	lazy = false,
	config = require("tool.dropbar"),
}
tool["m-demare/hlargs.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.hlargs"),
}
-- tool["kevinhwang91/nvim-hlslens"] = {
-- 	lazy = true,
-- 	event = "CmdlineEnter",
-- 	config = require("tool.hlslens"),
-- }
tool["LeonHeidelbach/trailblazer.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.trailblazer"),
}
if not vim.g.neovide then
	tool["3rd/image.nvim"] = {
		lazy = true,
		event = "VeryLazy",
		config = require("tool.image"),
	}
end

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tool.telescope"),
	dependencies = {
		{
			"ahmedkhalf/project.nvim",
			event = { "CursorHold", "CursorHoldI" },
			config = require("tool.project"),
		},
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{
			"FabianWirth/search.nvim",
			config = require("tool.search"),
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
		{
			"rcarriga/nvim-dap-ui",
			config = require("tool.dap.dapui"),
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},
		{ "jay-babu/mason-nvim-dap.nvim" },
		{
			"theHamsta/nvim-dap-virtual-text",
			config = require("tool.dap.dap-virtual-text"),
		},
	},
}

return tool
