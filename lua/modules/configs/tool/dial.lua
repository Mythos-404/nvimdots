return function()
	local augend = require("dial.augend")
	local augends = {
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%Y年%-m月%-d日"],
		augend.date.alias["%H:%M"],

		augend.integer.alias.decimal_int,
		augend.integer.alias.hex, -- nonnegative hex number  (0x00, 0x1a1f, etc.)
		augend.integer.alias.octal, -- nonnegative octal number  (0o00, 0o24, etc.)
		augend.integer.alias.binary, -- nonnegative hex number  (0b01, 0b10010, etc.)

		augend.semver.alias.semver,

		augend.constant.alias.bool,
		augend.constant.new({ elements = { "True", "False" } }),
		augend.constant.new({ elements = { "enable", "disable" } }),
		augend.constant.new({ elements = { "yes", "no" } }),
		augend.constant.new({ elements = { "&&", "||" } }),
		augend.constant.new({ elements = { "and", "or" } }),

		augend.hexcolor.new({ case = "lower" }),
	}

	require("dial.config").augends:register_group({
		-- default augends used when no group name is specified
		default = augends,
		visual = augends,

		extra = {
			augend.case.new({
				types = { "snake_case", "camelCase", "PascalCase" },
				cyclic = true,
			}),
		},
	})
end
