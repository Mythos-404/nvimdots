local Plugin = require("core.plugin")

local map_cr = require("keymap.bind").map_cr
local map_cu = require("keymap.bind").map_cu

return Plugin:new("michaelb/sniprun")
    :enabled(not require("core.global").is_windows)
    :lazy(true)
    :build("bash ./install.sh")
    :on("BufReadPost", "BufAdd", "BufNewFile")
    :opts({
        selected_interpreters = {}, -- " use those instead of the default for the current filetype
        repl_enable = {},           -- " enable REPL-like behavior for the given interpreters
        repl_disable = {},          -- " disable REPL-like behavior for the given interpreters
        interpreter_options = {},   -- " intepreter-specific options, consult docs / :SnipInfo <name>
        -- " you can combo different display modes as desired
        display = {
            "TempFloatingWindowOk", -- display ok results in the floating window
            "NvimNotifyErr",        -- display err results with the nvim-notify plugin
            -- "Classic", -- display results in the command line"
            -- "VirtualText", -- display results in virtual text"
            -- "LongTempFloatingWindow", -- display results in the long floating window
            -- "Terminal" -- display results in a vertical split
            -- "TerminalWithCode" -- display results and code history in a vertical split
        },
        display_options = {
            terminal_width = 45,
            notification_timeout = 5000,
        },
        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything
        borders = "single",  -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
    })
    :lazy_keys({
        ["v|<leader>r"] = map_cr("SnipRun"):with_desc("tool: Run code by range"),
        ["n|<leader>r"] = map_cu([[%SnipRun]]):with_desc("tool: Run code by file"),
    })
