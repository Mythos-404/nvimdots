local Plugin = require("core.plugin")

local map_callback = require("keymap.bind").map_callback

return Plugin:new("Vigemus/iron.nvim")
    :lazy(true)
    :on("VeryLazy")
    :config(function(plugin, opts)
        require("iron").setup({
            config = {
                scratch_repl = true,
                repl_definition = {
                    sh = { command = { "sh" } },
                    bash = { command = { "bash" } },
                    zsh = { command = { "zsh" } },
                    lua = { command = { "lua" } },
                    python = require("iron.fts.python").ipython,
                },
                repl_open_cmd = require("iron.view").offset({
                    width = math.floor(vim.o.columns * 0.3),
                    height = math.floor(vim.o.lines * 0.75),
                    w_offset = "100%",
                    h_offset = 0,
                }),
            }
        })
    end)
    :lazy_keys({
        ["n|<C-c><C-f>"] = map_callback(function()
                require("iron.core").send_file()
            end)
            :with_desc("repl: Send file"),
        ["n|<C-c><C-c>"] = map_callback(function()
                require("iron.core").send_line()
            end)
            :with_desc("repl: Send line"),
        ["v|<C-c><C-c>"] = map_callback(function()
                require("iron.core").visual_send()
            end)
            :with_desc("repl: Visual send"),
        ["n|<C-c><C-m>"] = map_callback(function()
                require("iron.core").run_motion("send_motion")
            end)
            :with_desc("repl: Send motion"),
        ["n|<C-c><C-p>"] = map_callback(function()
                require("iron.core").send_paragraph()
            end)
            :with_desc("repl: Send paragraph"),
        ["n|<C-c><C-CR>"] = map_callback(function()
                require("iron.core").send(nil, string.char(13))
            end)
            :with_desc("repl: Send <CR>"),
        ["n|<C-c><C-l>"] = map_callback(function()
                require("iron.core").send(nil, string.char(12))
            end)
            :with_desc("repl: Send clear"),
        ["n|<C-c><C-d>"] = map_callback(function()
                require("iron.core").close_repl()
            end)
            :with_desc("repl: Close repl"),
    })
