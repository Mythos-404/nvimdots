local Plugin = require("core.plugin")


return Plugin:new("nvim-mini/mini.icons")
    :version(false)
    :config(function(plugin, opts)
        require("mini.icons").setup({
            extension = {
                ["scm"] = { glyph = "󰐅", hl = "MiniIconsGreen" },
            },
        })

        require("mini.icons").mock_nvim_web_devicons()
    end)
