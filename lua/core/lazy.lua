-- ═══════════════════════════════════════════════════════════════
-- 插件加载器 (替代 core/pack.lua)
-- 扫描 lua/plugins/**/*.lua → dofile → Plugin:to_spec() → lazy.setup()
-- ═══════════════════════════════════════════════════════════════

local M = {}

function M.setup()
    local global = require("core.global")
    local settings = require("core.settings")
    local icons_mod = require("utils.icons")

    local data_dir = global.data_dir
    local use_ssh = settings.use_ssh

    -- 1) 引导 lazy.nvim
    local lazy_path = data_dir .. "lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazy_path) then
        local lazy_repo = use_ssh
            and "git@github.com:folke/lazy.nvim.git"
            or "https://github.com/folke/lazy.nvim.git"
        local output = vim.fn.system({
            "git", "clone", "--filter=blob:none", "--branch=stable",
            lazy_repo, lazy_path,
        })
        if vim.v.shell_error ~= 0 then
            error(("Failed to clone lazy.nvim from %s:\n%s"):format(lazy_repo, output))
        end
    end
    vim.opt.rtp:prepend(lazy_path)

    -- 2) 扫描 plugins 目录
    local plugin_dir = global.vim_path .. "/lua/plugins"
    local files = vim.fn.glob(plugin_dir .. "/**/*.lua", true, true)
    table.sort(files)
    local specs = {}

    for _, file in ipairs(files) do
        local basename = vim.fn.fnamemodify(file, ":t")
        -- Disabled plugin files use the repository convention: foo.lua.disable.
        if basename:match("^_") or basename:match("%.lua%.disable$") or basename:match("%.disabled%.lua$") then
            goto continue
        end

        local ok, plugin = pcall(dofile, file)
        if not ok then
            vim.notify(("Failed to load plugin spec %s:\n%s"):format(file, plugin), vim.log.levels.ERROR)
        elseif type(plugin) == "table" and plugin.to_spec then
            table.insert(specs, plugin:to_spec())
        else
            vim.notify(("Plugin spec %s did not return a Plugin instance"):format(file), vim.log.levels.WARN)
        end

        ::continue::
    end


    -- 3) lazy.nvim 配置
    local icons = {
        kind = icons_mod.get("kind"),
        documents = icons_mod.get("documents"),
        ui = icons_mod.get("ui"),
        ui_sep = icons_mod.get("ui", true),
        misc = icons_mod.get("misc"),
    }

    local clone_prefix = use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git"

    require("lazy").setup(specs, {
        root = data_dir .. "lazy",
        concurrency = 1,
        git = {
            timeout = 300,
            url_format = clone_prefix,
        },
        install = {
            missing = true,
            colorscheme = { settings.colorscheme },
        },
        ui = {
            size = { width = 0.88, height = 0.8 },
            wrap = true,
            border = "rounded",
            icons = {
                cmd = icons.misc.Code,
                config = icons.ui.Gear,
                event = icons.kind.Event,
                ft = icons.documents.Files,
                init = icons.misc.ManUp,
                import = icons.documents.Import,
                keys = icons.ui.Keyboard,
                loaded = icons.ui.Check,
                not_loaded = icons.misc.Ghost,
                plugin = icons.ui.Package,
                runtime = icons.misc.Vim,
                source = icons.kind.StaticMethod,
                start = icons.ui.Play,
                list = {
                    icons.ui_sep.BigCircle,
                    icons.ui_sep.BigUnfilledCircle,
                    icons.ui_sep.Square,
                    icons.ui_sep.ChevronRight,
                },
            },
        },
        performance = {
            cache = {
                enabled = true,
                path = vim.fn.stdpath("cache") .. "/lazy/cache",
                disable_events = { "UIEnter", "BufReadPre" },
                ttl = 3600 * 24 * 2,
            },
            reset_packpath = true,
            rtp = {
                reset = true,
                paths = {},
                disabled_plugins = {},
            },
        },
    })
end

return M
