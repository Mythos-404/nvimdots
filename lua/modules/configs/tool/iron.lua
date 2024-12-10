return function()
    require("iron").core.setup({
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
        },
    })
end
