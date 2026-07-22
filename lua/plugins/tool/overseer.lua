local Plugin = require("core.plugin")

local map_cmd = require("keymap.bind").map_cmd

return Plugin:new("stevearc/overseer.nvim")
    :lazy(true)
    :on("VeryLazy")
    :opts({})
    :lazy_keys({
        ["n|<leader>ow"] = map_cmd("<Cmd>OverseerToggle<CR>")
            :with_desc("overseer: Task list"),
        ["n|<leader>oo"] = map_cmd("<Cmd>OverseerRun<CR>")
            :with_desc("overseer: Run task"),
        ["n|<leader>oq"] = map_cmd("<Cmd>OverseerQuickAction<CR>")
            :with_desc("overseer: Action recent task"),
        ["n|<leader>oi"] = map_cmd("<Cmd>OverseerInfo<CR>")
            :with_desc("overseer: Overseer Info"),
        ["n|<leader>ob"] = map_cmd("<Cmd>OverseerBuild<CR>")
            :with_desc("overseer: Task builder"),
        ["n|<leader>ot"] = map_cmd("<Cmd>OverseerTaskAction<CR>")
            :with_desc("overseer: Task action"),
        ["n|<leader>oc"] = map_cmd("<Cmd>OverseerClearCache<CR>")
            :with_desc("overseer: Clear cache"),
    })
