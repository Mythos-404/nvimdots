local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local xmake_keymap = {
    ["n|<leader>xr"] = map_cmd(":Xmake run"):with_noremap():with_desc("xmake: Run target"),
    ["n|<leader>xc"] = map_cmd(":Xmake clean"):with_noremap():with_desc("xmake: Clean target"),
    ["n|<leader>xd"] = map_cmd(":Xmake debug"):with_noremap():with_desc("xmake: Debug target"),
    ["n|<leader>xm"] = map_cmd(":Xmake mode"):with_noremap():with_desc("xmake: Switch buildmode"),
}

return function()
    require("xmake").setup({
        lsp = {
            language = "zh-cn",
        },
    })

    bind.nvim_load_mapping(xmake_keymap)
end
