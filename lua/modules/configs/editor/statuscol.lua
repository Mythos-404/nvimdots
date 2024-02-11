return function()
	local builtin = require("statuscol.builtin")
	require("statuscol").setup({
		relculright = true,
		segments = {
			{ sign = { name = { "GitSigns.*" }, auto = true, fillchar = "", colwidth = 1 }, click = "v:lua.ScLa" },
			{ sign = { name = { "Diagnostic" }, auto = true }, click = "v:lua.ScLa" },
			{ sign = { name = { "Dap.*" }, auto = true }, click = "v:lua.ScLa" },
			{ sign = { namespace = { ".*", " " }, auto = true } },
			{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
		},
	})
end
