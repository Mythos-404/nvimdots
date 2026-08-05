local Plugin = require("core.plugin")
local map_cmd = require("keymap.bind").map_cmd

return Plugin:new("barrettruth/preview.nvim")
    :lazy(true)
    :ft("markdown")
    :opts({
        github = true,
    })
    :lazy_keys({
        ["n|<F12>"] = map_cmd("<Cmd>Preview<CR>")
            :with_desc("tool: Toggle document preview"),
    })
