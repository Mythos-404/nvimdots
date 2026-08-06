local Plugin = require("core.plugin")

local icons = {
    ui = require("utils.icons").get("ui"),
    misc = require("utils.icons").get("misc"),
    git = require("utils.icons").get("git", true),
    cmp = require("utils.icons").get("cmp", true),
    aichat = require("utils.icons").get("aichat", true),
    kind = require("utils.icons").get("kind", true),
}

return Plugin:new("folke/which-key.nvim")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :opts({
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
            border = "none",
            padding = { 1, 2 },
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
            { "<leader>t", mode = "n", group = "Terminal", icon = icons.kind.Terminal },

            { "<leader>R", mode = "nx", group = "Refactor", icon = "" },
            { "<C-c>", mode = "nx", group = "Repl", icon = "" },
            { "<leader>r", mode = "nx", group = "Code Run", icon = icons.misc.CodeRunAll },

            { "<leader>o", mode = "n", icon = icons.ui.Pencil },
        },
    })
