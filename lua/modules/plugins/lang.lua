local lang = {}

lang["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	ft = "qf",
	config = require("lang.bqf"),
	dependencies = {
		{ "junegunn/fzf", build = ":call fzf#install()" },
	},
}
lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = require("lang.vim-go"),
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["ellisonleao/glow.nvim"] = {
	lazy = true,
	ft = "markdown",
	cmd = "Glow",
	config = true,
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

return lang
