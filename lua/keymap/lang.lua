local bind = require("keymap.bind")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local plug_map = {
    -- Plugin MarkdownPreview
    ["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
    ["n|<F11>"] = map_callback(function()
            require("osv").launch({ port = 8086 })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Open OSV"),

    -- Plugin: lua-console.nvim
    ["n|`"] = map_callback(function()
            require("lua-console").toggle_console()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Open lua console"),
}

bind.nvim_load_mapping(plug_map)
