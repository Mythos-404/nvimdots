return function()
    require("trailblazer").setup({
        trail_options = {
            mark_symbol = "󰈿",
            newest_mark_symbol = "󰋲",
            cursor_mark_symbol = "󰻿",
            previous_mark_symbol = "",
            next_mark_symbol = "",
        },

        force_mappings = {
            ni = {
                motions = {
                    new_trail_mark = "<A-n>",
                    track_back = "<A-b>",
                    move_to_nearest = "<A-B>",
                    toggle_trail_mark_list = "<A-m>",
                    peek_move_next_down = "<A-J>",
                    peek_move_previous_up = "<A-K>",
                },
                actions = {
                    set_trail_mark_select_mode = "<A-t>",
                    set_trail_mark_stack_sort_mode = "<A-r>",
                    switch_to_next_trail_mark_stack = "<A-.>",
                    switch_to_previous_trail_mark_stack = "<A-,>",
                },
            },
        },
    })
end
