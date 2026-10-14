local Plugin = require("core.plugin")
local settings = require("core.settings")
local tools = require("core.tools")
local map_cmd = require("keymap.bind").map_cmd
local map_callback = require("keymap.bind").map_callback

local formatters_by_ft = {
    awk = { "awk" },

    bash = { "shfmt" },
    sh = { "shfmt" },
    zsh = { "shfmt" },

    c = { "clang-format" },
    cpp = { "clang-format" },

    vue = { "prettierd", "injected" },
    typescript = { "prettierd" },
    javascript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd" },
    html = { "prettierd", "injected" },
    css = { "prettierd" },
    scss = { "prettierd" },
    markdown = { "prettierd", "injected" },
    json = { "prettierd" },
    jsonc = { "prettierd" },

    just = { "just" },

    rust = { "rustfmt" },

    go = { "goimports", "gofumpt" },

    python = { "ruff_format", "ruff_organize_imports", "injected" },

    lua = { "stylua", "injected" },

    yaml = { "yamlfmt" },

    glsl = { lsp_format = "fallback" },
    toml = { lsp_format = "fallback" },
}

local function format_disabled(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return true end
    if settings.formatter_block_list[vim.bo[bufnr].filetype] then return true end

    local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
    for _, dir in ipairs(settings.format_disabled_dirs) do
        if path:find(vim.fs.normalize(dir), 1, false) then return true end
    end
    return false
end

local function format_on_save(bufnr)
    if format_disabled(bufnr) then return end
    local args = { timeout_ms = 500, lsp_format = "fallback" }
    if not settings.format_notify then return args end

    return args,
        function(err)
            if not err then
                vim.notify("[Formatter] Format on save successful", vim.log.levels.INFO, { title = "Format Success" })
            end
        end
end

local function toggle_filetype_formatter(ft)
    ft = ft or vim.bo.filetype
    if ft == "" then
        vim.notify("[Formatter] No filetype to toggle", vim.log.levels.WARN)
        return
    end
    local disabled = settings.formatter_block_list[ft]
    settings.formatter_block_list[ft] = not disabled
    vim.notify(
        ("[Formatter] %s for [%s]"):format(disabled and "Enabled" or "Disabled", ft),
        disabled and vim.log.levels.INFO or vim.log.levels.WARN,
        { title = "Formatter Toggle" }
    )
end

local function load_formatter_overrides()
    local dir = require("core.global").vim_path .. "/lua/plugins/completion/formatters"
    local ok, handle = pcall(vim.uv.fs_scandir, dir)
    if not ok or not handle then return {} end

    local overrides = {}
    while true do
        local name, entry_type = vim.uv.fs_scandir_next(handle)
        if not name then break end
        if entry_type == "file" and name:match("%.lua$") then
            local mod = name:gsub("%.lua$", "")
            local loaded, handler = pcall(require, "plugins.completion.formatters." .. mod)
            if loaded then overrides[mod] = handler end
        end
    end
    return overrides
end

return Plugin:new("stevearc/conform.nvim")
    :lazy(true)
    :on("VeryLazy")
    :lazy_keys({
        ["n|<A-f>"] = map_cmd("<Cmd>FormatToggle<CR>"):with_desc("formatter: Toggle format on save"),
        ["n|<leader>lf"] = map_cmd("<Cmd>Format<CR>"):with_desc("formatter: Format buffer"),
        ["n|<leader>lt"] = map_callback(function()
            toggle_filetype_formatter()
        end):with_desc("formatter: Toggle formatter for filetype"),
    })
    :config(function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        local conform = require("conform")
        local formatters = load_formatter_overrides()
        -- Resolve system tools from PATH, including prettierd (whose builtin
        -- normally searches node_modules first). Keep builtin arguments/options.
        if not tools.use_mason() then
            for _, names in pairs(formatters_by_ft) do
                for _, name in ipairs(names) do
                    if name ~= "injected" then
                        local builtin = require("conform.formatters." .. name)
                        local command = name == "prettierd" and "prettierd" or builtin.command
                        if type(command) == "string" then
                            formatters[name] = vim.tbl_extend("force", formatters[name] or {}, {
                                command = function()
                                    return tools.executable(command) or command
                                end,
                            })
                        end
                    end
                end
            end
        end
        conform.setup({
            formatters_by_ft = formatters_by_ft,
            formatters = vim.tbl_extend("force", {
                injected = {
                    options = {
                        ignore_errors = true,
                    },
                },
            }, formatters),
            notify_no_formatters = tools.use_mason(),
            format_on_save = settings.format_on_save and format_on_save or nil,
        })

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format({ async = true, lsp_format = "fallback", range = range }, function(err)
                if not err and settings.format_notify then
                    vim.notify("[Formatter] Format successful", vim.log.levels.INFO, { title = "Format Success" })
                end
            end)
        end, { range = true, desc = "Format buffer or selected range" })

        vim.api.nvim_create_user_command("FormatToggle", function(args)
            if args.bang then
                local disabled = not vim.b.disable_autoformat
                vim.b.disable_autoformat = disabled
                vim.notify(
                    ("[Formatter] Format on save %s for this buffer"):format(disabled and "disabled" or "enabled"),
                    disabled and vim.log.levels.WARN or vim.log.levels.INFO,
                    { title = "Format Toggle" }
                )
            else
                local disabled = not vim.g.disable_autoformat
                vim.g.disable_autoformat = disabled
                vim.notify(
                    ("[Formatter] Format on save %s"):format(disabled and "disabled" or "enabled"),
                    disabled and vim.log.levels.WARN or vim.log.levels.INFO,
                    { title = "Format Toggle" }
                )
            end
        end, { bang = true, desc = "Toggle format on save" })

        vim.api.nvim_create_user_command("FormatterToggleFt", function(opts)
            toggle_filetype_formatter(opts.args)
        end, { nargs = 1, complete = "filetype", desc = "Toggle formatter for filetype" })
    end)
