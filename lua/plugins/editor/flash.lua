local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback

return Plugin:new("pedro757/flash.nvim")
    :on("VeryLazy")
    :branch("fix/neovim-0.13-search-state")
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
        ["nv|s"] = map_callback(function() require("flash").jump() end)
            :with_desc("flash: Jump"),
        ["nv|S"] = map_callback(function() require("flash").treesitter() end)
            :with_desc("flash: Treesitter"),
        ["o|r"] = map_callback(function() require("flash").remote() end)
            :with_desc("flash: Remote"),
        ["x|r"] = map_callback(function() require("flash").remote() end)
            :with_desc("flash: Remote"),
        ["o|R"] = map_callback(function() require("flash").treesitter_search() end)
            :with_desc("flash: TS Search"),
        ["x|R"] = map_callback(function() require("flash").treesitter_search() end)
            :with_desc("flash: TS Search"),
        ["c|<c-s>"] = map_callback(function() require("flash").toggle() end)
            :with_desc("flash: Toggle search"),
    })
