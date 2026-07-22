local Plugin = require("core.plugin")

local map_cu = require("keymap.bind").map_cu

return Plugin:new("mrjones2014/smart-splits.nvim")
    :lazy(true)
    :on("CursorHoldI", "CursorHold")
    :opts({
        -- Ignored buffer types (only while resizing)
        ignored_buftypes = {
            "nofile",
            "quickfix",
            "prompt",
        },
        -- Ignored filetypes (only while resizing)
        ignored_filetypes = { "NvimTree" },
        -- the default number of lines/columns to resize by at a time
        default_amount = 3,
    })
    :lazy_keys({
        ["n|<A-h>"] = map_cu("SmartResizeLeft"):with_desc("window: Resize -3 horizontally"),
        ["n|<A-j>"] = map_cu("SmartResizeDown"):with_desc("window: Resize -3 vertically"),
        ["n|<A-k>"] = map_cu("SmartResizeUp"):with_desc("window: Resize +3 vertically"),
        ["n|<A-l>"] = map_cu("SmartResizeRight"):with_desc("window: Resize +3 horizontally"),
        ["n|<C-h>"] = map_cu("SmartCursorMoveLeft"):with_desc("window: Focus left"),
        ["n|<C-j>"] = map_cu("SmartCursorMoveDown"):with_desc("window: Focus down"),
        ["n|<C-k>"] = map_cu("SmartCursorMoveUp"):with_desc("window: Focus up"),
        ["n|<C-l>"] = map_cu("SmartCursorMoveRight"):with_desc("window: Focus right"),
        ["n|<leader>Wh"] = map_cu("SmartSwapLeft"):with_desc("window: Move window leftward"),
        ["n|<leader>Wj"] = map_cu("SmartSwapDown"):with_desc("window: Move window downward"),
        ["n|<leader>Wk"] = map_cu("SmartSwapUp"):with_desc("window: Move window upward"),
        ["n|<leader>Wl"] = map_cu("SmartSwapRight"):with_desc("window: Move window rightward"),
    })
