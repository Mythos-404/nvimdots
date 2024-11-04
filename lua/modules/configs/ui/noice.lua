return function()
    local icons = {
        ui = require("modules.utils.icons").get("ui"),
        cmp = require("modules.utils.icons").get("cmp"),
        misc = require("modules.utils.icons").get("misc"),
    }

    require("noice").setup({
        lsp = {
            progress = { enabled = false },
            hover = { enabled = false },
            signature = { enabled = false },
            message = { enabled = false },
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        cmdline = {
            format = {
                input = {}, -- Used by input()
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = icons.misc.Help },
                filter = { pattern = "^:%s*!", icon = icons.misc.Shell, lang = "bash" },
                search_down = {
                    kind = "search",
                    pattern = "^/",
                    icon = ("%s "):format(icons.ui.Search),
                    lang = "regex",
                },
                search_up = {
                    kind = "search",
                    pattern = "^%?",
                    icon = ("%s "):format(icons.ui.Search),
                    lang = "regex",
                },
                lua = {
                    pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                    icon = icons.cmp.nvim_lua .. " ",
                    lang = "lua",
                },
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            long_message_to_split = true, -- long messages will be sent to a split
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "60%",
                },
            },
            cmdline_popupmenu = {
                position = {
                    row = "60%",
                },
            },
        },
    })
end
