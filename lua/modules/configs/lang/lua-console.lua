return function()
    require("lua-console").setup({
        window = {
            border = "single", -- single|double|rounded
            height = 0.25,
        },
        mappings = {
            toggle = "`",
            quit = "q",
            eval = "<CR>",
            clear = "<C-l>",
            messages = "<C-m>",
            save = "S",
            load = "L",
            resize_up = "<C-Up>",
            resize_down = "<C-Down>",
            help = "?",
        },
    })
end
