local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback

local P = Plugin:new("folke/flash.nvim")
    :on("VeryLazy")
    :opts({
        labels = "asdfghjklqwertyuiopzxcvbnm",
        label = {
            uppercase = true,
            current = true,
            distance = true,
        },
        modes = {
            search = { enabled = false },
            char = {
                enabled = true,
                autohide = false,
                jump_labels = false,
                multi_line = true,
                label = { exclude = "hjkliardc" },
            },
        },
    })
    :lazy_keys({
        ["n|s"] = map_callback(function() require("flash").jump() end)
            :with_noremap():with_silent():with_desc("flash: Jump"),
        ["n|S"] = map_callback(function() require("flash").treesitter() end)
            :with_noremap():with_silent():with_desc("flash: Treesitter"),
        ["o|r"] = map_callback(function() require("flash").remote() end)
            :with_noremap():with_silent():with_desc("flash: Remote"),
        ["x|r"] = map_callback(function() require("flash").remote() end)
            :with_noremap():with_silent():with_desc("flash: Remote"),
        ["o|R"] = map_callback(function() require("flash").treesitter_search() end)
            :with_noremap():with_silent():with_desc("flash: TS Search"),
        ["x|R"] = map_callback(function() require("flash").treesitter_search() end)
            :with_noremap():with_silent():with_desc("flash: TS Search"),
    })

return P
