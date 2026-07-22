local Plugin = require("core.plugin")

return Plugin:new("romainl/vim-cool")
    :lazy(true)
    :on("CursorMoved", "InsertEnter")
