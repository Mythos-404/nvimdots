---@diagnostic disable: undefined-global

local function indent_str()
	return (" "):rep(tonumber(require("modules.utils").get_indent()) --[[ @as number]])
end

local function indent_line(end_str)
	return sn(nil, { t({ "", indent_str() .. end_str }) })
end

local function build_function_snippet(multiline)
	local function _snippet(args, _, _, user_args)
		if not user_args then
			local name_arg = args[1]
			local function_name = name_arg and #name_arg > 0 and name_arg[1] or ""
			user_args = {
				name = function_name,
				arg_count = 0,
			}
		end
		table.insert(user_args, args[1])
		local choices = {}
		local end_snip = {
			i(1),
			t({ "", user_args.name }),
		}
		local idx = 2
		if user_args.arg_count > 0 then
			for _ = 1, user_args.arg_count do
				table.insert(end_snip, t(" "))
				table.insert(end_snip, i(idx, "_"))
				idx = idx + 1
			end
		end
		table.insert(end_snip, t(" = "))
		table.insert(end_snip, i(idx, "undefined"))
		table.insert(choices, sn(nil, end_snip))
		local function wrapper(a, p, os)
			-- XXX: For some reason, user_args is not passed down.
			local updated_user_args = {
				name = user_args.name,
				arg_count = user_args.arg_count + 1,
			}
			return _snippet(a, p, os, updated_user_args)
		end
		table.insert(
			choices,
			sn(nil, {
				i(1),
				multiline and indent_line("-> ") or t(" -> "),
				d(2, wrapper, nil),
			})
		)
		return sn(nil, {
			c(1, choices),
		})
	end
	return _snippet
end

return {
	s({
		trig = "adt",
		desc = "Algebraic data type",
	}, {
		t("data "),
		i(1, "Type"),
		c(2, {
			d(1, function()
				return indent_line("= ")
			end),
			sn(nil, {
				t(""),
				i(1, "a"),
				d(2, function()
					return indent_line("= ")
				end),
			}),
		}),
		i(3, "Constructor"),
		d(4, function()
			return indent_line("= ")
		end),
		i(5, "Constructor"),
		d(
			6,
			(function()
				local function adt_constructor_choice()
					return sn(nil, {
						c(1, {
							t(""),
							sn(nil, {
								d(1, function()
									return sn(nil, { t({ "", indent_str() .. "| " }) })
								end),
								i(2, "Constructor"),
								d(3, adt_constructor_choice),
							}),
						}),
					})
				end
				return adt_constructor_choice
			end)()
		),
	}),

	s({
		trig = "new",
		desc = "Newtype",
	}, {
		t("newtype "),
		i(1, "Type"),
		c(2, {
			t(" = "),
			sn(nil, {
				t(" "),
				i(1, "a"),
				t(" = "),
			}),
		}),
		i(3, "Constructor"),
		t(" "),
		i(0, "Int"),
	}),

	s({
		trig = "rec",
		desc = "Record",
	}, {
		t("data "),
		i(1, "Type"),
		c(2, {
			d(1, function()
				return indent_line("= ")
			end),
			sn(nil, {
				t(" "),
				i(1, "a"),
				d(2, function()
					return indent_line("= ")
				end),
			}),
		}),
		i(3, "Constructor"),
		d(4, function()
			return indent_line("{ ")
		end),
		i(5),
		t(" :: "),
		d(
			6,
			(function()
				local function record_field_choice()
					return sn(nil, {
						c(1, {
							sn(nil, {
								i(1),
								d(2, function()
									return indent_line("}")
								end),
							}),
							sn(nil, {
								i(1),
								d(2, function()
									return indent_line(", ")
								end),
								i(3),
								t(" :: "),
								d(4, record_field_choice),
							}),
						}),
					})
				end
				return record_field_choice
			end)()
		),
		c(7, {
			t(""),
			sn(nil, {
				d(1, function()
					return indent_line("deriving (")
				end),
				i(2),
				t(")"),
			}),
			sn(nil, {
				d(1, function()
					return indent_line("deriving ")
				end),
				i(2),
			}),
		}),
	}),

	s({
		trig = "cls",
		desc = "Typeclass",
	}, {
		t("class "),
		i(1),
		d(2, function()
			return sn(nil, { t({ " where", indent_str() }) })
		end),
	}),

	s(
		{
			trig = "ins",
			desc = "Typeclass instance",
		},
		fmt([[instance {} {} {}]], {
			i(1, "Class"),
			i(2, "Type"),
			d(3, function()
				return sn(nil, { t({ "where", indent_str() }) })
			end),
		})
	),

	s({
		trig = "=>",
		descr = "Typeclass constraint",
	}, fmt([[{} {} => ]], { i(1, "Class"), i(2, "x") })),

	----------------------------------------------------------------
	s({
		trig = [[\]],
		desc = "Lambda",
	}, { t([[\]]), i(1, "_"), t(" -> ") }),

	s({
		trig = "fn",
		desc = "Function and type signature",
	}, {
		i(1, "someFunc"),
		t(" :: "),
		d(2, build_function_snippet(false), { 1 }),
	}),

	s({
		trig = "fnc",
		desc = "Function and type signature",
	}, {
		i(1, "someFunc"),
		d(2, function()
			return indent_line(":: ")
		end),
		d(3, build_function_snippet(true), { 1 }),
	}),

	----------------------------------------------------------------
	s({
		trig = "if",
		desc = "If expression (single line)",
	}, { fmt([[if {} then {} else {} ]], { i(1), i(2), i(0) }) }),
}
