local Plugin = require("core.plugin")
local map_callback = require("keymap.bind").map_callback

return Plugin:new("MagicDuck/grug-far.nvim")
    :lazy(true)
    :cmd("GrugFar")
    :opts({
        engine = "ripgrep",
        engines = {
            ripgrep = {
                path = "rg",
                showReplaceDiff = true,
                placeholders = {
                    enabled = true,
                },
            },
        },
        transient = true,
        icons = { enabled = true },
        disableBufferLineNumbers = true,
        windowCreationCommand = "bot split",
        keymaps = {
            replace = { n = ",r" },
            qflist = { n = ",q" },
            syncLocations = { n = ",s" },
            syncLine = { n = ",l" },
            close = { n = ",c" },
            historyOpen = { n = ",t" },
            historyAdd = { n = ",a" },
            refresh = { n = ",f" },
            openLocation = { n = ",o" },
            openNextLocation = { n = "<Down>" },
            openPrevLocation = { n = "<Up>" },
            gotoLocation = { n = "<Enter>" },
            pickHistoryEntry = { n = "<Enter>" },
            abort = { n = ",b" },
            help = { n = "g?" },
            toggleShowCommand = { n = ",w" },
            swapEngine = { n = ",e" },
            previewLocation = { n = ",i" },
            swapReplacementInterpreter = { n = ",x" },
            applyNext = { n = ",j" },
            applyPrev = { n = ",k" },
            syncNext = { n = ",n" },
            syncPrev = { n = ",p" },
            syncFile = { n = ",v" },
            nextInput = { n = "<Tab>" },
            prevInput = { n = "<S-Tab>" },
        },
    })
    :lazy_keys({
        ["n|<leader>Ss"] = map_callback(function()
                require("grug-far").open()
            end)
            :with_silent()
            :with_noremap()
            :with_desc("editn: Toggle search & replace panel"),
        ["n|<leader>Sp"] = map_callback(function()
                require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
            end)
            :with_silent()
            :with_noremap()
            :with_desc("editn: search&replace current word (project)"),
        ["v|<leader>Sp"] = map_callback(function()
                require("grug-far").with_visual_selection()
            end)
            :with_silent()
            :with_noremap()
            :with_desc("edit: search & replace current word (project)"),
        ["n|<leader>Sf"] = map_callback(function()
                require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
            end)
            :with_silent()
            :with_noremap()
            :with_desc("editn: search & replace current word (file)"),
    })
