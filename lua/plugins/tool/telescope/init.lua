---@diagnostic disable: undefined-field, different-requires
local Plugin = require("core.plugin")

local icons = { ui = require("utils.icons").get("ui", true) }

local helpers = require("keymap.helpers")
local map_cr = require("keymap.bind").map_cr
local map_callback = require("keymap.bind").map_callback

return Plugin:new("nvim-telescope/telescope.nvim")
    :lazy(true)
    :cmd("Telescope")
    :dep("nvim-lua/plenary.nvim")
    :dep("jvgrootveld/telescope-zoxide")
    :dep("debugloop/telescope-undo.nvim")
    :dep("fdschmidt93/telescope-egrepify.nvim")
    :dep("nvim-telescope/telescope-frecency.nvim")
    :dep(Plugin:new("FabianWirth/search.nvim"):opts(require("plugins.tool.telescope.search")))
    :dep(Plugin:new("Mythos-404/project.nvim")
        :name("project_nvim")
        :on("CursorHold", "CursorHoldI")
        :opts(require("plugins.tool.telescope.project")))
    :dep(Plugin:new("aaronhallaert/advanced-git-search.nvim")
        -- to show diff splits and open commits in browser
        :dep("tpope/vim-fugitive")
        -- to open commits in browser with fugitive
        :dep("tpope/vim-rhubarb"))
    :dep(Plugin:new("nvim-telescope/telescope-fzf-native.nvim")
        :build("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install"))
    :config(function()
        local telescope = require("telescope")

        telescope.setup({
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
                        prompt_position = require("core.settings").search_prompt_position,
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
                        lua = true,    -- You can set the option for specific filetypes
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

        local function load_ext(name)
            local ok, _ = pcall(telescope.load_extension, name)
            if ok then return end

            vim.notify(
                ("Failed to load extension %q"):format(name),
                vim.log.levels.WARN,
                { title = "Telescope Extension" }
            )
        end


        load_ext("frecency")
        load_ext("fzf")
        load_ext("egrepify")
        load_ext("projects")
        load_ext("undo")
        load_ext("zoxide")
        load_ext("persisted")
        load_ext("advanced_git_search")
        load_ext("xmake")
    end)
    :lazy_keys({
        ["n|<C-A-p>"] = map_callback(function()
                helpers.command_panel()
            end)
            :with_desc("tool: Toggle command panel"),
        ["n|<leader>ff"] = map_callback(function()
                require("search").open({ collection = "file" })
            end)
            :with_desc("tool: Find files"),
        ["n|<leader>fp"] = map_callback(function()
                require("search").open({ collection = "pattern" })
            end)
            :with_desc("tool: Find patterns"),
        ["v|<leader>fs"] = map_callback(function()
                local is_config = vim.uv.cwd() == require("core.global").vim_path
                if require("core.settings").search_backend == "fzf" then
                    require("fzf-lua").grep_project({
                        search = require("fzf-lua.utils").get_visual_selection(),
                        rg_opts = "--column --line-number --no-heading --color=always --smart-case"
                            .. (is_config and " --no-ignore --hidden --glob '!.git/*'" or ""),
                        fzf_opts = {
                            ["--layout"] = require("core.settings").search_prompt_position == "top"
                                and "reverse"
                                or "default",
                        },
                    })
                else
                    require("telescope.builtin").grep_string(
                        is_config and { additional_args = { "--no-ignore" } } or {}
                    )
                end
            end)
            :with_desc("tool: Find word under cursor"),
        ["n|<leader>fg"] = map_callback(function()
                require("search").open({ collection = "git" })
            end)
            :with_desc("tool: Locate Git objects"),
        ["n|<leader>fd"] = map_callback(function()
                require("search").open({ collection = "dossier" })
            end)
            :with_desc("tool: Retrieve dossiers"),
        ["n|<leader>fm"] = map_callback(function()
                require("search").open({ collection = "misc" })
            end)
            :with_desc("tool: Miscellaneous"),
        ["n|<leader>fr"] = map_cr("Telescope resume"):with_desc("tool: Resume last search"),
        ["n|<leader>fR"] = map_callback(function()
                if require("core.settings").search_backend == "fzf" then
                    require("fzf-lua").resume()
                end
            end)
            :with_desc("tool: Resume last fzf search"),
    })
