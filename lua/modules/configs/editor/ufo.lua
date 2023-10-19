return function()
	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

	local handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰏫 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end

	require("ufo").setup({
		open_fold_hl_timeout = 150,
		close_fold_kinds = { "imports", "comment" },
		preview = {
			win_config = {
				winhighlight = "Normal:Normal",
				winblend = 0,
			},
		},
		---@diagnostic disable-next-line: unused-local
		provider_selector = function(bufnr, filetype, buftype) -- luacheck: ignore
			return { "treesitter", "indent" }
		end,
		fold_virt_text_handler = handler,
	})

	local builtin = require("statuscol.builtin")
	require("statuscol").setup({
		relculright = true,
		segments = {
			{ sign = { name = { "GitSigns.*" }, auto = true, fillchar = "", colwidth = 1 }, click = "v:lua.ScLa" },
			{ sign = { name = { "Diagnostic" }, auto = true }, click = "v:lua.ScLa" },
			{ sign = { name = { "Dap.*" }, auto = true }, click = "v:lua.ScLa" },
			{ sign = { namespace = { ".*" }, auto = true } },
			{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
		},
	})
end
