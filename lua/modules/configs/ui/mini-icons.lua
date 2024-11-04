return function()
    require("mini.icons").setup({
        extension = {
            ["scm"] = { glyph = "󰐅", hl = "MiniIconsGreen" },
        },
    })

    require("mini.icons").mock_nvim_web_devicons()
end
