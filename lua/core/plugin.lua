-- ═══════════════════════════════════════════════════════════════
-- Plugin 基类
-- 每个插件 = 一个 Plugin 实例 = 声明 + 配置 + 键位
--
-- Recipes:
-- 1) 纯 opts + lazy keys (flash)
--    Plugin:new("user/repo"):on("VeryLazy"):opts({...}):lazy_keys({ ["n|s"] = map_callback(...):with_desc("...") })
-- 2) buffer-local keys
--    :local_keys("LspAttach", { ["n|K"] = map_cr(...):with_desc("...") })
--    :local_keys({ option = "on_attach" }, function(ctx, bind) return { ... } end)
-- 3) 多步初始化
--    优先 :opts；模块名不同用 :setup(fn)；必须完全自控时才用 :config(fn)
--    键位仍走 :lazy_keys / :local_keys，不要在 config 里手搓映射
-- ═══════════════════════════════════════════════════════════════

---@alias PluginKeyMap table<string, map_rhs>
---@alias PluginOpts table|fun(plugin: LazyPluginSpec, opts: table|nil): table|nil
---@alias PluginConfig fun(plugin: LazyPluginSpec, opts: table|nil)
---@alias PluginSetup fun(opts: table|nil)
---@alias PluginBuild string|string[]|fun(plugin: LazyPluginSpec)|false
---@alias PluginPredicate boolean|fun(plugin: LazyPluginSpec): boolean
---@alias PluginInit fun(plugin: LazyPluginSpec)

---@class LazyKeySpec
---@field [1] string
---@field [2] string|function
---@field mode string
---@field desc? string
---@field noremap? boolean
---@field silent? boolean
---@field expr? boolean
---@field nowait? boolean

---@class LazyPluginSpec
---@field [1] string
---@field name? string
---@field main? string
---@field lazy? boolean
---@field priority? number
---@field build? PluginBuild
---@field init? PluginInit
---@field enabled? PluginPredicate
---@field cond? PluginPredicate
---@field event? string|string[]
---@field cmd? string[]
---@field ft? string[]
---@field dependencies? table[]
---@field opts? table|function
---@field keys? LazyKeySpec[]
---@field config? PluginConfig
---@field version? string|boolean
---@field branch? string
---@field pin? boolean
---@field dir? string
---@field dev? boolean
---@field optional? boolean
---@field colorscheme? string|string[]

---@class PluginLocalKeySource
---@field event? string|string[]
---@field pattern? string|string[]
---@field option? "on_attach"

---@class PluginLocalKeyContext
---@field plugin Plugin
---@field source PluginLocalKeySource
---@field buf integer
---@field event? table
---@field args? table

---@alias PluginLocalKeyFactory fun(ctx: PluginLocalKeyContext, bind: keymap_bind): PluginKeyMap
---@alias PluginLocalKeySpec PluginKeyMap|PluginLocalKeyFactory

---@class PluginLocalKeyItem
---@field source string|PluginLocalKeySource
---@field map PluginLocalKeySpec

---@class NormalizeKeyOpts
---@field allow_buffer? boolean

---@class Plugin
---@field repo string
---@field _lazy boolean|nil
---@field _deps table[]
---@field _opts PluginOpts|nil
---@field _opts_set boolean
---@field _keys PluginKeyMap
---@field _local_keys PluginLocalKeyItem[]
---@field _event? string|string[]
---@field _cmd? string[]
---@field _ft? string[]
---@field _main? string
---@field _name? string
---@field _priority? number
---@field _build? PluginBuild
---@field _init? PluginInit
---@field _enabled? PluginPredicate
---@field _cond? PluginPredicate
---@field _config? PluginConfig
---@field _setup? PluginSetup
---@field _version? string|boolean
---@field _branch? string
---@field _pin? boolean
---@field _dir? string
---@field _dev? boolean
---@field _optional? boolean
---@field _colorscheme? string|string[]
---@field _raw? table
local Plugin = {}
Plugin.__index = Plugin

