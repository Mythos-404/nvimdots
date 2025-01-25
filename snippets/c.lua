---@diagnostic disable: undefined-global
return {
    s(
        { trig = "main", desc = "Main function" },
        fmta("int main(/*int argc, char *argv[]*/)\n{\n\t<>\n}", {
            i(0),
        })
    ),

    s({ trig = "rt" }, fmt("return {};", i(0))),

    s(
        { trig = "cl", desc = "Call Function" },
        fmt("{}({})", {
            i(0),
            l(l.TM_SELECTED_TEXT),
        })
    ),
}
