local Plugin = require("core.plugin")

local icons = {
    ui = require("utils.icons").get("ui", true),
    misc = require("utils.icons").get("misc", true),
}

return Plugin:new("mason-org/mason.nvim")
    :enabled(require("core.tools").use_mason())
    :lazy(true)
    :cmd("Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog")
    :opts({
        ui = {
            border = "single",
            icons = {
                package_pending = icons.ui.Modified_alt,
                package_installed = icons.ui.Check,
                package_uninstalled = icons.misc.Ghost,
            },
            keymaps = {
                toggle_server_expand = "<CR>",
                install_server = "i",
                update_server = "u",
                check_server_version = "c",
                update_all_servers = "U",
                check_outdated_servers = "C",
                uninstall_server = "X",
                cancel_installation = "<C-c>",
            },
        },
    })
