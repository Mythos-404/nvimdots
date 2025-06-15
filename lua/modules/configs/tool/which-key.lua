return function()
    local icons = {
        ui = require("modules.utils.icons").get("ui"),
        misc = require("modules.utils.icons").get("misc"),
        git = require("modules.utils.icons").get("git", true),
        cmp = require("modules.utils.icons").get("cmp", true),
        aichat = require("modules.utils.icons").get("aichat", true),
    }

    require("which-key").setup({
        preset = "helix",
        delay = vim.o.timeoutlen,
        triggers = {
            { "<auto>", mode = "nixso" },
        },
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                motions = false,
                operators = false,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        win = {
            wo = { winblend = 0 },
        },
        expand = 1,
        icons = {
            group = "",
            rules = false,
            colors = true,
            breadcrumb = icons.ui.Separator,
            separator = icons.misc.Vbar,
            keys = {
                C = "C-",
                M = "A-",
                S = "S-",
                BS = "<BS> ",
                CR = "<CR> ",
                NL = "<NL> ",
                Esc = "<Esc> ",
                Tab = "<Tab> ",
                Up = "<Up> ",
                Down = "<Down> ",
                Left = "<Left> ",
                Right = "<Right> ",
                Space = "<Space> ",
                ScrollWheelUp = "<ScrollWheelUp> ",
                ScrollWheelDown = "<ScrollWheelDown> ",
            },
        },
        spec = {
            { "<leader>b", mode = "n", group = "Buffer", icon = icons.ui.Buffer },
            { "<leader>d", mode = "n", group = "Debug", icon = icons.ui.Bug },
            { "<leader>f", mode = "n", group = "Fuzzy Find", icon = icons.ui.Telescope },
            { "<leader>g", mode = "n", group = "Git", icon = icons.git.Git },
            { "<leader>l", mode = "n", group = "Lsp", icon = icons.misc.LspAvailable },
            { "<leader>n", mode = "n", group = "Nvim Tree", icon = icons.ui.FolderOpen },
            { "<leader>p", mode = "n", group = "Package", icon = icons.ui.Package },
            { "<leader>S", mode = "n", group = "Search", icon = icons.ui.Search },
            { "<leader>s", mode = "n", group = "Session", icon = icons.cmp.tmux },
            { "<leader>W", mode = "n", group = "Window", icon = icons.ui.Window },
            { "<leader>c", mode = "n", group = "Chat", icon = icons.aichat.Chat },

            { "<leader>R", mode = "nx", group = "Refactor", icon = "" },
            { "<leader>c", mode = "nx", group = "Repl", icon = "" },
            { "<leader>r", mode = "nx", icon = icons.misc.CodeRunAll },

            { "<leader>o", mode = "n", icon = icons.ui.Pencil },
        },
    })
end
