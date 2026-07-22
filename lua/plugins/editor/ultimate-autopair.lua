local Plugin = require("core.plugin")

return Plugin:new("altermo/ultimate-autopair.nvim")
    :lazy(true)
    :branch("v0.6")
    :on("InsertEnter", "CmdlineEnter")
    :config(function(plugin, opts)
        require("ultimate-autopair").init({
            require("ultimate-autopair").extend_default({
                tabout = {
                    enable = true,
                    hopout = true,
                },

                { "[=[", "]=]", ft = { "lua" } },
            }),
        })
    end)
