local Plugin = require("core.plugin")

local icons = {
    kind = require("utils.icons").get("kind"),
    type = require("utils.icons").get("type"),
    cmp = require("utils.icons").get("cmp"),
}

local source_labels = {
    copilot = "[CPLT]",
    minuet = "[AI]",
    buffer = "[BUF]",
    lazydev = "[LAZY]",
    lsp = "[LSP]",
    path = "[PATH]",
    ripgrep = "[RG]",
    latex_symbols = "[LTEX]",
    snippets = "[SNIP]",
    spell = "[SPELL]",
}

local sources_default = { "lazydev", "lsp", "snippets", "path", "buffer", "ripgrep", "spell", "latex_symbols" }

return Plugin:new("saghen/blink.cmp")
    :lazy(true)
    :on("VeryLazy", "InsertEnter", "CmdlineEnter")
    :version("1.*")
    :dep(Plugin:new("saghen/blink.compat"):version("2.*"):opts({}))
    :dep(Plugin:new("L3MON4D3/LuaSnip")
        :build("make install_jsregexp"))
    :dep("f3fora/cmp-spell")
    :dep("kdheepak/cmp-latex-symbols")
    :dep("mikavilpas/blink-ripgrep.nvim")
    :dep("xzbdmw/colorful-menu.nvim")
    :opts({
        snippets = { preset = "luasnip" },
        cmdline = {
            enabled = true,
            sources = function()
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                if type == ":" or type == "@" then
                    return { "cmdline", "path" }
                end
                return {}
            end,
            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-y>"] = { "select_and_accept", "fallback" },
                ["<C-e>"] = { "cancel", "fallback" },
                ["<CR>"] = { "accept_and_enter", "fallback" },
            },
            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                menu = {
                    auto_show = true,
                    draw = {
                        columns = {
                            { "label",      "label_description", gap = 1 },
                            { "kind_icon",  "kind",              gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                ghost_text = { enabled = false },
            },
        },
        term = { enabled = false },
        appearance = { nerd_font_variant = "normal" },
        fuzzy = { implementation = "prefer_rust_with_warning" },

        sources = {
            default = sources_default,
            providers = {
                lsp = { max_items = 350 },
                lazydev = {
                    module = "lazydev.integrations.blink",
                    name = "LazyDev",
                    score_offset = 100,
                    enabled = function()
                        return vim.bo.filetype == "lua"
                    end,
                },
                buffer = {
                    opts = {
                        get_bufnrs = function()
                            return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
                        end,
                    },
                },
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "Ripgrep",
                    opts = {
                        prefix_min_len = 3,
                        backend = {
                            use = "gitgrep-or-ripgrep",
                            ripgrep = {
                                max_filesize = "200K",
                                context_size = 3,
                                additional_rg_options = { "--max-count=5" },
                            },
                        },
                    },
                    score_offset = -15,
                    max_items = 3,
                },
                spell = {
                    name = "Spell",
                    module = "blink.compat.source",
                    opts = { cmp_name = "spell" },
                },
                latex_symbols = {
                    name = "LaTeX",
                    module = "blink.compat.source",
                    opts = { cmp_name = "latex_symbols" },
                },
            },
        },

        keymap = {
            preset = "none",

            ["<Tab>"] = { "select_next", "snippet_forward", "fallback", },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback", },

            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<C-w>"] = { "cancel", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },

        completion = {
            keyword = {
                range = "full",
            },
            accept = {
                auto_brackets = {
                    enabled = true,
                    kind_resolution = {
                        enabled = true,
                    },
                    semantic_token_resolution = {
                        enabled = true,
                        blocked_filetypes = { "java" },
                    },
                },
            },
            ghost_text = { enabled = true },
            list = {
                max_items = 120,
                selection = { preselect = false, auto_insert = false },
            },
            menu = {
                border = "single",
                winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:PmenuSel",
                scrollbar = false,
                draw = {
                    padding = { 1, 1 },
                    columns = {
                        { "label",    "label_description", gap = 1 },
                        { "kind_icon" },
                        { "kind",     "source_name",       gap = 1 },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
                                return icons.cmp[ctx.source_id] or lspkind_icons[ctx.kind] or icons.cmp.undefined
                            end,
                        },
                        kind = {
                            text = function(ctx)
                                return ctx.kind or ""
                            end,
                            highlight = function(ctx)
                                return ctx.kind
                            end,
                        },
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                        source_name = {
                            text = function(ctx)
                                return source_labels[ctx.source_id] or "[BTN]"
                            end,
                            highlight = "Comment",
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                treesitter_highlighting = true,
                window = {
                    border = "single",
                    winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
                },
            },
        },
        signature = {
            enabled = true,
            trigger = {
                show_on_insert = true,
            },
            window = {
                border = "single",
                treesitter_highlighting = true,
                show_documentation = true,
            },
        },
    })
