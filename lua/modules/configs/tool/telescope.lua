return function()
    local icons = { ui = require("modules.utils.icons").get("ui", true) }

    require("telescope").setup({
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            },
            initial_mode = "insert",
            prompt_prefix = " " .. icons.ui.Telescope .. " ",
            selection_caret = icons.ui.ChevronRight,
            scroll_strategy = "limit",
            results_title = false,
            layout_strategy = "horizontal",
            path_display = { "absolute" },
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            color_devicons = true,
            file_ignore_patterns = { ".git/", ".cache", "build/", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.85,
                height = 0.92,
                preview_cutoff = 120,
            },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
        extensions = {
            aerial = {
                show_lines = false,
                show_nesting = {
                    ["_"] = false, -- This key will be the default
                    lua = true, -- You can set the option for specific filetypes
                },
            },
            fzf = {
                fuzzy = false,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            frecency = {
                use_sqlite = false,
                show_scores = true,
                show_unindexed = true,
                ignore_patterns = { "*.git/*", "*/tmp/*" },
            },
            egrepify = {
                lnum = true,
                col = false,
                results_ts_hl = true,
                prefixes = {
                    -- ADDED ! to invert matches
                    -- example prompt: ! sorter
                    -- matches all lines that do not comprise sorter
                    -- rg --invert-match -- sorter
                    ["!"] = {
                        flag = "invert-match",
                    },

                    -- #$REMAINDER
                    -- # is caught prefix
                    -- `input` becomes $REMAINDER
                    -- in the above example #lua,md -> input: lua,md
                    ["#"] = {
                        flag = "glob",
                        cb = function(input)
                            return string.format([[*.{%s}]], input)
                        end,
                    },

                    -- filter for (partial) folder names
                    -- example prompt: >conf $MY_PROMPT
                    -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
                    -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
                    [">"] = {
                        flag = "glob",
                        cb = function(input)
                            return string.format([[**/{%s}*/**]], input)
                        end,
                    },

                    -- filter for (partial) file names
                    -- example prompt: &egrep $MY_PROMPT
                    -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
                    -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
                    ["&"] = {
                        flag = "glob",
                        cb = function(input)
                            return string.format([[*{%s}*]], input)
                        end,
                    },
                },
            },
            undo = {
                use_delta = true,
                use_custom_command = { "sh", "-c", "echo '$DIFF' | delta" },
                side_by_side = false,
                mappings = {
                    i = {
                        ["<cr>"] = require("telescope-undo.actions").yank_additions,
                        ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                        ["<C-cr>"] = require("telescope-undo.actions").restore,
                    },
                },
            },
            advanced_git_search = {
                -- fugitive or diffview
                diff_plugin = "diffview",
                -- customize git in previewer
                -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
                git_flags = { "-c", "delta.side-by-side=true" },
                entry_default_author_or_date = "author", -- one of "author" or "date"
                keymaps = {
                    -- following keymaps can be overridden
                    toggle_date_author = "<C-w>",
                    open_commit_in_browser = "<C-o>",
                    copy_commit_hash = "<C-y>",
                    show_entire_commit = "<C-e>",
                },
            },
        },
    })

    require("telescope").load_extension("frecency")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("egrepify")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("undo")
    require("telescope").load_extension("zoxide")
    require("telescope").load_extension("persisted")
    require("telescope").load_extension("aerial")
    require("telescope").load_extension("advanced_git_search")
end
