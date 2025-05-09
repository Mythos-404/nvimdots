---@diagnostic disable: undefined-global
local expr_query = [[
[
  (call)
  (identifier)
  (expression_list)
  (expression_statement)
] @prefix
]] --> INJECT: query

return {
    s({ trig = "#!", desc = "Python shebang" }, t("#!/usr/bin/env python")),

    s({ trig = "rt" }, t("return ")),

    s(
        { trig = "cl", desc = "Call Function" },
        fmt("{}({})", {
            i(0),
            l(l.TM_SELECTED_TEXT),
        })
    ),

    s(
        { trig = "imp", desc = "Import module" },
        c(1, {
            fmt("import {}", { i(1) }),
            fmt("from {} import {}", { i(1), i(0) }),
        })
    ),

    s(
        { trig = "if" },
        fmt("if {}:\n{}", {
            i(1, "exp"),
            t("\t"),
        })
    ),
    s(
        { trig = "el" },
        fmt("else:\n{}", {
            t("\t"),
        })
    ),
    s(
        { trig = "ei" },
        fmt("elif {}:\n{}", {
            i(1, "exp"),
            t("\t"),
        })
    ),

    s(
        { trig = "main" },
        fmt('if __name__ == "__main__":\n{}', {
            t("\t"),
        })
    ),

    s(
        { trig = "fr" },
        fmt("for {} in {}:\n{}", {
            i(2, "var"),
            i(1, "exp"),
            t("\t"),
        })
    ),

    s(
        { trig = "wt", desc = "With block" },
        c(1, {
            fmt("with {}:\n{}", {
                i(1, "exp"),
                t("\t"),
            }),
            fmt("async with {}:\n{}", {
                i(1, "exp"),
                t("\t"),
            }),
        })
    ),

    s({ trig = [[\]], desc = "Lambda" }, fmt("lambda {}: ", { i(1) })),
    s(
        { trig = "df", desc = "Function block" },
        c(1, {
            fmt("def {}({}){}: \n{}", {
                i(1, "name"),
                i(2, "args"),
                c(3, {
                    t(),
                    sn(nil, { t(" -> "), i(1, "type") }),
                }),
                t("\t"),
            }),
            fmt("async def {}({}){}: \n{}", {
                i(1, "name"),
                i(2, "args"),
                c(3, {
                    t(),
                    sn(nil, { t(" -> "), i(1, "type") }),
                }),
                t("\t"),
            }),
        })
    ),

    s(
        { trig = "dcls", desc = "Data class block" },
        fmt("@dataclass()\nclass {}:\n{}", {
            i(1, "Name"),
            f(function()
                local query = vim.treesitter.query.parse(
                    "python",
                    [[
                        ((import_from_statement
                            (dotted_name
                                (identifier)) @_mod_name
                            (dotted_name
                                (identifier) @_imp_name))
                        (#eq? @_mod_name "dataclasses")
                        (#eq? @_imp_name "dataclass"))
                    ]]
                )
                local tree = vim.treesitter.get_parser():parse(true)[1]
                for _, _, _ in query:iter_matches(tree:root(), 0) do
                    return t("\t")
                end
                vim.fn.append(0, "from dataclasses import dataclass")
                return t("\t")
            end),
        })
    ),
    s(
        { trig = "cls", desc = "Class block" },
        fmt("class {}:\n{}", {
            i(1, "Name"),
            t("\t"),
        })
    ),

    s(
        { trig = "init", desc = "Class init block" },
        fmt("def __init__(self, {}):{}", {
            i(1),
            d(2, function(args)
                ---@type string
                args = args[1][1]
                if #args == 0 then return sn(nil, t({ "", "\tpass" })) end

                local tab = {}
                local cnt = 1
                for arg in (args):gmatch(" ?([^,]*:) ?") do
                    if #arg == 0 then goto continue end

                    local colon = arg:find(":")
                    if colon then arg = arg:sub(1, colon - 1) end
                    table.insert(tab, t({ "", "\tself." }))
                    table.insert(tab, r(cnt, tostring(cnt), i(nil, arg)))
                    table.insert(tab, t(" = "))
                    table.insert(tab, t(arg))
                    cnt = cnt + 1

                    ::continue::
                end
                return sn(nil, tab)
            end, { 1 }),
        })
    ),

    tsp({
        trig = ".p",
        desc = "Expands expression to print(<exp>)",
        reparseBuffer = "live",
        matchTSNode = {
            query = expr_query,
            query_lang = "python",
        },
    }, fmta("print(f'{<> = }')", { l(l.LS_TSMATCH) })),

    tsp(
        {
            trig = ".if",
            desc = "Expands expression to if <exp>: ...",
            reparseBuffer = "live",
            matchTSNode = {
                query = expr_query,
                query_lang = "python",
            },
        },
        c(1, {
            fmt("if {}{}:\n{}", { l(l.LS_TSMATCH), i(1), t("\n") }),
            fmt("if not {}{}:\n{}", { l(l.LS_TSMATCH), i(1), t("\n") }),
            fmt("if {} is {}:\n{}", { l(l.LS_TSMATCH), i(1), t("\n") }),
        })
    ),

    tsp({
        trig = ".for",
        desc = "Expands expression to for <var> in <exp>: ...",
        reparseBuffer = "live",
        matchTSNode = {
            query = expr_query,
            query_lang = "python",
        },
    }, fmt("for {} in {}{}:\n{}", { i(1, "_"), l(l.LS_TSMATCH), i(2), t("\n") })),
}
