local completion = {}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.lsp"),
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"Jint-lzxy/lsp_signature.nvim",
			config = require("completion.lsp-signature"),
		},
	},
}
completion["nvimdev/lspsaga.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.lspsaga"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
completion["dnlhc/glance.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.glance"),
}
completion["stevearc/aerial.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.aerial"),
}
completion["stevearc/conform.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.conform"),
}
completion["mfussenegger/nvim-lint"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.lint"),
}
completion["hrsh7th/nvim-cmp"] = {
	lazy = true,
	event = { "InsertEnter", "CmdlineEnter" },
	config = require("completion.cmp"),
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			config = require("completion.luasnip"),
		},
		{ "f3fora/cmp-spell" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "andersevenrud/cmp-tmux" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "kdheepak/cmp-latex-symbols" },
		{ "Gelio/cmp-natdat", config = true },
		{ "lukas-reineke/cmp-under-comparator" },
		{ "ray-x/cmp-treesitter", commit = "c8e3a74" },
	},
}

return completion
