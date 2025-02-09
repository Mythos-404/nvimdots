return function()
    require("lua-console").setup({
        buffer = {
            autosave = false,
        },
        window = {
            border = "single",
            height = 0.25,
        },
        mappings = {
            toggle = "`",
            quit = "q",
            eval = "<CR>",
            eval_buffer = "<S-CR>",
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
