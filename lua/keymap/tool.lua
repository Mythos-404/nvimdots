---@diagnostic disable: undefined-field
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode
require("keymap.helpers")

local plug_map = {
	-- Plugin: dial
	["n|<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "normal")
	end),
	["n|<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "normal")
	end),
	["v|<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "visual")
	end),
	["v|<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "visual")
	end),
	["n|g<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "gnormal")
	end),
	["n|g<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "gnormal")
	end),
	["v|g<C-a>"] = map_callback(function()
		require("dial.map").manipulate("increment", "gvisual")
	end),
	["v|g<C-x>"] = map_callback(function()
		require("dial.map").manipulate("decrement", "gvisual")
	end),

	["n|<A-C-a>"] = map_cmd(require("dial.map").inc_normal("extra")):with_noremap(),
	["n|<A-C-x>"] = map_cmd(require("dial.map").dec_normal("extra")):with_noremap(),

	-- Plugin: nvim-tree
	["n|<C-S-n>"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	-- ["n|<leader>nf"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("filetree: Find file"),
	-- ["n|<leader>nr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent():with_desc("filetree: Refresh"),
	-- Plugin: mini.files
	["n|<C-n>"] = map_cmd("<Cmd>lua if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("filetree: Open mini.files"),

	-- Plugin: sniprun
	["v|<leader>r"] = map_cr("SnipRun"):with_noremap():with_silent():with_desc("tool: Run code by range"),
	["n|<leader>r"] = map_cu([[%SnipRun]]):with_noremap():with_silent():with_desc("tool: Run code by file"),

	-- Plugin: toggleterm
	["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(), -- switch to normal mode in terminal.
	["n|<C-\\>"] = map_cr("ToggleTerm direction=horizontal")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["t|<C-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle horizontal"),
	["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["t|<A-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
	["n|<A-d>"] = map_cr("ToggleTerm direction=float"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
	["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["t|<A-d>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
	["n|<leader>gg"] = map_callback(function()
			_toggle_lazygit()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("git: Toggle lazygit"),

	-- Plugin: trouble
	["n|gt"] = map_cr("TroubleToggle"):with_noremap():with_silent():with_desc("lsp: Toggle trouble list"),
	["n|<leader>ll"] = map_cr("TroubleToggle lsp_references")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show lsp references"),
	["n|<leader>ld"] = map_cr("TroubleToggle document_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show document diagnostics"),
	["n|<leader>lw"] = map_cr("TroubleToggle workspace_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show workspace diagnostics"),
	["n|<leader>lq"] = map_cr("TroubleToggle quickfix")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show quickfix list"),
	["n|<leader>lL"] = map_cr("TroubleToggle loclist"):with_noremap():with_silent():with_desc("lsp: Show loclist"),

	-- Plugin: telescope
	["n|<C-A-p>"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),
	["n|<leader>fu"] = map_callback(function()
			require("telescope").extensions.undo.undo()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("edit: Show undo history"),
	["n|<leader>fw"] = map_callback(function()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: Word in project"),
	["n|<leader>ff"] = map_callback(function()
			require("search").open({ collection = "file" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: File in project"),
	["n|<leader>fc"] = map_cu("Telescope colorscheme")
		:with_noremap()
		:with_silent()
		:with_desc("ui: Change colorscheme for current session"),
	["n|<leader>bn"] = map_cu(":enew"):with_noremap():with_silent():with_desc("buffer: New"),
	["n|<leader>fg"] = map_callback(function()
			require("search").open({ collection = "git" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: Git related search"),
	["n|<leader>fb"] = map_cu("Telescope buffers"):with_noremap():with_silent():with_desc("find: Buffer opened"),
	["n|<leader>fs"] = map_cu("Telescope grep_string"):with_noremap():with_silent():with_desc("find: Current word"),
	["n|<leader>fd"] = map_callback(function()
			require("search").open({ collection = "workspace" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: Session, Project and Directory"),

	-- Plugin: dap
	["n|<F5>"] = map_callback(function()
			require("dap").continue()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run/Continue"),
	["n|<F6>"] = map_callback(function()
			require("dap").terminate()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Stop"),
	["n|<F7>"] = map_callback(function()
			require("dap").toggle_breakpoint()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Toggle breakpoint"),
	["n|<F8>"] = map_callback(function()
			require("dap").step_into()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step into"),
	["n|<F9>"] = map_callback(function()
			require("dap").step_out()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step out"),
	["n|<F10>"] = map_callback(function()
			require("dap").step_over()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step over"),
	["n|<leader>db"] = map_callback(function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Set breakpoint with condition"),
	["n|<leader>dc"] = map_callback(function()
			require("dap").run_to_cursor()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run to cursor"),
	["n|<leader>dl"] = map_callback(function()
			require("dap").run_last()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run last"),
	["n|<leader>do"] = map_callback(function()
			require("dap").repl.open()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Open REPL"),

	-- todo-comments plug_map
	["n|]t"] = map_callback(function()
			require("todo-comments").jump_next()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("todo: jump next todo comment"),
	["n|[t"] = map_callback(function()
			require("todo-comments").jump_prev()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("todo: Jump prev todo comment"),
	["n|<leader>ft"] = map_cr("TodoTelescope")
		:with_noremap()
		:with_silent()
		:with_desc("todo: Search through with Telescope"),

	-- Public dropbar
	["n|<C-m>"] = map_callback(function()
			require("dropbar.api").pick()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Dropbar Pick"),
}

bind.nvim_load_mapping(plug_map)
