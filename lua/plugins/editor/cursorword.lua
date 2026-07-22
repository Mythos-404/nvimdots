local Plugin = require("core.plugin")

return Plugin:new("nvim-mini/mini.cursorword")
    :lazy(true)
    :on("BufReadPost", "BufAdd", "BufNewFile")
    :version(false)
    :config(function(plugin, opts)
        require("mini.cursorword").setup({
            -- Delay (in ms) between when cursor moved and when highlighting appeared
            delay = 200,
        })

        require("utils").gen_cursorword_hl()
    end)
