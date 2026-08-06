local Plugin = require("core.plugin")

return Plugin:new("mrcjkb/haskell-tools.nvim")
    :lazy(false)
    :init(function ()
        vim.g.haskell_tools = {
            tools = {
                repl = {
                    handler = "builtin",
                    auto_focus = true,
                },
                definition = {
                    hoogle_signature_fallback = true,
                },
            },
        }
    end)
