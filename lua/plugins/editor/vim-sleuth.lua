local Plugin = require("core.plugin")

return Plugin:new("tpope/vim-sleuth")
    :lazy(true)
    :on("BufNewFile", "BufReadPost", "BufFilePost")
