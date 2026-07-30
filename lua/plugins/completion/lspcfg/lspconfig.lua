return function()
    local lsp_deps = require("core.settings").lsp_deps
    local diagnostics_underline = require("core.settings").diagnostics_underline
    local diagnostics_virtual_text = require("core.settings").diagnostics_virtual_text
    local diagnostics_virtual_lines = require("core.settings").diagnostics_virtual_lines

    local mason_registry = require("mason-registry")
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
        ensure_installed = lsp_deps,
        -- Skip auto enable because we are loading language servers lazily
        automatic_enable = false,
    })


    vim.diagnostic.config({
        signs = true,
        underline = diagnostics_underline,
        virtual_text = diagnostics_virtual_text,
        virtual_lines = diagnostics_virtual_lines,
        -- set update_in_insert to false because it was enabled by lspsaga
        update_in_insert = false,
    })

    local opts = {
        capabilities = require("utils").get_lsp_capabilities(),
    }

    ---A handler to setup all servers defined under `completion/servers/*.lua`
    ---@param lsp_name string
    local function mason_lsp_handler(lsp_name)
        -- rust_analyzer is configured using mrcjkb/rustaceanvim
        -- warn users if they have set it up manually
        if lsp_name == "rust_analyzer" then
            local config_exist = pcall(require, "completion.servers." .. lsp_name)
            if config_exist then
                vim.notify(
                    [[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
                    vim.log.levels.WARN,
                    { title = "nvim-lspconfig" }
                )
            end
            return
        end

        local ok, handler = pcall(require, "completion.servers." .. lsp_name)
        if not ok then
            -- Default to use factory config for server(s) that doesn't include a spec
            require("utils").register_server(lsp_name, opts)
        elseif type(handler) == "function" then
            -- Case where language server requires its own setup
            -- Be sure to call `vim.lsp.config()` within the setup function.
            -- Refer to |vim.lsp.config()| for documentation.
            -- For an example, see `clangd.lua`.
            handler(opts)
            vim.lsp.enable(lsp_name)
        elseif type(handler) == "table" then
            require("utils").register_server(lsp_name, handler)
        else
            vim.notify(
                string.format(
                    "Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
                    lsp_name,
                    type(handler)
                ),
                vim.log.levels.ERROR,
                { title = "nvim-lspconfig" }
            )
        end
    end

    ---A simplified mimic of <mason-lspconfig 1.x>'s `setup_handlers` callback.
    ---Invoked for each Mason package (name or `Package` object) to configure its language server.
    ---@param pkg string|{name: string} Either the package name (string) or a Package object
    local function setup_lsp_for_package(pkg)
        -- First try to grab the builtin mappings
        local mappings = mason_lspconfig.get_mappings().package_to_lspconfig
        -- If empty or nil, build it by hand
        if not mappings or vim.tbl_isempty(mappings) then
            mappings = {}
            for _, spec in ipairs(mason_registry.get_all_package_specs()) do
                local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
                if lspconfig then mappings[spec.name] = lspconfig end
            end
        end

        -- Figure out the package name and lookup
        local name = type(pkg) == "string" and pkg or pkg.name
        local srv = mappings[name]
        if not srv then return end

        -- Invoke the handler
        mason_lsp_handler(srv)
    end

    for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
        setup_lsp_for_package(pkg)
    end
end
