local Plugin = require("core.plugin")
local map_cmd = require("keymap.bind").map_cmd

return Plugin:new("chrisgrieser/nvim-spider")
    :lazy(true)
    :on("VeryLazy")
    :lazy_keys({
        ["nox|w"] = map_cmd("<Cmd>lua require('spider').motion('w', { skipInsignificantPunctuation = false })<CR>")
            :with_noremap()
            :with_silent()
            :with_desc("Spider-w"),
        ["nox|e"] = map_cmd("<Cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>")
            :with_noremap()
            :with_silent()
            :with_desc("Spider-w"),
        ["nox|b"] = map_cmd("<Cmd>lua require('spider').motion('b')<CR>")
            :with_noremap()
            :with_silent()
            :with_desc("Spider-w"),
    })
