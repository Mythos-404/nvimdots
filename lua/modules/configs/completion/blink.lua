return function()
    local icons = {
        kind = require("modules.utils.icons").get("kind"),
        type = require("modules.utils.icons").get("type"),
        cmp = require("modules.utils.icons").get("cmp"),
    }

    require("blink.cmp").setup({
        appearance = { nerd_font_variant = "normal" },
        completion = {
            menu = {
                border = "single",
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "provider" },
                    },
                    components = {
                        provider = {
                            width = { max = 10 },
                            text = function(ctx)
                                ctx.item.source_name = ctx.item.source_name:lower()
                                local client = ctx.item.client_id
                                local lsp_name = client and vim.lsp.get_client_by_id(client).name
                                if ctx.item.source_name == "luasnip" then
                                    return "[SNI]"
                                elseif lsp_name == "emmet_language_server" then
                                    return "[EMT]"
                                else
                                    return "[" .. ctx.item.source_name:sub(1, 3):upper() .. "]"
                                end
                            end,
                            highlight = "BlinkCmpSource",
                        },
                        kind_icon = {
                            ellipsis = false,
                            text = function(ctx)
                                local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
                                return (lspkind_icons[ctx.kind] or icons.cmp.undefined) .. ctx.icon_gap
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = { border = "single" },
            },
            ghost_text = { enabled = true },
        },
        signature = {
            enabled = true,
            window = { border = "single" },
        },

        keymap = {
            preset = "none",
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-space>"] = { "show", "hide", "fallback" },
            ["<C-w>"] = { "cancel", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },
        },

        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then return require("luasnip").locally_jumpable() end
                return require("luasnip").in_snippet()
            end,
            jump = function(direction)
                require("luasnip").jump(direction)
            end,
        },

        sources = {
            default = { "lsp", "path", "luasnip", "buffer" },
        },
    })
end
