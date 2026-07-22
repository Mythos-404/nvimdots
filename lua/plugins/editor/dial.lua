local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback
local map_cmd = require("keymap.bind").map_cmd

return Plugin:new("monaqa/dial.nvim")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :dep("nvim-lua/plenary.nvim")
    :config(function(plugin, opts)
        local augend = require("dial.augend")
        local augends = {
            augend.date.alias["%Y/%m/%d"],
            augend.date.alias["%Y-%m-%d"],
            augend.date.alias["%Y年%-m月%-d日"],
            augend.date.alias["%H:%M"],

            augend.integer.alias.decimal_int,
            augend.integer.alias.hex,    -- nonnegative hex number  (0x00, 0x1a1f, etc.)
            augend.integer.alias.octal,  -- nonnegative octal number  (0o00, 0o24, etc.)
            augend.integer.alias.binary, -- nonnegative hex number  (0b01, 0b10010, etc.)

            augend.semver.alias.semver,

            augend.constant.alias.bool,
            augend.constant.new({ elements = { "True", "False" } }),
            augend.constant.new({ elements = { "enable", "disable" } }),
            augend.constant.new({ elements = { "yes", "no" } }),
            augend.constant.new({ elements = { "&&", "||" } }),
            augend.constant.new({ elements = { "and", "or" } }),

            augend.hexcolor.new({ case = "lower" }),
        }

        require("dial.config").augends:register_group({
            -- default augends used when no group name is specified
            default = augends,
            visual = augends,

            extra = {
                augend.case.new({
                    types = { "snake_case", "camelCase", "PascalCase" },
                    cyclic = true,
                }),
            },
        })
    end)
    :lazy_keys({
        ["n|<C-a>"] = map_callback(function()
            require("dial.map").manipulate("increment", "normal")
        end),
        ["n|<C-x>"] = map_callback(function()
            require("dial.map").manipulate("decrement", "normal")
        end),
        ["v|<C-a>"] = map_callback(function()
            require("dial.map").manipulate("increment", "visual")
        end),
        ["v|<C-x>"] = map_callback(function()
            require("dial.map").manipulate("decrement", "visual")
        end),
        ["n|g<C-a>"] = map_callback(function()
            require("dial.map").manipulate("increment", "gnormal")
        end),
        ["n|g<C-x>"] = map_callback(function()
            require("dial.map").manipulate("decrement", "gnormal")
        end),
        ["v|g<C-a>"] = map_callback(function()
            require("dial.map").manipulate("increment", "gvisual")
        end),
        ["v|g<C-x>"] = map_callback(function()
            require("dial.map").manipulate("decrement", "gvisual")
        end),
        ["n|<A-C-a>"] = map_cmd(
            [[<Cmd>lua require"dial.command".select_augend_normal("extra")<CR><Cmd>let &opfunc="dial#operator#increment_normal"<CR>g@<Cmd>lua require("dial.command").textobj()<CR>]] --> INJECT: lua
        ):with_noremap(),
        ["n|<A-C-x>"] = map_cmd(
            [[<Cmd>lua require"dial.command".select_augend_normal("extra")<CR><Cmd>let &opfunc="dial#operator#decrement_normal"<CR>g@<Cmd>lua require("dial.command").textobj()<CR>]] --> INJECT: lua
        ):with_noremap(),
    })
