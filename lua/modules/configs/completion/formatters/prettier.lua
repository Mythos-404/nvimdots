return {
	("--tab-width=%s"):format(vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })),
	"--trailing-comma=none",
	"--print-width=120",
}