--------------------------------------------------------------------------------
-- 构造
--------------------------------------------------------------------------------

---@param repo string
---@return Plugin
function Plugin:new(repo)
    ---@type Plugin
    local plugin = setmetatable({
        repo = repo,
        _lazy = nil,
        _deps = {},
        _opts = nil,
        _opts_set = false,
        _keys = {},
        _local_keys = {},
        _raw = nil,
    }, self)
    return plugin
end

--------------------------------------------------------------------------------
-- 懒加载声明
--------------------------------------------------------------------------------

---@param ev string|string[]
---@return Plugin
function Plugin:on(ev)
    self._event = ev
    return self
end

---@param value boolean
---@return Plugin
function Plugin:lazy(value)
    self._lazy = value
    return self
end

---@return Plugin
function Plugin:start()
    self._lazy = false
    return self
end

---@param ... string
---@return Plugin
function Plugin:cmd(...)
    self._cmd = { ... }
    return self
end

---@param ... string
---@return Plugin
function Plugin:ft(...)
    self._ft = { ... }
    return self
end

---@param dep string|table|Plugin
---@return Plugin
function Plugin:dep(dep)
    if self._deps == nil then self._deps = {} end
    table.insert(self._deps, dep)
    return self
end

---@param value string
---@return Plugin
function Plugin:main(value)
    self._main = value
    return self
end

---@param value string
---@return Plugin
function Plugin:name(value)
    self._name = value
    return self
end

---@param value number
---@return Plugin
function Plugin:priority(value)
    self._priority = value
    return self
end

---@param value PluginBuild
---@return Plugin
function Plugin:build(value)
    self._build = value
    return self
end

---@param fn PluginInit
---@return Plugin
function Plugin:init(fn)
    self._init = fn
    return self
end

---@param value PluginPredicate
---@return Plugin
function Plugin:enabled(value)
    self._enabled = value
    return self
end

---@param value PluginPredicate
---@return Plugin
function Plugin:cond(value)
    self._cond = value
    return self
end

---@param value string|boolean
---@return Plugin
function Plugin:version(value)
    self._version = value
    return self
end

---@param value string
---@return Plugin
function Plugin:branch(value)
    self._branch = value
    return self
end

---@param value boolean
---@return Plugin
function Plugin:pin(value)
    self._pin = value
    return self
end

---@param value string
---@return Plugin
function Plugin:dir(value)
    self._dir = value
    return self
end

---@param value boolean
---@return Plugin
function Plugin:dev(value)
    self._dev = value
    return self
end

---@param value boolean
---@return Plugin
function Plugin:optional(value)
    self._optional = value
    return self
end

---@param value string|string[]
---@return Plugin
function Plugin:colorscheme(value)
    self._colorscheme = value
    return self
end

---Merge raw lazy.nvim fields into the final spec (wins last).
---@param tbl table
---@return Plugin
function Plugin:raw(tbl)
    if type(tbl) ~= "table" then
        error(("Plugin:raw expects a table, got %s"):format(type(tbl)))
    end
    self._raw = vim.tbl_deep_extend("force", self._raw or {}, tbl)
    return self
end

--------------------------------------------------------------------------------
-- 配置
-- 优先 :opts；模块名不同用 :setup；多步/完全自控才用 :config
-- :setup 与 :config 互斥
--------------------------------------------------------------------------------

---@param t PluginOpts
---@return Plugin
function Plugin:opts(t)
    self._opts = t
    self._opts_set = true
    return self
end

---自定义配置函数 (完全控制初始化流程，跳过默认的 require+setup)
---@param fn PluginConfig
---@return Plugin
function Plugin:config(fn)
    if self._setup then
        error(("Plugin %s: :setup and :config are mutually exclusive"):format(self.repo))
    end
    self._config = fn
    return self
