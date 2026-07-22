local Plugin = require("core.plugin")

return Plugin:new("nvim-mini/mini.align")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :version(false)
    :opts({
        silent = true,
        mappings = {
            start = "gea",
            start_with_preview = "geA",
        },
    })
