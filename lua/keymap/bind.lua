---@class map_rhs_options
---@field noremap boolean
---@field silent boolean
---@field expr boolean
---@field nowait boolean
---@field callback? function
---@field desc string

---@class map_rhs
---@field cmd string
---@field options map_rhs_options
---@field buffer false|integer
local rhs_options = {}

---@return map_rhs
function rhs_options:new()
    local instance = {
        cmd = "",
        options = {
            noremap = true,
            silent = true,
            expr = false,
            nowait = false,
            callback = nil,
            desc = "",
        },
        buffer = false,
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cmd(cmd_string)
    self.cmd = cmd_string
    return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cr(cmd_string)
    self.cmd = (":%s<CR>"):format(cmd_string)
    return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_args(cmd_string)
    self.cmd = (":%s<Space>"):format(cmd_string)
    return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cu(cmd_string)
    -- <C-u> to eliminate the automatically inserted range in visual mode
    self.cmd = (":<C-u>%s<CR>"):format(cmd_string)
    return self
end

---@param callback fun():any
---Takes a callback that will be called when the key is pressed
---@return map_rhs
function rhs_options:map_callback(callback)
    self.cmd = ""
    self.options.callback = callback
    return self
end

---@return map_rhs
function rhs_options:with_silent()
    self.options.silent = true
    return self
end

---@return map_rhs
function rhs_options:with_noisy()
    self.options.silent = false
    return self
end

---@param description_string string
---@return map_rhs
function rhs_options:with_desc(description_string)
    self.options.desc = description_string
    return self
end

---@return map_rhs
function rhs_options:with_noremap()
    self.options.noremap = true
    return self
end

---@return map_rhs
function rhs_options:with_remap()
    self.options.noremap = false
    return self
end

---@return map_rhs
function rhs_options:with_expr()
    self.options.expr = true
    return self
end

---@return map_rhs
function rhs_options:with_nowait()
    self.options.nowait = true
    return self
end

---@param num integer
---@return map_rhs
function rhs_options:with_buffer(num)
    self.buffer = num
    return self
end

---@class ParsedKey
---@field modes string[]
---@field lhs string

---@class keymap_bind
---@field map_cr fun(cmd_string: string): map_rhs
---@field map_cmd fun(cmd_string: string): map_rhs
---@field map_cu fun(cmd_string: string): map_rhs
---@field map_args fun(cmd_string: string): map_rhs
---@field map_callback fun(callback: fun(): any): map_rhs
---@field escape_termcode fun(cmd_string: string): string
---@field parse_key fun(key: string): ParsedKey
---@field builder_to_keymap fun(builder: map_rhs, context?: string): { rhs: string|function, opts: table }
---@field nvim_load_mapping fun(mapping: table<string, map_rhs>)

---@type keymap_bind
---@diagnostic disable-next-line: missing-fields
local bind = {}

---@param cmd_string string
---@return map_rhs
function bind.map_cr(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cr(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_cmd(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cmd(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_cu(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cu(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_args(cmd_string)
    local ro = rhs_options:new()
    return ro:map_args(cmd_string)
end

---@param callback fun():any
---@return map_rhs
function bind.map_callback(callback)
    local ro = rhs_options:new()
    return ro:map_callback(callback)
end

---@param cmd_string string
---@return string escaped_string
function bind.escape_termcode(cmd_string)
    return vim.api.nvim_replace_termcodes(cmd_string, true, true, true)
end

---Parse `"mode|lhs"` keys. Modes may be multi-char, e.g. `"nv|ga"`, `"ox|ih"`.
---@param key string
---@return ParsedKey
function bind.parse_key(key)
    if type(key) ~= "string" then
        error(("Plugin key must be a string like 'mode|lhs', got %s"):format(type(key)))
    end

    local modes_str, lhs = key:match("^([^|]+)|(.+)$")
    if not modes_str or modes_str == "" or not lhs or lhs == "" then
        error(("Invalid plugin key %q, expected 'mode|lhs'"):format(key))
    end

    ---@type string[]
    local modes = {}
    for mode_char in modes_str:gmatch(".") do
        if not mode_char:match("[nvsxoictl!]") then
            error(("Invalid mode %q in plugin key %q"):format(mode_char, key))
        end
        table.insert(modes, mode_char)
    end

    return { modes = modes, lhs = lhs }
end

---Resolve a key builder into its rhs and `vim.keymap.set` options.
---Shared by `nvim_load_mapping` and `Plugin:lazy_keys` so both paths
---validate and convert builders identically.
---@param builder map_rhs
---@param context? string  Used in error messages, e.g. the "mode|lhs" key.
---@return { rhs: string|function, opts: table }
function bind.builder_to_keymap(builder, context)
    context = context or "?"
    if type(builder) ~= "table" or type(builder.options) ~= "table" then
        error(("Invalid key builder for %q, expected keymap.bind map_* result"):format(context))
    end

    -- Prefer callback when present (map_callback); otherwise use cmd string.
    local rhs
    if builder.options.callback ~= nil then
        rhs = builder.options.callback
    elseif builder.cmd and builder.cmd ~= "" then
        rhs = builder.cmd
    else
        error(("Invalid key builder for %q, missing rhs command or callback"):format(context))
    end
    if type(rhs) ~= "string" and type(rhs) ~= "function" then
        error(("Invalid rhs for %q, expected string or function"):format(context))
    end

    local opts = {
        noremap = builder.options.noremap and true or false,
        silent = builder.options.silent and true or false,
        expr = builder.options.expr and true or false,
        nowait = builder.options.nowait and true or false,
    }
    if builder.options.desc and builder.options.desc ~= "" then
        opts.desc = builder.options.desc
    end
    if builder.buffer and type(builder.buffer) == "number" then
        opts.buffer = builder.buffer
    end
    return { rhs = rhs, opts = opts }
end

---@param mapping table<string, map_rhs>
function bind.nvim_load_mapping(mapping)
    for key, value in pairs(mapping) do
        local parsed = bind.parse_key(key)
        local resolved = bind.builder_to_keymap(value, key)

        for _, mode in ipairs(parsed.modes) do
            vim.keymap.set(mode, parsed.lhs, resolved.rhs, resolved.opts)
        end
    end
end

return bind
