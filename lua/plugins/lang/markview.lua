local Plugin = require("core.plugin")

return Plugin:new("OXY2DEV/markview.nvim")
    :lazy(false)
    :opts({
        preview = {
            enable = true,
            filetypes = {
                "markdown",
                "quarto",
                "rmd",
                "typst",
                "asciidoc",
                "latex",
                "yaml",
                "html",
            },
            debounce = 100,
            modes = { "n", "no", "c" },
            hybrid_modes = { "n", "no" },
            linewise_hybrid_mode = true,
            max_buf_lines = 2000,
        },
    })
