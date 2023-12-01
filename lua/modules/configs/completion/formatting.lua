local M = {}

local settings = require("core.settings")
local disabled_workspaces = settings.format_disabled_dirs
local format_on_save = settings.format_on_save
local format_notify = settings.format_notify
local server_formatting_block_list = settings.server_formatting_block_list
local block_list = settings.formatter_block_list

local function disabled_work_dir(file_dir)
	for i = 1, #disabled_workspaces do
		if vim.regex(vim.fs.normalize(disabled_workspaces[i])):match_str(file_dir) ~= nil then
			vim.notify(
				string.format(
					"[LSP] Formatting for all files under [%s] has been disabled.",
					vim.fs.normalize(disabled_workspaces[i])
				),
				vim.log.levels.WARN,
				{ title = "LSP Formatter Warning" }
			)
			return true
		end
	end
end

local function on_format(client_name)
	return function(err)
		if format_notify then
			vim.notify(
				string.format("[LSP] Format successfully with %s!", client_name),
				vim.log.levels.INFO,
				{ title = "LSP Format Success" }
			)
		end
		if err then
			vim.notify(
				string.format("[LSP][%s] %s", client_name, err),
				vim.log.levels.ERROR,
				{ title = "LSP Format Error" }
			)
		end
	end
end

function M.enable_format_on_save(is_configured)
	local opts = { pattern = "*", timeout = 1000 }
	vim.api.nvim_create_augroup("format_on_save", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "format_on_save",
		pattern = opts.pattern,
		callback = function(args)
			if disabled_work_dir(vim.fn.expand("%:p:h")) then
				return
			end

			local conform = require("conform")
			local client = conform.list_formatters(args.bufnr)[1]
			if not client then
				vim.notify(
					"[LSP] Format request failed, no matching language servers.",
					vim.log.levels.WARN,
					{ title = "Formatting Failed" }
				)
				return
			end

			local result = conform.format({ async = false, lsp_fallback = true }, on_format(client.name))

			if not result then
				vim.notify(
					"[LSP] Format request failed, no matching language servers.",
					vim.log.levels.WARN,
					{ title = "Formatting Failed" }
				)
			end
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

vim.api.nvim_create_user_command("FormatterToggleFt", function(opts)
	if block_list[opts.args] == nil then
		vim.notify(
			string.format("[LSP] Formatter for [%s] has been recorded in list and disabled.", opts.args),
			vim.log.levels.WARN,
			{ title = "LSP Formatter Warning" }
		)
		block_list[opts.args] = true
	else
		block_list[opts.args] = not block_list[opts.args]
		vim.notify(
			string.format(
				"[LSP] Formatter for [%s] has been %s.",
				opts.args,
				not block_list[opts.args] and "enabled" or "disabled"
			),
			not block_list[opts.args] and vim.log.levels.INFO or vim.log.levels.WARN,
			{ title = string.format("LSP Formatter %s", not block_list[opts.args] and "Info" or "Warning") }
		)
	end
end, { nargs = 1, complete = "filetype" })

vim.api.nvim_create_user_command("FormatToggle", function()
	M.toggle_format_on_save()
end, {})

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

function M.configure_format_on_save()
	if format_on_save then
		M.enable_format_on_save(true)
	else
		M.disable_format_on_save(true)
	end
end

return M
