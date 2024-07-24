return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		misc = require("modules.utils.icons").get("misc"),
		git = require("modules.utils.icons").get("git", true),
		cmp = require("modules.utils.icons").get("cmp", true),
	}

	require("which-key").setup({
		preset = "helix",
		delay = vim.o.timeoutlen,
		triggers = {
			{ "<auto>", mode = "nixso" },
		},
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				motions = false,
				operators = false,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		win = {
			wo = { winblend = 0 },
		},
		expand = 1,
		icons = {
			group = "",
			rules = false,
			colors = true,
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			keys = {
				C = "C-",
				M = "A-",
				S = "S-",
				BS = "<BS> ",
				CR = "<CR> ",
				NL = "<NL> ",
				Esc = "<Esc> ",
				Tab = "<Tab> ",
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				Space = "<Space> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
			},
		},
		spec = {
			{ "<leader>b", group = "Buffer", icon = icons.ui.Buffer },
			{ "<leader>d", group = "Debug", icon = icons.ui.Bug },
			{ "<leader>f", group = "Fuzzy Find", icon = icons.ui.Telescope },
			{ "<leader>g", group = "Git", icon = icons.git.Git },
			{ "<leader>l", group = "Lsp", icon = icons.misc.LspAvailable },
			{ "<leader>n", group = "Nvim Tree", icon = icons.ui.FolderOpen },
			{ "<leader>p", group = "Package", icon = icons.ui.Package },
			{ "<leader>S", group = "Search", icon = icons.ui.Search },
			{ "<leader>s", group = "Session", icon = icons.cmp.tmux },
			{ "<leader>W", group = "Window", icon = icons.ui.Window },

			{ "<leader>R", group = "Refactor", icon = "" },

			{ "<leader>r", mode = "nx", icon = icons.misc.CodeRunAll },
			{ "<leader>o", icon = icons.ui.Pencil },
		},
	})
end
