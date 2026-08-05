local Plugin = require("core.plugin")
local map_cu = require("keymap.bind").map_cu
local map_cmd = require("keymap.bind").map_cmd

return Plugin:new("nvim-treesitter/nvim-treesitter")
    :lazy(false)
    :branch("main")
    :build(function()
        if #vim.api.nvim_list_uis() > 0 then
            vim.api.nvim_command([[TSUpdate]])
        end
    end)
    :config(function(plugin, opts)
        vim.schedule(function()
            vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {})

            require("nvim-treesitter").setup(opts or {})

            require("nvim-treesitter").install(require("core.settings").treesitter_deps)
        end)
    end)
    :dep(Plugin:new("mfussenegger/nvim-treehopper"):lazy_keys({
        ["o|m"] = map_cu("lua require('tsht').nodes()"):with_desc("jump: Operate across syntax tree")
    }))
    :dep("nvim-treesitter/nvim-treesitter-textobjects")
    :dep(Plugin:new("danymat/neogen")
        :opts({
            enabled = true,
            snippet_engine = "luasnip",
            languages = {
                python = {
                    template = {
                        annotation_convention = "reST",
                    },
                },
            },
        })
        :lazy_keys({
            ["n|gcd"] = map_cmd("<Cmd>lua require('neogen').generate()<CR>")
                :with_desc("editor: Add documentation comments"),
        }))
    :dep(Plugin:new("andymass/vim-matchup")
        :init(function(plugin)
            vim.g.matchup_transmute_enabled = 1
            vim.g.matchup_surround_enabled = 1
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end))
    :dep(Plugin:new("windwp/nvim-ts-autotag")
        :opts({
            opts = {
                enable_close = true,          -- Auto close tags
                enable_rename = true,         -- Auto rename pairs of tags
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
        }))
    :dep(Plugin:new("hiphish/rainbow-delimiters.nvim")
        :init(function(plugin)
            ---@param threshold number @Use global strategy if nr of lines exceeds this value
            local function init_strategy(threshold)
                return function()
                    -- Disable on very large files
                    local line_count = vim.api.nvim_buf_line_count(0)
                    if line_count > 15000 then return nil end

                    -- Disable on parser error
                    local errors = 200
                    vim.treesitter.get_parser():for_each_tree(function(lt)
                        if lt:root():has_error() and errors >= 0 then errors = errors - 1 end
                    end)
                    if errors < 0 then return nil end

                    return line_count > threshold and require("rainbow-delimiters").strategy["global"]
                        or require("rainbow-delimiters").strategy["local"]
                end
            end

            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = init_strategy(500),
                    c = init_strategy(200),
                    cpp = init_strategy(200),
                    lua = init_strategy(500),
                    vimdoc = init_strategy(300),
                    vim = init_strategy(300),
                },
                query = {
                    [""] = "rainbow-delimiters",
                    latex = "rainbow-blocks",
                    javascript = "rainbow-delimiters-react",
                },
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterViolet",
                },
                blacklist = {
                    "comment",
                    "zig",
                },
            }
        end))
    :dep(Plugin:new("brenoprata10/nvim-highlight-colors")
        :opts({
            render = "background",
            enable_hex = true,
            enable_short_hex = true,
            enable_rgb = true,
            enable_hsl = true,
            enable_var_usage = true,
            enable_named_colors = false,
            enable_tailwind = false,
            -- Exclude filetypes or buftypes from highlighting
            exclude_filetypes = {
                "alpha",
                "bigfile",
                "dap-repl",
                "fugitive",
                "git",
                "notify",
                "NvimTree",
                "Outline",
                "TelescopePrompt",
                "toggleterm",
                "undotree",
            },
            exclude_buftypes = {
                "nofile",
                "prompt",
                "terminal",
            },
        }))
    :dep(Plugin:new("nvim-treesitter/nvim-treesitter-context")
        :opts({
            enable = true,
            line_numbers = true,
            max_lines = 3,
            min_window_height = 0,
            multiline_threshold = 20,
            trim_scope = "outer",
            mode = "cursor",
            zindex = 50,
        }))
    :dep(Plugin:new("JoosepAlviste/nvim-ts-context-commentstring")
        :config(function(plugin, opts)
            vim.g.skip_ts_context_commentstring_module = true
            require("ts_context_commentstring").setup({
                -- Whether to update the `commentstring` on the `CursorHold` autocmd
                enable_autocmd = false,
            })
        end))
