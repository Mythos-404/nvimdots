return function()
	local ns_mini_files = vim.api.nvim_create_namespace("mini_files_git")
	local autocmd = vim.api.nvim_create_autocmd
	local mini_files = require("mini.files")

	-- Cache for git status
	local git_status_cache = {}
	local cache_timeout = 2000 -- Cache timeout in milliseconds

	local function fetch_git_status(cwd, callback)
		local stdout = vim.loop.new_pipe(false)
		local _, _ = vim.loop.spawn(
			"git",
			---@diagnostic disable-next-line: missing-fields
			{
				args = { "status", "--ignored", "--porcelain" },
				cwd = cwd,
				stdio = { nil, stdout, nil },
			},
			vim.schedule_wrap(function(code, _)
				if stdout == nil then
					return
				end

				if code ~= 0 then
					vim.notify("Git command failed with exit code: " .. code, vim.log.levels.ERROR)
					stdout:close()
				end

				stdout:read_start(function(_, content)
					if content then
						callback(content)
						vim.g.content = content
					end
					stdout:close()
				end)
			end)
		)
	end

	local function update_mini_with_git(buf_id, git_status_map)
		vim.schedule(function()
			local nlines = vim.api.nvim_buf_line_count(buf_id)
			local cwd = vim.fn.getcwd() --  vim.fn.expand("%:p:h")
			local str = cwd
			local escapedcwd = str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
			if vim.fn.has("win32") == 1 then
				escapedcwd = escapedcwd:gsub("\\", "/")
			end

			for i = 1, nlines do
				local entry = mini_files.get_fs_entry(buf_id, i)
				if not entry then
					break
				end

				local status = git_status_map[entry.path:gsub("^" .. escapedcwd .. "/", "")]
				if status then
					local status_map = {
						[" M"] = { symbol = "•", hl_group = "MiniDiffSignChange" }, -- Modified in the working directory
						["M "] = { symbol = "✹", hl_group = "MiniDiffSignChange" }, -- modified in index
						["MM"] = { symbol = "≠", hl_group = "MiniDiffSignChange" }, -- modified in both working tree and index
						["A "] = { symbol = "+", hl_group = "MiniDiffSignAdd" }, -- Added to the staging area, new file
						["AA"] = { symbol = "≈", hl_group = "MiniDiffSignAdd" }, -- file is added in both working tree and index
						["D "] = { symbol = "-", hl_group = "MiniDiffSignDelete" }, -- Deleted from the staging area
						["AM"] = { symbol = "⊕", hl_group = "MiniDiffSignChange" }, -- added in working tree, modified in index
						["AD"] = { symbol = "-•", hl_group = "MiniDiffSignChange" }, -- Added in the index and deleted in the working directory
						["R "] = { symbol = "→", hl_group = "MiniDiffSignChange" }, -- Renamed in the index
						["U "] = { symbol = "‖", hl_group = "MiniDiffSignChange" }, -- Unmerged path
						["UU"] = { symbol = "⇄", hl_group = "MiniDiffSignAdd" }, -- file is unmerged
						["UA"] = { symbol = "⊕", hl_group = "MiniDiffSignAdd" }, -- file is unmerged and added in working tree
						["??"] = { symbol = "?", hl_group = "MiniDiffSignDelete" }, -- Untracked files
						["!!"] = { symbol = "!", hl_group = "MiniDiffSignChange" }, -- Ignored files
					}
					local result = status_map[status] or { symbol = "?", hl_group = "NonText" }
					local symbol, hl_group = result.symbol, result.hl_group
					vim.api.nvim_buf_set_extmark(buf_id, ns_mini_files, i - 1, 0, {
						sign_text = symbol,
						sign_hl_group = hl_group,
						priority = 2,
					})
				end
			end
		end)
	end

	autocmd("User", {
		group = vim.api.nvim_create_augroup("MiniFiles_start", { clear = true }),
		pattern = "MiniFilesExplorerOpen",
		-- pattern = { "minifiles" },
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local buf_id = bufnr
			if vim.fn.isdirectory(".git") == 0 then
				return
			end
			local cwd = vim.fn.expand("%:p:h")
			local current_time = os.time()
			if git_status_cache[cwd] and current_time - git_status_cache[cwd].time < cache_timeout then
				update_mini_with_git(buf_id, git_status_cache[cwd].statusMap)
			else
				fetch_git_status(cwd, function(content)
					local git_status_map = {}
					-- lua match is faster than vim.split (in my experience )
					for line in content:gmatch("[^\r\n]+") do
						local status, file_path = string.match(line, "^(..)%s+(.*)")
						-- Split the file path into parts
						local parts = {}
						for part in file_path:gmatch("[^/]+") do
							table.insert(parts, part)
						end
						-- Start with the root directory
						local current_key = ""
						for i, part in ipairs(parts) do
							if i > 1 then
								-- Concatenate parts with a separator to create a unique key
								current_key = current_key .. "/" .. part
							else
								current_key = part
							end
							-- If it's the last part, it's a file, so add it with its status
							if i == #parts then
								git_status_map[current_key] = status
							else
								-- If it's not the last part, it's a directory. Check if it exists, if not, add it.
								if not git_status_map[current_key] then
									git_status_map[current_key] = status
								end
							end
						end
					end
					git_status_cache[cwd] = {
						time = current_time,
						status_map = git_status_map,
					}
					update_mini_with_git(buf_id, git_status_map)
				end)
			end
		end,
	})

	autocmd("User", {
		group = vim.api.nvim_create_augroup("MiniFiles_close", { clear = true }),
		pattern = "MiniFilesExplorerClose",
		callback = function()
			git_status_cache = {}
		end,
	})

	autocmd("User", {
		group = vim.api.nvim_create_augroup("MiniFiles_update", { clear = true }),
		pattern = "MiniFilesBufferUpdate",
		callback = function(sii)
			local bufnr = sii.data.buf_id
			local cwd = vim.fn.expand("%:p:h")
			if git_status_cache[cwd] then
				update_mini_with_git(bufnr, git_status_cache[cwd].status_map)
			end
		end,
	})

	mini_files.setup({
		-- Customization of shown content
		content = {
			-- Predicate for which file system entries to show
			filter = function(fs_entry)
				if fs_entry.name == ".git" then
					return false
				end
				return true
			end,
			-- What prefix to show to the left of file system entry
			prefix = nil,
			-- In which order to show file system entries
			sort = nil,
		},

		-- Module mappings created only inside explorer.
		-- Use `''` (empty string) to not create one.
		mappings = {
			close = "q",
			go_in = "l",
			go_in_plus = "L",
			go_out = "h",
			go_out_plus = "H",
			reset = "<BS>",
			reveal_cwd = "@",
			show_help = "g?",
			synchronize = "=",
			trim_left = "<",
			trim_right = ">",
		},

		-- General options
		options = {
			-- Whether to delete permanently or move into module-specific trash
			permanent_delete = true,
			-- Whether to use for editing directories
			use_as_default_explorer = true,
		},

		-- Customization of explorer windows
		windows = {
			-- Maximum number of windows to show side by side
			max_number = math.huge,
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of focused window
			width_focus = 60,
			-- Width of non-focused window
			width_nofocus = 40,
			-- Width of preview window
			width_preview = 60,
		},
	})
end