end

---自定义 setup 函数 (替代默认 require(name).setup(opts))
---@param fn PluginSetup
---@return Plugin
function Plugin:setup(fn)
    if self._config then
        error(("Plugin %s: :setup and :config are mutually exclusive"):format(self.repo))
    end
    self._setup = fn
    return self
end

--------------------------------------------------------------------------------
-- 键位 (你的 "mode|lhs" 格式，完全保留)
--------------------------------------------------------------------------------

---注册全局 lazy-loading 键位
---@param map PluginKeyMap
---@return Plugin
function Plugin:lazy_keys(map)
    if type(map) ~= "table" then
        error(("Plugin:lazy_keys expects a table, got %s"):format(type(map)))
    end
    for key, builder in pairs(map) do
        self._keys[key] = builder
    end
    return self
end

---注册 buffer-local 键位。
---source:
---  "LspAttach" / "FileType" / ...       -> autocmd 事件
---  { event = "...", pattern = ... }      -> autocmd 事件 + pattern
---  { option = "on_attach" }              -> 注入 opts.on_attach(buf)
---@param source string|PluginLocalKeySource
---@param map_or_factory PluginLocalKeySpec
---@return Plugin
function Plugin:local_keys(source, map_or_factory)
    if type(map_or_factory) ~= "table" and type(map_or_factory) ~= "function" then
        error(("Plugin:local_keys map must be table or function, got %s"):format(type(map_or_factory)))
    end
    ---@type PluginLocalKeyItem
    local item = {
        source = source,
        map = map_or_factory,
    }
    table.insert(self._local_keys, item)
    return self
end

--------------------------------------------------------------------------------
-- 构建 lazy.nvim spec
--------------------------------------------------------------------------------

---将 rhs_options 实例转换为 lazy.nvim 的 keys 条目
---lazy.nvim 格式: { lhs, rhs, mode = "n", desc = "...", ... }
---@param lhs_key string  "mode|lhs"
---@param builder map_rhs
---@param opts NormalizeKeyOpts|nil
---@return LazyKeySpec[]
local function normalize_keys(lhs_key, builder, opts)
    opts = opts or {}
    local bind = require("keymap.bind")
    local parsed = bind.parse_key(lhs_key)

    if type(builder) ~= "table" or type(builder.options) ~= "table" then
        error(("Invalid key builder for %q, expected keymap.bind map_* result"):format(lhs_key))
    end

    if not opts.allow_buffer and builder.buffer and builder.buffer ~= false then
        error(("Plugin:lazy_keys(%q) cannot use buffer-local mappings; use Plugin:local_keys() instead"):format(lhs_key))
    end

    -- Prefer callback when present (map_callback); otherwise use cmd string.
    local rhs = builder.options.callback
    if rhs == nil and builder.cmd and builder.cmd ~= "" then
        rhs = builder.cmd
    end
    if rhs == nil then
        error(("Invalid key builder for %q, missing rhs command or callback"):format(lhs_key))
    end
    if type(rhs) ~= "string" and type(rhs) ~= "function" then
        error(("Invalid rhs for %q, expected string or function"):format(lhs_key))
    end

    local desc = builder.options.desc

    local base_opts = {}
    if desc and desc ~= "" then base_opts.desc = desc end
    if builder.options.noremap then base_opts.noremap = true end
    if builder.options.silent then base_opts.silent = true end
    if builder.options.expr then base_opts.expr = true end
    if builder.options.nowait then base_opts.nowait = true end

    ---@type LazyKeySpec[]
    local entries = {}
    for _, mode_char in ipairs(parsed.modes) do
        ---@type LazyKeySpec
        local entry = vim.tbl_extend("keep", { parsed.lhs, rhs, mode = mode_char }, base_opts)
        table.insert(entries, entry)
    end
    return entries
end

