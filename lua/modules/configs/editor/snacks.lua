return function()
    require("snacks").setup({
        animate = {
            duration = 1, -- ms per step
            easing = "linear",
            fps = 150,
        },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 15, total = 250 },
                easing = "linear",
            },
            filter = function(buf)
                return vim.g.snacks_scroll ~= false
                    and vim.b[buf].snacks_scroll ~= false
                    and vim.bo[buf].buftype ~= "terminal"
            end,
        },
        words = { enabled = false },
        input = { enabled = true },
        indent = { enabled = false },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        dashboard = { enabled = false },
        statuscolumn = { enabled = false },
    })
end
