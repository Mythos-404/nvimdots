return function()
    vim.g.haskell_tools = {
        tools = {
            repl = {
                handler = "toggleterm",
                auto_focus = true,
            },
            definition = {
                hoogle_signature_fallback = true,
            },
        },
    }
end
