---@diagnostic disable: undefined-field
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local plug_map = {
    -- Plugin: mini.files
    ["n|<C-n>"] = map_callback(function()
            _mini_file_open()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("files: Toggle"),

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

    -- Plugin: trouble
    ["n|gt"] = map_cr("Trouble diagnostics toggle"):with_noremap():with_silent():with_desc("lsp: Toggle trouble list"),
    ["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
        :with_noremap()
        :with_silent()
        :with_desc("lsp: Show workspace diagnostics"),
    ["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
        :with_noremap()
        :with_silent()
        :with_desc("lsp: Show project diagnostics"),
    ["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
        :with_noremap()
        :with_silent()
        :with_desc("lsp: Show document diagnostics"),

    -- Plugin: telescope
    ["n|<C-A-p>"] = map_callback(function()
            _command_panel()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Toggle command panel"),
    ["n|<leader>ff"] = map_callback(function()
            require("search").open({ collection = "file" })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Find files"),
    ["n|<leader>fp"] = map_callback(function()
            require("search").open({ collection = "pattern" })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Find patterns"),
    ["v|<leader>fs"] = map_cu("Telescope grep_string")
        :with_noremap()
        :with_silent()
        :with_desc("tool: Find word under cursor"),
    ["n|<leader>fg"] = map_callback(function()
            require("search").open({ collection = "git" })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Locate Git objects"),
    ["n|<leader>fd"] = map_callback(function()
            require("search").open({ collection = "dossier" })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Retrieve dossiers"),
    ["n|<leader>fm"] = map_callback(function()
            require("search").open({ collection = "misc" })
        end)
        :with_noremap()
        :with_silent()
        :with_desc("tool: Miscellaneous"),

    -- Plugin: dap
    ["n|<F5>"] = map_callback(function()
            _async_compile_and_debug()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Run/Continue"),
    ["n|<C-F5>"] = map_callback(function()
            require("dap").terminate()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Stop"),
    ["n|<F6>"] = map_callback(function()
            require("dap").toggle_breakpoint()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Toggle breakpoint"),
    ["n|<F7>"] = map_callback(function()
            require("dap").step_into()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Step into"),
    ["n|<F8>"] = map_callback(function()
            require("dap").step_over()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Step over"),
    ["n|<C-F8>"] = map_callback(function()
            require("dap").step_out()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("debug: Step out"),
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

    -- Plugin: todo-comments.nvim
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

    -- Plugin: rip-substitute.nvim
    ["nv|S"] = map_callback(function()
        require("rip-substitute").sub()
    end):with_silent(),

    -- Plugin: traduire.nvim
    ["v|<A-C-t>"] = map_cmd("<Cmd>lua Traduire.user.to_cn()<CR>")
        :with_noremap()
        :with_silent()
        :with_desc("translate: To CN"),
    ["n|<A-C-t>"] = map_cmd("<Cmd>lua Traduire.user.to_en()<CR>")
        :with_noremap()
        :with_silent()
        :with_desc("translate: To EN"),

    -- iron.nvim
    ["n|<C-c><C-f>"] = map_callback(function()
            require("iron.core").send_file()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send file"),
    ["n|<C-c><C-c>"] = map_callback(function()
            require("iron.core").send_line()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send line"),
    ["v|<C-c><C-c>"] = map_callback(function()
            require("iron.core").visual_send()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Visual send"),
    ["n|<C-c><C-m>"] = map_callback(function()
            require("iron.core").run_motion("send_motion")
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send motion"),
    ["n|<C-c><C-p>"] = map_callback(function()
            require("iron.core").send_paragraph()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send paragraph"),
    ["n|<C-c><C-CR>"] = map_callback(function()
            require("iron.core").send(nil, string.char(13))
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send <CR>"),
    ["n|<C-c><C-l>"] = map_callback(function()
            require("iron.core").send(nil, string.char(12))
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Send clear"),
    ["n|<C-c><C-d>"] = map_callback(function()
            require("iron.core").close_repl()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("repl: Close repl"),
}

bind.nvim_load_mapping(plug_map)
