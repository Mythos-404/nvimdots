local Plugin = require("core.plugin")

return Plugin:new("kevinhwang91/nvim-bqf")
    :lazy(true)
    :ft("qf")
    :dep(Plugin:new("junegunn/fzf"):build(":call fzf#install()"))
    :opts({
        preview = {
            border = "single",
            wrap = true,
            winblend = 0,
        },
    })
