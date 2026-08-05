local Plugin = require("core.plugin")

return Plugin:new("mrcjkb/rustaceanvim")
    :lazy(true)
    :ft("rust")
    :version("*")
    :dep("nvim-lua/plenary.nvim")
    :init(function ()
        vim.g.rustaceanvim = {
            dap = {
                adapter = false,
                configuration = false,
                autoload_configurations = false,
            },
        }
    end)
