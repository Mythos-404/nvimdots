return function()
    require("quicker").setup({
        edit = {
            -- Enable editing the quickfix like a normal buffer
            enabled = true,
            -- Set to true to write buffers after applying edits.
            -- Set to "unmodified" to only write unmodified buffers.
            autosave = "unmodified",
        },
        -- Keep the cursor to the right of the filename and lnum columns
        constrain_cursor = true,
        highlight = {
            -- Use treesitter highlighting
            treesitter = true,
            -- Use LSP semantic token highlighting
            lsp = true,
            -- Load the referenced buffers to apply more accurate highlights (may be slow)
            load_buffers = false,
        },
        -- Trim the leading whitespace from results
        trim_leading_whitespace = true,
    })
end
