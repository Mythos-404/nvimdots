return function()
    local settings = require("core.settings")
    local tools = require("core.tools")
    local opts = { capabilities = require("utils").get_lsp_capabilities() }
    local configured = {}

    vim.diagnostic.config({
        signs = true,
        underline = settings.diagnostics_underline,
        virtual_text = settings.diagnostics_virtual_text,
        virtual_lines = settings.diagnostics_virtual_lines,
        update_in_insert = false,
    })

    local function configure(name)
        -- rustaceanvim owns rust-analyzer's configuration and lifecycle.
        if name == "rust_analyzer" or configured[name] then return end
        configured[name] = true

        local ok, handler = pcall(require, "plugins.completion.servers." .. name)
        if not ok then
            vim.lsp.config(name, opts)
        elseif type(handler) == "function" then
            handler(vim.deepcopy(opts))
        elseif type(handler) == "table" then
            vim.lsp.config(name, vim.tbl_deep_extend("force", opts, handler))
        else
            vim.notify("Invalid LSP configuration for " .. name, vim.log.levels.ERROR)
            return
        end

        local config = vim.lsp.config[name]
        if not config then return end
        local cmd = config.cmd
        -- Custom RPC transports are already responsible for starting their server.
        if type(cmd) ~= "table" then
            vim.lsp.enable(name)
            return
        end

        local active = false
        local function enable(quiet)
            if active then return end
            local path = tools.executable(cmd[1], quiet)
            if not path then return end
            local resolved = vim.deepcopy(cmd)
            resolved[1] = path
            vim.lsp.config(name, { cmd = resolved })
            vim.lsp.enable(name)
            active = true
        end
        enable(true)
        tools.on_filetype(config.filetypes or {}, function()
            enable(false)
        end)
    end

    if tools.use_mason() then
        local registry = require("mason-registry")
        local mason_lspconfig = require("mason-lspconfig")
        local function installed(pkg)
            local name = type(pkg) == "string" and pkg or pkg.name
            local server = mason_lspconfig.get_mappings().package_to_lspconfig[name]
            if server then configure(server) end
        end
        -- Subscribe before setup, which can start asynchronous installation.
        registry:on("package:install:success", vim.schedule_wrap(installed))
        mason_lspconfig.setup({ ensure_installed = settings.lsp_deps, automatic_enable = false })
        for _, pkg in ipairs(registry.get_installed_package_names()) do
            installed(pkg)
        end
    else
        for _, name in ipairs(settings.lsp_deps) do
            configure(name)
        end
    end

    if tools.executable("dart", true) then configure("dartls") end
end
