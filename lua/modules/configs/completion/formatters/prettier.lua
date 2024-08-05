return {
	prepend_args = {
		("--tab-width=%s"):format(require("utils").get_indent()),
		"--trailing-comma=none",
		"--print-width=120",
	},
}
