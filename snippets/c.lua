---@diagnostic disable: undefined-global

local function indent_str()
    return (" "):rep(tonumber(require("modules.utils").get_indent()) --[[ @as number]])
end

return {
    s(
        { trig = "main", desc = "Main function" },
        fmta("int main(/*int argc, char *argv[]*/)\n{\n<>\n}", {
            sn(0, { t(indent_str()), i(1) }),
        })
    ),
}
