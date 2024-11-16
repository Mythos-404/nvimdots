---@diagnostic disable: undefined-global

return {
    s({ trig = "rt" }, fmt("return {}", i(0))),

    s(
        { trig = "cl", desc = "Call Function" },
        fmt("{}({})", {
            i(0),
            l(l.TM_SELECTED_TEXT),
        })
    ),
}
