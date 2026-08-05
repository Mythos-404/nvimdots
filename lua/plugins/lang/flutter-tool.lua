local Plugin = require("core.plugin")

return Plugin:new("akinsho/flutter-tools.nvim")
    :lazy(true)
    :ft("dart")
    :dep("nvim-lua/plenary.nvim")
