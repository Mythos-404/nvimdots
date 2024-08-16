return function()
	require("ufo").setup({
		enable_get_fold_virt_text = true,
		open_fold_hl_timeout = 150,
		close_fold_kinds_for_ft = {
			default = { "imports" },
			c = { "region" },
			cpp = { "region" },
		},
		preview = {
			win_config = {
				winhighlight = "Normal:LazyNormal",
				winblend = 0,
			},
		},
		provider_selector = function(_, _)
			return { "treesitter", "indent" }
		end,
		fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate, ctx)
			local new_virt_text = {}
			local suffix = (" 󰁂 %d "):format(end_lnum - lnum)
			local suf_width = vim.fn.strdisplaywidth(suffix)
			local target_width = width - suf_width
			local cur_width = 0
			for _, chunk in ipairs(virt_text) do
				local chunk_text = chunk[1]
				local chunk_width = vim.fn.strdisplaywidth(chunk_text)
				if target_width > cur_width + chunk_width then
					table.insert(new_virt_text, chunk)
				else
					chunk_text = truncate(chunk_text, target_width - cur_width)
					local hl_group = chunk[2]
					table.insert(new_virt_text, { chunk_text, hl_group })
					chunk_width = vim.fn.strdisplaywidth(chunk_text)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if cur_width + chunk_width < target_width then
						suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
					end
					break
				end
				cur_width = cur_width + chunk_width
			end
			table.insert(new_virt_text, { " ⋯ " })
			vim.iter(ctx.get_fold_virt_text(end_lnum))
				:filter(function(text)
					return text[1]:find("\t") == nil and true or false
				end)
				:map(function(text)
					table.insert(new_virt_text, text)
				end)

			table.insert(new_virt_text, { suffix, "MoreMsg" })
			return new_virt_text
		end,
	})
end
