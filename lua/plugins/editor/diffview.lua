local Plugin = require("core.plugin")

local map_cr = require("keymap.bind").map_cr

return Plugin:new("sindrets/diffview.nvim")
    :lazy(true)
    :cmd("DiffviewOpen", "DiffviewClose")
    :opts({
        diff_binaries = false,    -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        git_cmd = { "git" },      -- The git executable followed by default args.
        hg_cmd = { "hg" },        -- The hg executable followed by default args.
        use_icons = true,         -- Requires nvim-web-devicons
        show_help_hints = true,   -- Show hints for how to open the help panel
        watch_index = true,       -- Update views and index buffers when the git index changes.
        view = {
            merge_tool = {
                layout = "diff4_mixed",
            },
        },
    })
    :lazy_keys({
        ["n|<leader>gd"] = map_cr("DiffviewOpen"):with_desc("git: Show diff"),
        ["n|<leader>gD"] = map_cr("DiffviewClose"):with_desc("git: Close diff"),
    })
