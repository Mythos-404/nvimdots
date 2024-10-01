local M = {}

local settings = require("core.settings")
local format_on_save = settings.format_on_save
local disabled_workspaces = settings.format_disabled_dirs
local format_notify = settings.format_notify
local block_list = settings.formatter_block_list

vim.api.nvim_create_user_command("FormatToggle", function()
	M.toggle_format_on_save()
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

function M.enable_format_on_save(is_configured)
	local opts = { pattern = "*", timeout = 800 }
	vim.api.nvim_create_augroup("format_on_save", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "format_on_save",
		pattern = opts.pattern,
		callback = function()
			require("completion.formatting").format({ timeout_ms = opts.timeout })
		end,
	})
	if not is_configured then
		vim.notify(
			"Successfully enabled format-on-save",
			vim.log.levels.INFO,
			{ title = "Settings modification success" }
		)
	end
end

function M.disable_format_on_save(is_configured)
	pcall(vim.api.nvim_del_augroup_by_name, "format_on_save")
	if not is_configured then
		vim.notify(
			"Successfully disabled format-on-save",
			vim.log.levels.INFO,
			{ title = "Settings modification success" }
		)
	end
end

function M.configure_format_on_save()
	if format_on_save then
		M.enable_format_on_save(true)
	else
		M.disable_format_on_save(true)
	end
end

function M.toggle_format_on_save()
	local status = pcall(vim.api.nvim_get_autocmds, {
		group = "format_on_save",
		event = "BufWritePre",
	})
	if not status then
		M.enable_format_on_save(false)
	else
		M.disable_format_on_save(false)
	end
end

function M.format(opts)
	local conform = require("conform")
	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.iter(conform.list_formatters_to_run(bufnr))
		:filter(function(client)
			return client.name ~= "injected"
		end)
		:totable()
	if next(clients) == nil then
		vim.notify(
			"[LSP] Format request failed, no matching language servers.",
			vim.log.levels.WARN,
			{ title = "Formatting Failed" }
		)
		return
	end

	local file_dir = vim.fn.expand("%:p:h")
	for i = 1, #disabled_workspaces do
		if vim.regex(vim.fs.normalize(disabled_workspaces[i])):match_str(file_dir) ~= nil then
			vim.notify(
				("[LSP] Formatting for all files under [%s] has been disabled.").format(
					vim.fs.normalize(disabled_workspaces[i])
				),
				vim.log.levels.WARN,
				{ title = "LSP Formatter Warning" }
			)
			return
		end
	end

	for _, client in pairs(clients) do
		if block_list[vim.bo.filetype] == true then
			vim.notify(
				("[LSP][%s] Formatting for [%s] has been disabled. This file is not being processed."):format(
					client.name,
					vim.bo.filetype
				),
				vim.log.levels.WARN,
				{ title = "LSP Formatter Warning" }
			)
			return
		end
	end

	conform.format({
		async = false,
		quiet = true,
		lsp_format = "fallback",
		bufnr = bufnr,
		timeout_ms = opts.timeout_ms,
	}, function(err)
		local client_names = table.concat(
			vim.iter(clients):fold({}, function(acc, client)
				table.insert(acc, client.name)
				return acc
			end),
			", "
		)
		if format_notify and not err then
			vim.notify(
				("[LSP] Format successfully with [%s]!"):format(client_names),
				vim.log.levels.INFO,
				{ title = "LSP Format Success" }
			)
		else
			vim.notify(("[LSP][%s] %s"):format(client_names, err), vim.log.levels.ERROR, { title = "LSP Format Error" })
		end
	end)
end

return M
