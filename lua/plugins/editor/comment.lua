local Plugin = require("core.plugin")


local bind = require("keymap.bind")
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

return Plugin:new("numToStr/Comment.nvim")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :config(function(plugin, opts)
        require("Comment").setup({
            ignore = "^$",
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
    end)
    :lazy_keys({
        ["n|gcc"] = map_callback(function()
                return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
                    or et("<Plug>(comment_toggle_linewise_count)")
            end)
            :with_expr()
            :with_desc("edit: Toggle comment for line"),
        ["n|gbc"] = map_callback(function()
                return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
                    or et("<Plug>(comment_toggle_blockwise_count)")
            end)
            :with_expr()
            :with_desc("edit: Toggle comment for block"),
        ["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
            :with_desc("edit: Toggle comment for line with operator"),
        ["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
            :with_desc("edit: Toggle comment for block with operator"),
        ["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
            :with_desc("edit: Toggle comment for line with selection"),
        ["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
            :with_desc("edit: Toggle comment for block with selection"),
    })
