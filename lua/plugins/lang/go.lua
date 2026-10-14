local Plugin = require("core.plugin")

return Plugin:new("ray-x/go.nvim")
    :lazy(true)
    :ft("go", "gomod")
    :dep("ray-x/guihua.lua")
    :opts({
        lsp_keymaps = false,
        dap_debug = false,
        dap_debug_gui = false,
        dap_debug_keymap = false,
        icons = false,
        gofmt = "gopls",
        goimports = "gopls",
        lsp_inlay_hints = { enable = false },
        run_in_floaterm = true,
        trouble = true,
        lsp_cfg = false,
        diagnostic = false,
    })
    :config(function(_, opts)
        -- go.nvim has no option to disable its implicit `go install` calls.
        -- Route the automatic installer through the shared availability check.
        require("go.install").install = function(name)
            return require("core.tools").executable(name) ~= nil
        end
        require("go").setup(opts)
    end)
