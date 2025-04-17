local editor = {}

editor["chrisgrieser/nvim-spider"] = {
    lazy = true,
    event = "VeryLazy",
}
editor["olimorris/persisted.nvim"] = {
    lazy = true,
    cmd = {
        "SessionToggle",
        "SessionStart",
        "SessionStop",
        "SessionSave",
        "SessionLoad",
        "SessionLoadLast",
        "SessionLoadFromFile",
        "SessionDelete",
    },
    config = require("editor.persisted"),
}
editor["altermo/ultimate-autopair.nvim"] = {
    lazy = true,
    branch = "development",
    event = { "InsertEnter", "CmdlineEnter" },
    config = require("editor.ultimate-autopair"),
}
editor["folke/snacks.nvim"] = {
    priority = 1000,
    lazy = false,
    config = require("editor.snacks"),
}
editor["folke/flash.nvim"] = {
    lazy = true,
    event = "VeryLazy",
    config = require("editor.flash"),
}
editor["numToStr/Comment.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("editor.comment"),
}
editor["sindrets/diffview.nvim"] = {
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewClose" },
    config = require("editor.diffview"),
}
editor["echasnovski/mini.cursorword"] = {
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("editor.cursorword"),
}
editor["romainl/vim-cool"] = {
    lazy = true,
    event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
    lazy = true,
    cmd = { "SudaRead", "SudaWrite" },
    init = require("editor.suda"),
}
editor["echasnovski/mini.ai"] = {
    event = "VeryLazy",
    version = false,
    config = require("editor.mini-ai"),
    dependencies = "echasnovski/mini.extra",
}
editor["echasnovski/mini.align"] = {
    lazy = true,
    version = false,
    event = { "CursorHold", "CursorHoldI" },
    config = require("editor.mini-align"),
}
editor["echasnovski/mini.move"] = {
    event = "VeryLazy",
    version = false,
    config = require("editor.mini-move"),
}
editor["echasnovski/mini.surround"] = {
    lazy = true,
    version = false,
    event = { "CursorHold", "CursorHoldI" },
    config = require("editor.mini-surround"),
}
editor["monaqa/dial.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("editor.dial"),
    dependencies = "nvim-lua/plenary.nvim",
}
editor["tpope/vim-sleuth"] = {
    lazy = true,
    event = { "BufNewFile", "BufReadPost", "BufFilePost" },
}
editor["kevinhwang91/nvim-ufo"] = {
    lazy = true,
    event = "BufReadPost",
    config = require("editor.ufo"),
    dependencies = {
        { "kevinhwang91/promise-async" },
        {
            "luukvbaal/statuscol.nvim",
            config = require("editor.statuscol"),
        },
    },
}

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
    lazy = true,
    build = function()
        if #vim.api.nvim_list_uis() > 0 then vim.api.nvim_command([[ TSUpdate ]]) end
    end,
    event = "BufReadPre",
    config = require("editor.treesitter"),
    dependencies = {
        { "chrisgrieser/nvim-puppeteer" },
        { "mfussenegger/nvim-treehopper" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        {
            "danymat/neogen",
            config = require("editor.neogen"),
        },
        {
            "windwp/nvim-ts-autotag",
            config = require("editor.autotag"),
        },
        {
            "ThePrimeagen/refactoring.nvim",
            config = require("editor.refacotring"),
        },
        -- {
        --     "hiphish/rainbow-delimiters.nvim",
        --     config = require("editor.rainbow_delims"),
        -- },
        {
            "brenoprata10/nvim-highlight-colors",
            config = require("editor.highlight-colors"),
        },
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = require("editor.ts-context-commentstring"),
        },
    },
}

return editor