---@param builder map_rhs
---@param buf integer
---@return map_rhs
local function clone_builder_with_buffer(builder, buf)
    local cloned = vim.deepcopy(builder)
    cloned.buffer = buf
    return cloned
end

---@param map_or_factory PluginLocalKeySpec
---@param ctx PluginLocalKeyContext
---@return PluginKeyMap
local function resolve_local_key_map(map_or_factory, ctx)
    if type(map_or_factory) == "function" then
        return map_or_factory(ctx, require("keymap.bind"))
    end
    return map_or_factory
end

---@param map_or_factory PluginLocalKeySpec
---@param ctx PluginLocalKeyContext
local function load_local_key_map(map_or_factory, ctx)
    local mapping = resolve_local_key_map(map_or_factory, ctx)
    if type(mapping) ~= "table" then
        error(("local_keys for %s must return a mapping table"):format(ctx.plugin.repo))
    end

    local buffered = {}
    for lhs_key, builder in pairs(mapping) do
        if builder.buffer and builder.buffer ~= false and builder.buffer ~= ctx.buf then
            error(("Plugin:local_keys(%q) should not set buffer manually"):format(lhs_key))
        end
        normalize_keys(lhs_key, builder, { allow_buffer = true })
        buffered[lhs_key] = clone_builder_with_buffer(builder, ctx.buf)
    end

    require("keymap.bind").nvim_load_mapping(buffered)
end

---@param source string|PluginLocalKeySource
---@return PluginLocalKeySource
local function normalize_local_key_source(source)
    if type(source) == "string" then
        return { event = source }
    end
    if type(source) ~= "table" then
        error(("Plugin:local_keys source must be string or table, got %s"):format(type(source)))
    end
    if source.event ~= nil and type(source.event) ~= "string" and type(source.event) ~= "table" then
        error("Plugin:local_keys source.event must be string or table")
    end
    if source.option ~= nil and type(source.option) ~= "string" then
        error("Plugin:local_keys source.option must be string")
    end
    if source.event == nil and source.option == nil then
        error("Plugin:local_keys source must define event or option")
    end
    if source.event ~= nil and source.option ~= nil then
        error("Plugin:local_keys source cannot define both event and option")
    end
    return source
end

---@param args any
---@return integer|nil
local function get_attach_buffer(args)
    if type(args) ~= "table" then return args end
    return args.buf or args.bufnr or args.buffer or args[1]
end

---@param plugin Plugin
---@param user_init PluginInit|nil
---@param local_key_specs PluginLocalKeyItem[]
---@return PluginInit
local function compose_init(plugin, user_init, local_key_specs)
    return function(lazy_plugin)
        if user_init then user_init(lazy_plugin) end

        for idx, item in ipairs(local_key_specs) do
            local source = normalize_local_key_source(item.source)
            if source.event then
                vim.api.nvim_create_autocmd(source.event, {
                    group = vim.api.nvim_create_augroup(("PluginLocalKeys_%s_%d"):format(
                        (plugin.repo:gsub("[^%w_]", "_")),
                        idx
                    ), { clear = true }),
                    pattern = source.pattern,
                    callback = function(ev)
                        load_local_key_map(item.map, {
                            plugin = plugin,
                            source = source,
                            event = ev,
                            buf = ev.buf,
                        })
                    end,
                })
            end
        end
    end
end

---@param plugin Plugin
---@param opts table
---@param local_key_specs PluginLocalKeyItem[]
local function merge_on_attach(plugin, opts, local_key_specs)
    local original_on_attach = opts.on_attach

    opts.on_attach = function(...)
        if original_on_attach then original_on_attach(...) end

        local args = { ... }
        local buf = get_attach_buffer(args[1]) or get_attach_buffer(args[2])
        if type(buf) ~= "number" then
            error(("Plugin:local_keys({ option = 'on_attach' }) for %s could not resolve bufnr"):format(plugin.repo))
        end

        for _, item in ipairs(local_key_specs) do
            load_local_key_map(item.map, {
                plugin = plugin,
                source = item.source,
                args = args,
                buf = buf,
            })
        end
    end
