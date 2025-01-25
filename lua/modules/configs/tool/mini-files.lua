return function()
    require("mini.files").setup({
        content = {
            filter = function(entry)
                local filter_names = { ".DS_Store", "addones", "^.git$", "__pycache__" }
                return not vim.tbl_contains(filter_names, function(v)
                    return entry.name:match(v)
                end, { predicate = true })
            end,
            sort = function(entries)
                local check_ignore = vim.system({ "git", "check-ignore", "--stdin" }, { stdin = true })
                if check_ignore:is_closing() then return MiniFiles.default_sort(entries) end
                vim.iter(entries):map(function(entry)
                    if entry.fs_type == "file" then return end
                    check_ignore:write(entry.path .. "\n")
                end)
                check_ignore:write(nil)

                local ignore_files = vim.split(check_ignore:wait().stdout, "\n", { trimempty = true })
                return MiniFiles.default_sort(vim.iter(entries)
                    :filter(function(entry)
                        return not vim.tbl_contains(ignore_files, entry.path)
                    end)
                    :totable())
            end,
        },
        windows = {
            preview = true,
            width_preview = 45,
        },
    })

    local group = vim.api.nvim_create_augroup("mini.files", { clear = true })
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
end
