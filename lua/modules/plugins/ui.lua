local ui = {}

ui["goolord/alpha-nvim"] = {
    lazy = true,
    event = "BufWinEnter",
    config = require("ui.alpha"),
}
ui["Mythos-404/nvim"] = {
    lazy = false,
    branch = "refactor/syntax-highlighting",
    name = "catppuccin",
    config = require("ui.catppuccin"),
}
ui["akinsho/bufferline.nvim"] = {
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("ui.bufferline"),
}
ui["nvim-lualine/lualine.nvim"] = {
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("ui.lualine"),
}
ui["dstein64/nvim-scrollview"] = {
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("ui.scrollview"),
}
ui["rcarriga/nvim-notify"] = {
    lazy = true,
    event = "VeryLazy",
    config = require("ui.notify"),
}
ui["lewis6991/gitsigns.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("ui.gitsigns"),
}
ui["j-hui/fidget.nvim"] = {
    lazy = true,
    event = "LspAttach",
    config = require("ui.fidget"),
}
ui["Bekaboo/dropbar.nvim"] = {
    lazy = true,
    event = "VeryLazy",
    config = require("ui.dropbar"),
}
ui["lukas-reineke/indent-blankline.nvim"] = {
    lazy = true,
    tag = "v3.8.2",
    event = { "CursorHold", "CursorHoldI" },
    config = require("ui.indent-blankline"),
}
ui["mrjones2014/smart-splits.nvim"] = {
    lazy = true,
    event = { "CursorHoldI", "CursorHold" },
    config = require("ui.smart-splits"),
}
ui["folke/todo-comments.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("ui.todo-comments"),
}
ui["m-demare/hlargs.nvim"] = {
    lazy = true,
    event = "BufReadPost",
    config = require("ui.hlargs"),
}
ui["echasnovski/mini.icons"] = {
    lazy = true,
    event = "VeryLazy",
    config = require("ui.mini-icons"),
}
ui["stevearc/dressing.nvim"] = {
    event = "VeryLazy",
    config = require("ui.dressing"),
}
ui["ojroques/nvim-bufdel"] = {
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}

return ui
