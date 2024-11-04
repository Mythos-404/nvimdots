return function()
    require("nvim-ts-autotag").setup({
        opts = {
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = true, -- Auto close on trailing </
        },
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "xml",
        },
    })
end
