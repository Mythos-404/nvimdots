return function()
    local nvim_lsp = require("lspconfig")
    require("completion.neoconf").setup()
    require("completion.mason").setup()
    require("completion.mason-lspconfig").setup()
    require("tool.dap.mason-dap").setup()

    -- local opts = {
    -- 	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    -- }

    pcall(vim.cmd.LspStart)
end
