local Plugin = require("core.plugin")

local map_cr = require("keymap.bind").map_cr
local icons = { ui = require("utils.icons").get("ui") }

local opts = {
    options = {
        number = nil,
        close_command = "lua Snacks.bufdelete(%d)",
        right_mouse_command = "lua Snacks.bufdelete(%d)",
        modified_icon = icons.ui.Modified,
        buffer_close_icon = icons.ui.Close,
        left_trunc_marker = icons.ui.Left,
        right_trunc_marker = icons.ui.Right,
        max_name_length = 20,
        max_prefix_length = 13,
        tab_size = 20,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        persist_buffer_sort = true,
        always_show_bufferline = true,
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count)
            return "(" .. count .. ")"
        end,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                padding = 0,
            },
            {
                filetype = "aerial",
                text = "Symbol Outline",
                text_align = "center",
                padding = 0,
            },
        },
    },
    -- Change bufferline's highlights here! See `:h bufferline-highlights` for detailed explanation.
    -- Note: If you use catppuccin then modify the colors below!
    highlights = {},
}

return Plugin:new("akinsho/bufferline.nvim")
    :lazy(true)
    :on("BufReadPost", "BufAdd", "BufNewFile")
    :opts(opts)
    :config(function(plugin, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
            local cp = require("utils").get_palette() -- Get the palette.

            local catppuccin_hl_overwrite = {
                highlights = require("catppuccin.special.bufferline").get_theme({
                    styles = { "italic", "bold" },
                    custom = {
                        all = {
                            -- Hint
                            hint = { fg = cp.rosewater },
                            hint_visible = { fg = cp.rosewater },
                            hint_selected = { fg = cp.rosewater },
                            hint_diagnostic = { fg = cp.rosewater },
                            hint_diagnostic_visible = { fg = cp.rosewater },
                            hint_diagnostic_selected = { fg = cp.rosewater },
                        },
                    },
                }),
            }

            opts = vim.tbl_deep_extend("force", opts, catppuccin_hl_overwrite)
        end

        require("bufferline").setup(opts)
    end)
    :lazy_keys({
        ["n|<A-i>"] = map_cr("BufferLineCycleNext"):with_desc("buffer: Switch to next"),
        ["n|<A-o>"] = map_cr("BufferLineCyclePrev"):with_desc("buffer: Switch to prev"),
        ["n|<A-S-i>"] = map_cr("BufferLineMoveNext"):with_desc(
            "buffer: Move current to next"),
        ["n|<A-S-o>"] = map_cr("BufferLineMovePrev"):with_desc(
            "buffer: Move current to prev"),
        ["n|<leader>be"] = map_cr("BufferLineSortByExtension"):with_desc("buffer: Sort by extension"),
        ["n|<leader>bd"] = map_cr("BufferLineSortByDirectory"):with_desc("buffer: Sort by direrctory"),
        ["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1"):with_desc("buffer: Goto buffer 1"),
        ["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2"):with_desc("buffer: Goto buffer 2"),
        ["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3"):with_desc("buffer: Goto buffer 3"),
        ["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4"):with_desc("buffer: Goto buffer 4"),
        ["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5"):with_desc("buffer: Goto buffer 5"),
        ["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6"):with_desc("buffer: Goto buffer 6"),
        ["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7"):with_desc("buffer: Goto buffer 7"),
        ["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8"):with_desc("buffer: Goto buffer 8"),
        ["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9"):with_desc("buffer: Goto buffer 9"),
    })
