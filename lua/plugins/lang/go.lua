local Plugin = require("core.plugin")

return Plugin:new("ray-x/go.nvim")
    :lazy(true)
    :ft("go", "gomod")
    :dep("ray-x/guihua.lua")
    :build(":lua require('go.install').update_all_sync()")
    :opts({
        lsp_keymaps = false,
        dap_debug_keymap = false,
        icons = false,
        gofmt = "gopls",
        goimports = "gopls",
        lsp_gofumpt = "true",
        lsp_inlay_hints = { enable = false },
        run_in_floaterm = true,
        trouble = true,
        lsp_cfg = {
            flags = { debounce_text_changes = 500 },
            cmd = { "gopls", "-remote=auto" },
            settings = {
                gopls = {
                    usePlaceholders = true,
                    analyses = {
                        nilness = true,
                        shadow = true,
                        unusedparams = true,
                        unusewrites = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        },
    })
