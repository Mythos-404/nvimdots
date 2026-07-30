local Plugin = require("core.plugin")

local map_cr = require("keymap.bind").map_cr
local icons = {
    ui = require("utils.icons").get("ui", true),
}


return Plugin:new("folke/trouble.nvim")
    :lazy(true)
    :cmd("Trouble", "TroubleToggle", "TroubleRefresh")
    :opts({
        auto_open = false,
        auto_close = false,
        auto_jump = false,
        auto_preview = true,
        auto_refresh = true,
        focus = false, -- do not focus the window when opened
        follow = true,
        restore = true,
        icons = {
            indent = {
                fold_open = icons.ui.ArrowOpen,
                fold_closed = icons.ui.ArrowClosed,
            },
            folder_closed = icons.ui.Folder,
            folder_open = icons.ui.FolderOpen,
        },
        modes = {
            project_diagnostics = {
                mode = "diagnostics",
                filter = {
                    any = {
                        {
                            function(item)
                                return item.filename:find(vim.fn.getcwd(), 1, true)
                            end,
                        },
                    },
                },
            },
        },
    })
    :lazy_keys({
        ["n|gt"] = map_cr("Trouble diagnostics toggle"):with_desc(
            "lsp: Toggle trouble list"),
        ["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
            :with_desc("lsp: Show workspace diagnostics"),
        ["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
            :with_desc("lsp: Show project diagnostics"),
        ["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
            :with_desc("lsp: Show document diagnostics"),
    })
