local Plugin = require("core.plugin")
local settings = require("core.settings")

return Plugin:new("WhoIsSethDaniel/mason-tool-installer.nvim")
    :enabled(require("core.tools").use_mason())
    :lazy(false)
    :dep("mason-org/mason.nvim")
    :opts({
        ensure_installed = vim.list_extend(vim.deepcopy(settings.formatter_deps), settings.lint_deps),
        auto_update = false,
        run_on_start = true,
        integrations = {
            ["mason-lspconfig"] = false,
            ["mason-null-ls"] = false,
            ["mason-nvim-dap"] = false,
        },
    })
