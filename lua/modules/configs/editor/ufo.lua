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
		close_fold_kinds_for_ft = {
			default = { "imports", "comment" },
		},
		preview = {
			win_config = {
				winhighlight = "Normal:LazyNormal",
				winblend = 0,
			},
		},
		provider_selector = function(_, filetype, buftype)
			local function handleFallbackException(bufnr, err, providerName)
				if type(err) == "string" and err:match("UfoFallbackException") then
					return require("ufo").getFolds(bufnr, providerName)
				else
					return require("promise").reject(err)
				end
			end

			return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
				or function(bufnr)
					return require("ufo")
						.getFolds(bufnr, "lsp")
						:catch(function(err)
							return handleFallbackException(bufnr, err, "treesitter")
						end)
						:catch(function(err)
							return handleFallbackException(bufnr, err, "indent")
						end)
				end
		end,
		fold_virt_text_handler = handler,
	})
end
