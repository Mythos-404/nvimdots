---@diagnostic disable: undefined-global

return {
    s(
        { trig = "h", decs = "Header level" },
        c(1, {
            t("###"),
            t("####"),
            t("#####"),
            t("######"),
        })
    ),

    s(
        { trig = "l", decs = "Links" },
        c(1, {
            fmt("[{}]({})", { i(2, "text"), i(1, "url") }),
            fmt("![{}]({})", { i(2, "alt_text"), i(1, "path") }),
        })
    ),

    s(
        { trig = "todo", decs = "Todo code" },
        fmt(
            "> [!{}]\n> ",
            c(1, {
                t("Note"),
                t("Tip"),
                t("Warning"),
                t("Important"),
                t("Caution"),
            })
        )
    ),

    s(
        { trig = "det", decs = "Folded block" },
        fmt(
            [[
            <datails>

            <summary>{}</summary>

            {}

            </datails>]],
            { i(1, "..."), dl(2, l.TM_SELECTED_TEXT) }
        )
    ),
}
