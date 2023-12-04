local M = {}

local conform = require("conform")
local settings = require("core.settings")
local disabled_workspaces = settings.format_disabled_dirs
local format_on_save = settings.format_on_save
local format_notify = settings.format_notify
local block_list = settings.formatter_block_list

vim.api.nvim_create_user_command("FormatToggle", function()
	if vim.g.disable_autoformat then
		vim.g.disable_autoformat = false
		vim.notify(
			"Successfully enabled format-on-save",
			vim.log.levels.INFO,
			{ title = "Settings modification success" }
		)
	else
		vim.g.disable_autoformat = true
		vim.notify(
			"Successfully disabled format-on-save",
			vim.log.levels.INFO,
			{ title = "Settings modification success" }
		)
	end
end, {})

vim.api.nvim_create_user_command("FormatterToggleFt", function(opts)
	if block_list[opts.args] == nil then
		vim.notify(
			("[LSP] Formatter for [%s] has been recorded in list and disabled."):format(opts.args),
			vim.log.levels.WARN,
			{ title = "LSP Formatter Warning" }
		)
		block_list[opts.args] = true
	else
		block_list[opts.args] = not block_list[opts.args]
		vim.notify(
			("[LSP] Formatter for [%s] has been %s."):format(
				opts.args,
				not block_list[opts.args] and "enabled" or "disabled"
			),
			not block_list[opts.args] and vim.log.levels.INFO or vim.log.levels.WARN,
			{ title = ("LSP Formatter %s"):format(not block_list[opts.args] and "Info" or "Warning") }
		)
	end
end, { nargs = 1, complete = "filetype" })

local function format(bufnr)
	if vim.g.disable_autoformat then
		return
	end

	local clients = conform.list_formatters(bufnr)
	if #clients == 0 then
		return
	end

	for i = 1, #disabled_workspaces do
		if vim.regex(vim.fs.normalize(disabled_workspaces[i])):match_str(vim.fn.expand("%:p:h")) ~= nil then
			vim.notify(
				("[LSP] Formatting for all files under [%s] has been disabled."):format(
					vim.fs.normalize(disabled_workspaces[i])
				),
				vim.log.levels.WARN,
				{ title = "LSP Formatter Warning" }
			)
			return true
		end
	end

	for _, client in pairs(clients) do
		if block_list[vim.bo.filetype] == true then
			vim.notify(
				string.format(
					"[LSP][%s] Formatting for [%s] has been disabled. This file is not being processed.",
					client.name,
					vim.bo.filetype
				),
				vim.log.levels.WARN,
				{ title = "LSP Formatter Warning" }
			)
			return
		end
	end

	local function on_format(err)
		for _, client in pairs(clients) do
			if format_notify then
				vim.notify(
					("[LSP] Format successfully with %s!"):format(client.name),
					vim.log.levels.INFO,
					{ title = "LSP Format Success" }
				)
			end
		end
		if err then
			return
		end
	end
	return { timeout_ms = 500, lsp_fallback = true }, on_format
end

function M.configure_format_on_save()
	if format_on_save then
		vim.g.disable_autoformat = false
	else
		vim.g.disable_autoformat = true
	end

	conform.setup({
		format_on_save = format,
	})
end

return M