end

---@param deps table[]
---@return table[]
local function expand_deps(deps)
    local out = {}
    for _, dep in ipairs(deps) do
        if type(dep) == "table" and type(dep.to_spec) == "function" then
            table.insert(out, dep:to_spec())
        else
            table.insert(out, dep)
        end
    end
    return out
end

---构建 lazy.nvim 兼容的 spec 表
---@return LazyPluginSpec
function Plugin:to_spec()
    local self = self

    if self._setup and self._config then
        error(("Plugin %s: :setup and :config are mutually exclusive"):format(self.repo))
    end

    ---@type PluginLocalKeyItem[]
    local autocmd_local_keys = {}
    ---@type PluginLocalKeyItem[]
    local option_local_keys = {}
    for _, item in ipairs(self._local_keys) do
        local source = normalize_local_key_source(item.source)
        if source.event then
            table.insert(autocmd_local_keys, { source = source, map = item.map })
        elseif source.option == "on_attach" then
            table.insert(option_local_keys, { source = source, map = item.map })
        else
            error(("Unsupported Plugin:local_keys option %q for %s"):format(source.option, self.repo))
        end
    end

    ---@type LazyKeySpec[]
    local lazy_keys = {}
    for lhs_key, builder in pairs(self._keys) do
        for _, entry in ipairs(normalize_keys(lhs_key, builder)) do
            table.insert(lazy_keys, entry)
        end
    end

    ---@type LazyPluginSpec
    local spec = { self.repo }

    if self._lazy ~= nil then spec.lazy = self._lazy end
    if self._name ~= nil then spec.name = self._name end
    if self._main ~= nil then spec.main = self._main end
    if self._priority ~= nil then spec.priority = self._priority end
    if self._build ~= nil then spec.build = self._build end
    if self._version ~= nil then spec.version = self._version end
    if self._branch ~= nil then spec.branch = self._branch end
    if self._pin ~= nil then spec.pin = self._pin end
    if self._dir ~= nil then spec.dir = self._dir end
    if self._dev ~= nil then spec.dev = self._dev end
    if self._optional ~= nil then spec.optional = self._optional end
    if self._colorscheme ~= nil then spec.colorscheme = self._colorscheme end
    if self._init ~= nil or #autocmd_local_keys > 0 then
        spec.init = compose_init(self, self._init, autocmd_local_keys)
    end
    if self._enabled ~= nil then spec.enabled = self._enabled end
    if self._cond ~= nil then spec.cond = self._cond end
    if self._event ~= nil then spec.event = self._event end
    if self._cmd ~= nil then spec.cmd = self._cmd end
    if self._ft ~= nil then spec.ft = self._ft end
    if self._deps and next(self._deps) then
        spec.dependencies = expand_deps(self._deps)
    end
    if self._opts_set or #option_local_keys > 0 then
        spec.opts = self._opts or {}
        if #option_local_keys > 0 then
            if type(spec.opts) == "function" then
                local user_opts = spec.opts
                spec.opts = function(plugin, opts)
                    local resolved = user_opts(plugin, opts) or opts or {}
                    merge_on_attach(self, resolved, option_local_keys)
                    return resolved
                end
            else
                merge_on_attach(self, spec.opts, option_local_keys)
            end
        end
    end
    if #lazy_keys > 0 then spec.keys = lazy_keys end

    if self._setup then
        spec.config = function(_, opts)
            self._setup(opts)
        end
    elseif self._config then
        spec.config = function(plugin, opts)
            self._config(plugin, opts)
        end
    end

    if self._raw then
        spec = vim.tbl_deep_extend("force", spec, self._raw)
        if not spec[1] then
            spec[1] = self.repo
        end
    end

    return spec
end

return Plugin
