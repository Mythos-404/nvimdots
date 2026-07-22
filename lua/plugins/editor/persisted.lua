local Plugin = require("core.plugin")
local map_cu = require("keymap.bind").map_cu

return Plugin:new("olimorris/persisted.nvim"):
    lazy(true)
    :cmd(
        "SessionToggle",
        "SessionStart",
        "SessionStop",
        "SessionSave",
        "SessionLoad",
        "SessionLoadLast",
        "SessionLoadFromFile",
        "SessionDelete"
    )
    :opts({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
        autostart = true,
        autoload = false,
        follow_cwd = true,
        use_git_branch = true,
    })
    :lazy_keys({
        ["n|<leader>ss"] = map_cu("SessionSave"):with_desc("session: Save"),
        ["n|<leader>sl"] = map_cu("SessionLoad"):with_desc("session: Load current"),
        ["n|<leader>sd"] = map_cu("SessionDelete"):with_desc("session: Delete"),
    })
