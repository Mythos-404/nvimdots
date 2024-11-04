return function()
    require("cutlass").setup({
        cut_key = "X",
        exclude = {
            's"',
            "s'",
            "s[",
            "s]",
            "s<",
            "s>",

            "ndd",
            "xd",
        },
    })
    vim.api.nvim_set_keymap("n", "dd", "dd", { noremap = true })
end
