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
	version = "^3",
	init = require("lang.rust"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
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
	lazy = true,
	ft = "csv",
}
lang["Mythos-404/xmake.nvim"] = {
	lazy = true,
	event = "BufReadPost xmake.lua",
	config = require("lang.xmake"),
	dependencies = { "MunifTanjim/nui.nvim" },
}
lang["kmonad/kmonad-vim"] = {
	lazy = true,
	ft = "kbd",
}
lang["eraserhd/parinfer-rust"] = {
	lazy = true,
	ft = "yuck",
	build = "cargo build --release",
}
lang["fabridamicelli/cronex.nvim"] = {
	lazy = true,
	ft = { "yaml", "yml", "tf", "cfg", "config", "conf" },
	config = require("lang.cronex"),
}

return lang
