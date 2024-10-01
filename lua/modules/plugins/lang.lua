local lang = {}

lang["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	ft = "qf",
	config = require("lang.bqf"),
	dependencies = {
		{ "junegunn/fzf", build = ":call fzf#install()" },
	},
}
lang["ray-x/go.nvim"] = {
	lazy = true,
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	config = require("lang.go-nvim"),
}
lang["mrcjkb/rustaceanvim"] = {
	lazy = true,
	ft = "rust",
	version = "*",
	init = require("lang.rust"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["mrcjkb/haskell-tools.nvim"] = {
	lazy = false,
	config = require("lang.haskell"),
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["AckslD/nvim-FeMaco.lua"] = {
	lazy = true,
	ft = "markdown",
	config = require("lang.femaco"),
}
lang["chrisbra/csv.vim"] = {
	lazy = false,
	ft = "csv",
}
lang["Mythos-404/xmake.nvim"] = {
	lazy = true,
	event = "BufReadPost xmake.lua",
	config = require("lang.xmake"),
}
lang["Civitasv/cmake-tools.nvim"] = {
	lazy = true,
	ft = "cmake",
	config = require("lang.cmake-tool"),
}
lang["fabridamicelli/cronex.nvim"] = {
	lazy = true,
	ft = { "yaml", "yml", "tf", "cfg", "config", "conf" },
	config = require("lang.cronex"),
}
lang["kchmck/vim-coffee-script"] = {
	lazy = true,
	ft = { "coffee" },
}
lang["jbyuki/one-small-step-for-vimkind"] = {
	lazy = true,
	ft = { "lua" },
}
lang["Mythos-404/parinfer-rust"] = {
	lazy = true,
	ft = {
		"query",
		"fennel",
		"scheme",
		"clojure",
		"lisp",
		"hy",
		"yuck",
		"dune",
	},
	build = "cargo build --release",
}
lang["fei6409/log-highlight.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	ft = { "log" },
	config = true,
}
lang["OXY2DEV/helpview.nvim"] = {
	lazy = true,
	ft = "help",
}
lang["ii14/neorepl.nvim"] = {
	lazy = true,
	ft = "lua",
	event = "VeryLazy",
}
lang["akinsho/flutter-tools.nvim"] = {
	lazy = true,
	ft = "dart",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = true,
}

return lang
