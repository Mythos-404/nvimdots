local M = {}

---Whether this path is a plugin entry (not a helper under a package).
---Entries:
---  plugins/<name>.lua
---  plugins/<cat>/<name>.lua
---  plugins/<cat>/<name>/init.lua
---@param file string
---@return boolean
local function is_plugin_entry(file)
    local normalized = file:gsub("\\", "/")
    local rel = normalized:match("/lua/plugins/(.+)$")
    if not rel then return false end

    -- plugins/foo.lua
    if rel:match("^[^/]+%.lua$") then return true end
    -- plugins/cat/foo.lua
    if rel:match("^[^/]+/[^/]+%.lua$") then return true end
    -- plugins/cat/foo/init.lua  (package entry; helpers like foo/servers/x.lua are ignored)
    if rel:match("^[^/]+/[^/]+/init%.lua$") then return true end

    return false
end

---Map entry path under lua/plugins/ to a require module name.
---  .../plugins/editor/flash.lua      → "plugins.editor.flash"
---  .../plugins/completion/lsp/init.lua → "plugins.completion.lsp"
---@param file string
---@return string|nil
local function path_to_module(file)
    local normalized = file:gsub("\\", "/")
    local rel = normalized:match("/lua/(plugins/.+)%.lua$")
    if not rel then return nil end
    -- package: plugins/cat/name/init → plugins.cat.name
    rel = rel:gsub("/init$", "")
    return (rel:gsub("/", "."))
end

---@param basename string
---@return boolean
local function is_disabled_name(basename)
    return basename:match("^_")
        or basename:match("%.disabled%.lua$")
end

---Collect plugin entry files only (not recursive helpers).
---@param plugin_dir string
---@return string[]
local function collect_entry_files(plugin_dir)
    ---@type string[]
    local files = {}
    local patterns = {
        plugin_dir .. "/*.lua", -- plugins/foo.lua
        plugin_dir .. "/*/*.lua", -- plugins/cat/foo.lua
        plugin_dir .. "/*/*/init.lua", -- plugins/cat/foo/init.lua
    }
    for _, pat in ipairs(patterns) do
        for _, f in ipairs(vim.fn.glob(pat, true, true)) do
            table.insert(files, f)
        end
    end
    table.sort(files)
    return files
end

function M.setup()
    local global = require("core.global")
    local settings = require("core.settings")
    local icons_mod = require("utils.icons")

    local data_dir = global.data_dir
    local use_ssh = settings.use_ssh

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

    local plugin_dir = global.plugins_dir
    local files = collect_entry_files(plugin_dir)
    local specs = {}
    ---@type table<string, string>  modname → first file (detect dup flash.lua + flash/init.lua)
    local seen = {}

    for _, file in ipairs(files) do
        local basename = vim.fn.fnamemodify(file, ":t")
        local parent = vim.fn.fnamemodify(file, ":h:t")

        -- Disabled: _foo.lua / foo.disabled.lua / package dir _foo/
        if is_disabled_name(basename) or (basename == "init.lua" and parent:match("^_")) then
            goto continue
        end

        if not is_plugin_entry(file) then
            goto continue
        end

        local modname = path_to_module(file)
        if not modname then
            vim.notify(("Cannot map plugin path to module: %s"):format(file), vim.log.levels.ERROR)
            goto continue
        end

        if seen[modname] then
            vim.notify(
                ("Duplicate plugin module %s:\n  %s\n  %s"):format(modname, seen[modname], file),
                vim.log.levels.ERROR
            )
            goto continue
        end
        seen[modname] = file

        -- Fresh load each bootstrap (avoids stale package.loaded after :source)
        package.loaded[modname] = nil
        local ok, plugin = pcall(require, modname)
        if not ok then
            vim.notify(("Failed to load plugin spec %s (%s):\n%s"):format(modname, file, plugin), vim.log.levels.ERROR)
        elseif type(plugin) == "table" and plugin.to_spec then
            table.insert(specs, plugin:to_spec())
        else
            vim.notify(("Plugin spec %s did not return a Plugin instance"):format(modname), vim.log.levels.WARN)
        end

        ::continue::
    end


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
        concurrency = vim.uv.available_parallelism() / 2,
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
