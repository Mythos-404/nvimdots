return function()
    require("completion.neoconf").setup()
    require("completion.mason").setup()
    require("completion.mason-lspconfig").setup()
    require("tool.dap.mason-dap").setup()
end
