---@diagnostic disable: undefined-global

local function indent_str()
    return (" "):rep(tonumber(require("modules.utils").get_indent()) --[[ @as number]])
end

return {
    s({ trig = "rt" }, t("return ")),

    s(
        { trig = "main", desc = "Main function" },
        fmta("func main() {\n<>\n}", {
            sn(0, { t(indent_str()), i(1) }),
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
