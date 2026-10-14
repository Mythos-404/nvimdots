local Plugin = require("core.plugin")
local tools = require("core.tools")

local plugin = Plugin:new("neovim/nvim-lspconfig")
    :lazy(true)
    :on("CursorHold", "CursorHoldI")
    :dep(Plugin:new("folke/neoconf.nvim"):opts(require("plugins.completion.lspcfg.neoconfig")))
    :config(require("plugins.completion.lspcfg.lspconfig"))

if tools.use_mason() then
    plugin:dep("mason-org/mason.nvim")
    plugin:dep("mason-org/mason-lspconfig.nvim")
end

return plugin
