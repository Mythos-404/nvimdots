return function()
    vim.g.maplocalleader = ","
    require("grug-far").setup({
        engine = "ripgrep",
        engines = {
            ripgrep = {
                path = "rg",
                showReplaceDiff = true,
                placeholders = {
                    enabled = true,
                },
            },
        },
        windowCreationCommand = "bot split",
        disableBufferLineNumbers = false,
        icons = {
            enabled = true,
        },
    })
end
