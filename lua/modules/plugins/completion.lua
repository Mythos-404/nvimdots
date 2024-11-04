local completion = {}

completion["neovim/nvim-lspconfig"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("completion.lsp"),
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "folke/neoconf.nvim" },
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
}
completion["stevearc/aerial.nvim"] = {
    lazy = true,
    event = "LspAttach",
    config = require("completion.aerial"),
}
completion["dnlhc/glance.nvim"] = {
    lazy = true,
    event = "LspAttach",
    config = require("completion.glance"),
}
completion["joechrisellis/lsp-format-modifications.nvim"] = {
    lazy = true,
    event = "LspAttach",
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
completion["iguanacucumber/magazine.nvim"] = {
    lazy = true,
    name = "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = require("completion.cmp"),
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            config = require("completion.luasnip"),
        },
        { "rcarriga/cmp-dap" },
        { "f3fora/cmp-spell" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "saadparwaiz1/cmp_luasnip" },
        { "FelipeLema/cmp-async-path" },
        { "kdheepak/cmp-latex-symbols" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "ray-x/cmp-treesitter", commit = "c8e3a74" },
    },
}

return completion
