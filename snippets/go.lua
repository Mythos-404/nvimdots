---@diagnostic disable: undefined-global
return {
    s({ trig = "rt" }, t("return ")),

    s(
        { trig = "main", desc = "Main function" },
        fmta("func main() {\n\t<>\n}", {
            i(0),
        })
    ),

    s(
        { trig = "cl", desc = "Call Function" },
        fmt("{}({})", {
            i(0),
            l(l.TM_SELECTED_TEXT),
        })
    ),
}
