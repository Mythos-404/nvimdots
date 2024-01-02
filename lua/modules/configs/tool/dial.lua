return function()
	local augend = require("dial.augend")
	local augends = {
		augend.constant.alias.bool,
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		augend.integer.alias.decimal_int,
		augend.integer.alias.hex, -- nonnegative hex number  (0x00, 0x1a1f, etc.)
		augend.semver.alias.semver,

		augend.constant.new({
			elements = { "True", "False" },
		}),
		augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "and", "or" },
			word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
			cyclic = true, -- "or" is incremented into "and".
		}),

		augend.hexcolor.new({
			case = "lower",
		}),
	}

	require("dial.config").augends:register_group({
		-- default augends used when no group name is specified
		default = augends,
		visual = augends,
	})
end
