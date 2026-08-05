local Plugin = require("core.plugin")
local icons = { ui = require("utils.icons").get("ui", true) }

return Plugin:new("ibhagwan/fzf-lua")
    :lazy(true)
    :enabled(require("core.settings").search_backend == "fzf")
    :cmd("FzfLua")
    :opts({
        { "telescope" },
        defaults = {
            prompt = " " .. icons.ui.Telescope .. " ",
        },
    })
