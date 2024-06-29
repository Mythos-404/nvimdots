---@diagnostic disable: undefined-global

local function indent_str()
	return (" "):rep(tonumber(require("modules.utils").get_indent()) --[[ @as number]])
end

local function indent_line(end_str)
	return sn(nil, { t({ "", indent_str() .. end_str }) })
end

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
		{ trig = "imp", desc = "Import module" },
		c(1, {
			t("import "),
			fmt("from {} import ", { i(1) }),
		})
	),

	s(
		{ trig = "if" },
		fmt("if {}:\n{}", {
			i(1, "exp"),
			t(indent_str()),
		})
	),
	s(
		{ trig = "el" },
		fmt("else:\n{}", {
			t(indent_str()),
		})
	),
	s(
		{ trig = "ei" },
		fmt("elif {}:\n{}", {
			i(1, "exp"),
			t(indent_str()),
		})
	),

	s(
		{ trig = "main" },
		fmt('if __name__ == "__main__":\n{}', {
			t(indent_str()),
		})
	),

	s(
		{ trig = "fr" },
		fmt("for {} in {}:\n{}", {
			i(2, "var"),
			i(1, "exp"),
			t(indent_str()),
		})
	),

	s(
		{ trig = "wt", desc = "With block" },
		c(1, {
			fmt("with {} as {}:\n{}", {
				i(1, "exp"),
				i(2, "name"),
				t(indent_str()),
			}),
			fmt("async with {} as {}:\n{}", {
				i(1, "exp"),
				i(2, "name"),
				t(indent_str()),
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
				t(indent_str()),
			}),
			fmt("async def {}({}){}: \n{}", {
				i(1),
				i(2),
				c(3, {
					t(),
					sn(nil, { t(" -> "), i(1, "type") }),
				}),
				t(indent_str()),
			}),
		})
	),

	s(
		{ trig = "dcls", desc = "Data class block" },
		fmt("@dataclss()\nclass {}:\n{}", {
			i(1, "Name"),
			t(indent_str()),
		})
	),
	s(
		{ trig = "cls", desc = "Class block" },
		fmt("class {}:\n{}", {
			i(1, "Name"),
			t(indent_str()),
		})
	),

	s(
		{ trig = "init", desc = "Class init block" },
		fmt("def __init__(self{}):{}", {
			i(1),
			d(2, function(args)
				---@type string
				args = args[1][1]
				if #args == 0 then
					return indent_line("pass")
				end

				local tab = {}
				local cnt = 1
				for arg in (args):gmatch(" ?([^,]?:) ?") do
					if #arg == 0 then
						goto continue
					end

					local colon = arg:find(":")
					if colon then
						arg = arg:sub(1, colon - 1)
					end
					table.insert(tab, t({ "", indent_line("self.") }))
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
	}, fmt("print({})", { l(l.LS_TSMATCH) })),

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
			fmt("if {}{}:\n{}", { l(l.LS_TSMATCH), i(1), t(indent_str()) }),
			fmt("if not {}{}:\n{}", { l(l.LS_TSMATCH), i(1), t(indent_str()) }),
			fmt("if {} is {}:\n{}", { l(l.LS_TSMATCH), i(1), t(indent_str()) }),
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
	}, fmt("for {} in {}{}:\n{}", { i(1, "_"), l(l.LS_TSMATCH), i(2), t(indent_str()) })),
}
