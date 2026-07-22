local Plugin = require("core.plugin")

return Plugin:new("lewis6991/gitsigns.nvim")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :opts({
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        auto_attach = true,
        signcolumn = true,
        sign_priority = 6,
        update_debounce = 100,
        word_diff = false,
        current_line_blame = true,
        diff_opts = { internal = true },
        watch_gitdir = { follow_files = true },
        current_line_blame_opts = { delay = 1000, virt_text = true, virtual_text_pos = "eol" },
    })
    :local_keys({ option = "on_attach" }, function(ctx, bind)
        local actions = require("gitsigns.actions")
        return {
            ["n|]g"] = bind.map_callback(function()
                    if vim.wo.diff then return "]g" end
                    vim.schedule(function()
                        actions.next_hunk()
                    end)
                    return "<Ignore>"
                end)
                :with_expr()
                :with_desc("git: Goto next hunk"),
            ["n|[g"] = bind.map_callback(function()
                    if vim.wo.diff then return "[g" end
                    vim.schedule(function()
                        actions.prev_hunk()
                    end)
                    return "<Ignore>"
                end)
                :with_expr()
                :with_desc("git: Goto prev hunk"),
            ["n|<leader>gs"] = bind.map_callback(function()
                    actions.stage_hunk()
                end)
                :with_desc("git: Stage hunk"),
            ["v|<leader>gs"] = bind.map_callback(function()
                    actions.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                :with_desc("git: Stage hunk"),
            ["n|<leader>gu"] = bind.map_callback(function()
                    actions.undo_stage_hunk()
                end)
                :with_desc("git: Undo stage hunk"),
            ["n|<leader>gr"] = bind.map_callback(function()
                    actions.reset_hunk()
                end)
                :with_desc("git: Reset hunk"),
            ["v|<leader>gr"] = bind.map_callback(function()
                    actions.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                :with_desc("git: Reset hunk"),
            ["n|<leader>gR"] = bind.map_callback(function()
                    actions.reset_buffer()
                end)
                :with_desc("git: Reset buffer"),
            ["n|<leader>gp"] = bind.map_callback(function()
                    actions.preview_hunk()
                end)
                :with_desc("git: Preview hunk"),
            ["n|<leader>gb"] = bind.map_callback(function()
                    actions.blame_line({ full = true })
                end)
                :with_desc("git: Blame line"),
            -- Text objects
            ["ox|ih"] = bind.map_callback(function()
                actions.text_object()
            end),
        }
    end)
