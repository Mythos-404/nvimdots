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
tool["gbprod/yanky.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.yanky"),
	dependencies = { "kkharji/sqlite.lua" },
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
tool["folke/todo-comments.nvim"] = {
	lazy = true,
	cmd = "TodoTelescope",
	event = "BufRead",
	config = require("tool.todo-comments"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
tool["VidocqH/lsp-lens.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("tool.lsp-lens"),
}
if vim.fn.has("nvim-0.10.0") then
	tool["Bekaboo/dropbar.nvim"] = {
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = require("tool.dropbar"),
		dependencies = { "nvim-tree/nvim-web-devicons" },
	}
end
tool["m-demare/hlargs.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.hlargs"),
}
tool["kevinhwang91/nvim-hlslens"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = require("tool.hlslens"),
}
tool["LeonHeidelbach/trailblazer.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.trailblazer"),
}
tool["wintermute-cell/gitignore.nvim"] = {
	lazy = true,
	cmd = "Gitignore",
}

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
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
		},
		{ "jay-babu/mason-nvim-dap.nvim" },
	},
}

return tool
