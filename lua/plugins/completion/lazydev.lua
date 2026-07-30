local Plugin = require("core.plugin")

return Plugin:new("folke/lazydev.nvim")
    :lazy(true)
    :ft("lua")
    :opts({
        library = {
            "lazy.nvim",
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    })
