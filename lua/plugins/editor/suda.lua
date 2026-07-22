local Plugin = require("core.plugin")

local map_cu = require("keymap.bind").map_cu

return Plugin:new("lambdalisue/suda.vim")
    :lazy(true)
    :cmd("SudaRead", "SudaWrite")
    :init(function(plugin)
        vim.g["suda#prompt"] = "Enter administrator password: "
    end)
    :lazy_keys({
        ["n|<A-s>"] = map_cu("SudaWrite"):with_desc("editn: Save file using sudo"),
    })
