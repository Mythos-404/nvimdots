---@diagnostic disable: undefined-global

local function indent_str()
	return (" "):rep(tonumber(require("modules.utils").get_indent()) --[[ @as number]])
end

local match_tsnode = {
	query = [[
		[
			(function_call)
			(identifier)
			(expression_list)
			(dot_index_expression)
			(bracket_index_expression)
		] @prefix
	]], --> INJECT: query
	query_lang = "lua",
}

---@param lang string
---@param query_str string
---@return string[]
local function get_treesitte_query_parse(lang, query_str)
	local query_text = {}
	local query = vim.treesitter.query.parse(lang, query_str)
	local tree = vim.treesitter.get_parser():parse(true)[1]
	for _, node, _ in query:iter_captures(tree:root(), 0) do
		local text = vim.treesitter.get_node_text(node, 0)
		query_text[text] = text
	end
	return vim.tbl_values(query_text)
end

return {
	s(
		{ trig = "snip", desc = "Luasnip snippets" },
		fmta([[s({ trig = "<>", decs = "<>" }, <>)]], {
			i(1),
			i(2),
			i(0),
		})
	),

	s({ trig = "#!", desc = "Lua shebang" }, t("!/usr/bin/env lua")),

	s({ trig = "rt" }, t("return ")),

	s(
		{ trig = "req", desc = "Import file" },
		c(1, {
			fmt([[require("{}")]], { i(1) }),
			fmt([[local {name} = require("{}")]], {
				i(1),
				name = d(2, function(args)
					args = vim.split(args[1][1], "%.")
					return sn(nil, i(1, args[#args]))
				end, { 1 }, {}),
			}),
		})
	),

	s(
		{ trig = "ll", desc = "Local variable" },
		c(1, {
			fmt([[local {name} = {}]], {
				i(1),
				name = d(2, function(args)
					args = vim.split(args[1][1], "%.")
					return sn(nil, i(1, args[#args]))
				end, { 1 }),
			}),
			fmt([[local {names} = pcall({})]], {
				i(1),
				names = d(2, function(args)
					args = vim.split(vim.split(args[1][1], ",")[1], "%.")
					args = args[#args]
					return sn(nil, fmt("{}, {}", { i(2, ("is_%s"):format(args)), i(1, args) }))
				end, { 1 }),
			}),
		})
	),

	s(
		{ trig = "inject", desc = "Inject language highlighting" },
		fmt(
			"--> INJECT: {}",
			(function()
				return c(
					1,
					vim.list_extend(
						{ i(1) },
						vim.tbl_map(t, {
							"lua",
							"query",
						})
					)
				)
			end)()
		)
	),

	s(
		{ trig = "mfn", desc = "Modlue function" },
		fmt("function {module_name}.{}({})\n{}\nend", {
			i(2, "name"),
			i(3, "args"),
			sn(0, { t(indent_str()), i(1) }),
			module_name = d(1, function()
				local m_key_name = vim.iter({
					get_treesitte_query_parse(
						"lua",
						[[(chunk (return_statement (expression_list (identifier) @rt_name)))]]
					),
					get_treesitte_query_parse(
						"lua",
						[[(chunk (variable_declaration (assignment_statement (variable_list (identifier) @name))))]]
					),
				})
					:flatten()
					:fold({}, function(acc, v)
						acc[v] = v
						return acc
					end)
				local m_name = vim.tbl_keys(m_key_name)

				table.sort(m_name, function(x, y)
					local x_upper = x:find("^%u+")
					local y_upper = y:find("^%u+")
					x_upper = x_upper or 0
					y_upper = y_upper or 0
					if x_upper == y_upper then
						return false
					end
					return x_upper > y_upper
				end)

				return sn(1, c(1, vim.tbl_map(t, m_name)))
			end),
		})
	),

	tsp(
		{
			trig = ".p",
			desc = "Expands expression to print(<exp>)",
			reparseBuffer = "live",
			wordTrig = false,
			matchTSNode = match_tsnode,
		},
		c(1, {
			fmt("vim.print({})", { dl(1, l.LS_TSMATCH) }),
			fmt("print({})", { dl(1, l.LS_TSMATCH) }),
		})
	),

	tsp(
		{
			trig = ".pairs",
			desc = "Expands expression to for <key>, <var> in pairs(<exp>) or ipairs(<exp>) dp ... end",
			reparseBuffer = "live",
			wordTrig = false,
			matchTSNode = match_tsnode,
		},
		c(1, {
			fmt("for {}, {} in pairs({}) do\n{}{}\nend", {
				i(1, "k"),
				i(2, "v"),
				l(l.LS_TSMATCH),
				t(indent_str()),
				i(3),
			}),
			fmt("for {}, {} in ipairs({}) do\n{}{}\nend", {
				i(1, "i"),
				i(2, "v"),
				l(l.LS_TSMATCH),
				t(indent_str()),
				i(3),
			}),
		})
	),

	tsp({
		trig = ".isnot",
		desc = "Expands expression to if not <exp> then ... end",
		reparseBuffer = "live",
		wordTrig = false,
		matchTSNode = match_tsnode,
	}, fmt("if not {} then\n{}{}\nend", { l(l.LS_TSMATCH), t(indent_str()), i(0) })),
}
