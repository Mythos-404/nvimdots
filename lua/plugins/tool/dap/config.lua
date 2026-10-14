local dap = require("dap")
local dapui = require("dapui")
local settings = require("core.settings")

local icons = { dap = require("utils.icons").get("dap") }
local colors = require("utils.init").get_palette()

local function debug_init_cb()
    _G._debugging = true
    _G._debugging_buf = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "K", function()
        require("dapui").eval()
    end, { buffer = _G._debugging_buf, desc = "debug: Evaluate under cursor" })
    dapui.open({ reset = true })
end

local function debug_terminate_cb()
    if _G._debugging then
        local buf = _G._debugging_buf
        if buf and vim.api.nvim_buf_is_valid(buf) then pcall(vim.keymap.del, "n", "K", { buffer = buf }) end
        _G._debugging = false
        _G._debugging_buf = nil
        dapui.close()
    end
end

dap.listeners.after.event_initialized["dapui_config"] = debug_init_cb
dap.listeners.before.event_terminated["dapui_config"] = debug_terminate_cb
dap.listeners.before.event_exited["dapui_config"] = debug_terminate_cb
dap.listeners.before.disconnect["dapui_config"] = debug_terminate_cb

vim.api.nvim_set_hl(0, "DapStopped", { fg = colors.green })

vim.fn.sign_define("DapBreakpoint", {
    text = icons.dap.Breakpoint,
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapBreakpointCondition", {
    text = icons.dap.BreakpointCondition,
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapStopped", {
    text = icons.dap.Stopped,
    texthl = "DapStopped",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
    text = icons.dap.BreakpointRejected,
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapLogPoint", {
    text = icons.dap.LogPoint,
    texthl = "DapLogPoint",
    linehl = "",
    numhl = "",
})

---@param config table
local function mason_dap_handler(config)
    local dap_name = config.name
    local ok, custom_handler = pcall(require, "plugins.tool.dap.clients." .. dap_name)
    if not ok then
        require("mason-nvim-dap").default_setup(config)
        return
    elseif type(custom_handler) == "function" then
        custom_handler(config)
    else
        vim.notify(
            ("Failed to setup [%s].\n\nClient definition under `plugins/tool/dap/clients` must return a fun(opts) (got '%s' instead)"):format(
                config.name,
                type(custom_handler)
            ),
            vim.log.levels.ERROR,
            { title = "nvim-dap" }
        )
    end
end

if require("core.tools").use_mason() then
    require("mason-nvim-dap").setup({
        ensure_installed = settings.dap_deps,
        automatic_installation = true,
        handlers = { mason_dap_handler },
    })
else
    for _, name in ipairs(settings.dap_deps) do
        local ok, handler = pcall(require, "plugins.tool.dap.clients." .. name)
        if ok and type(handler) == "function" then
            handler()
        else
            vim.notify("No system DAP configuration for " .. name, vim.log.levels.WARN, { title = "nvim-dap" })
        end
    end
end
