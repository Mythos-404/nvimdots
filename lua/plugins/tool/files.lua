---@diagnostic disable: undefined-global
local Plugin = require("core.plugin")

local map_callback = require("keymap.bind").map_callback

return Plugin:new("nvim-mini/mini.files")
    :lazy(false)
    :version(false)
    :config(function()
        local HIDDEN_NAMES = {
            [".git"] = true,
            [".DS_Store"] = true,
            ["__pycache__"] = true,
            ["node_modules"] = true,
        }

        local git_ignore_cache = {}

        ---@param dir string
        ---@param entries table[]
        ---@return table<string, boolean>
        local function batch_git_ignored(dir, entries)
            local cached = git_ignore_cache[dir]
            if cached == false then return {} end
            if type(cached) == "table" then return cached end

            local paths = {}
            for _, entry in ipairs(entries) do
                paths[#paths + 1] = entry.path
            end
            if #paths == 0 then
                git_ignore_cache[dir] = {}
                return git_ignore_cache[dir]
            end

            local ok, proc = pcall(vim.system, {
                "git",
                "-C",
                dir,
                "check-ignore",
                "--stdin",
                "-z",
            }, {
                stdin = table.concat(paths, "\0") .. "\0",
                text = true,
            })

            if not ok or not proc then
                git_ignore_cache[dir] = false
                return {}
            end

            local result = proc:wait()
            if result.code ~= 0 and result.code ~= 1 then
                git_ignore_cache[dir] = false
                return {}
            end

            local set = {}
            for path in vim.gsplit(result.stdout or "", "\0", { trimempty = true }) do
                set[path] = true
            end
            git_ignore_cache[dir] = set
            return set
        end

        require("mini.files").setup({
            content = {
                filter = function(entry)
                    return not HIDDEN_NAMES[entry.name]
                end,
                sort = function(entries)
                    if #entries == 0 then return entries end

                    local dir = vim.fs.dirname(entries[1].path)
                    local ignored = batch_git_ignored(dir, entries)

                    local visible = {}
                    for _, entry in ipairs(entries) do
                        if not ignored[entry.path] then visible[#visible + 1] = entry end
                    end

                    return MiniFiles.default_sort(visible)
                end,
            },
            windows = {
                preview = true,
                width_preview = 45,
            },
        })

        local group = vim.api.nvim_create_augroup("mini.files", { clear = true })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesExplorerOpen",
            desc = "Invalidate mini.files gitignore cache",
            group = group,
            callback = function()
                git_ignore_cache = {}
            end,
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            desc = "Define commands/keymaps for mini.files",
            group = group,
            callback = function(args)
                local buf_id = args.data.buf_id
                local map_split = function(lhs, direction)
                    local rhs = function()
                        -- Make new window and set it as target
                        local cur_target = MiniFiles.get_explorer_state().target_window
                        local new_target = vim.api.nvim_win_call(cur_target, function()
                            vim.cmd(direction .. " split")
                            return vim.api.nvim_get_current_win()
                        end)

                        MiniFiles.set_target_window(new_target)
                    end

                    local desc = "filetree: Split " .. direction
                    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
                end

                map_split("<C-s>", "belowright horizontal")
                map_split("<C-v>", "belowright vertical")
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            desc = "Auto-refactor LSP file",
            group = group,
            callback = function(event)
                Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end,
        })
    end)
    :lazy_keys({
        ["n|<C-n>"] = map_callback(function()
                if not MiniFiles.close() then
                    local file = vim.api.nvim_buf_get_name(0)
                    local file_exists = vim.fn.filereadable(file) ~= 0
                    MiniFiles.open(file_exists and file or nil)
                    MiniFiles.reveal_cwd()
                end
            end)
            :with_noremap()
            :with_silent()
            :with_desc("files: Toggle"),
    })
