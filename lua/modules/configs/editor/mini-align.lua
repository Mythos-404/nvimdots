return function()
    require("mini.align").setup({
        -- Whether to disable showing non-error feedback
        silent = false,
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            start_with_preview = "gea",
        },
    })
end
