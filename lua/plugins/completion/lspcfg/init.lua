local Plugin = require("core.plugin")

return Plugin:new("neovim/nvim-lspconfig")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :dep("mason-org/mason.nvim")
    :dep(Plugin:new("mason-org/mason-lspconfig.nvim")
        :config(require("plugins.completion.lspcfg.lspconfig")))
    :dep(Plugin:new("folke/neoconf.nvim")
        :opts(require("plugins.completion.lspcfg.neoconfig")))
    :config(function()
        local opts = {
            capabilities = require("utils").get_lsp_capabilities(),
        }

        -- Configure LSPs that are not supported by `mason.nvim` but are available in `nvim-lspconfig`.
        -- First call |vim.lsp.config()|, then |vim.lsp.enable()| (or use `register_server`, see below)
        -- to ensure the language server is properly configured and starts automatically.
        if vim.fn.executable("dart") == 1 then
            local _opts = require("plugins.completion.servers.dartls")
            local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
            require("utils").register_server("dartls", final_opts)
        end

        pcall(vim.cmd.LspStart)
    end)
