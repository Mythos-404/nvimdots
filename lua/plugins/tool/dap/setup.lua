local dap = require("dap")
local dapui = require("dapui")
local settings = require("core.settings")

local icons = { dap = require("utils.icons").get("dap") }
local colors = require("utils.init").get_palette()

-- 调试会话开始时打开 dapui，并在被调试的 buffer 里临时挂上 K 求值
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
        if buf and vim.api.nvim_buf_is_valid(buf) then
            pcall(vim.keymap.del, "n", "K", { buffer = buf })
        end
        _G._debugging = false
        _G._debugging_buf = nil
        dapui.close()
    end
end

dap.listeners.after.event_initialized["dapui_config"] = debug_init_cb
dap.listeners.before.event_terminated["dapui_config"] = debug_terminate_cb
dap.listeners.before.event_exited["dapui_config"] = debug_terminate_cb
dap.listeners.before.disconnect["dapui_config"] = debug_terminate_cb

-- catppuccin 已集成 dap，这里只覆盖 DapStopped 的行高亮
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
        -- 没有自定义 client 定义时使用 mason-nvim-dap 的默认配置
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

require("mason-nvim-dap").setup({
    ensure_installed = settings.dap_deps,
    automatic_installation = true,
    handlers = { mason_dap_handler },
})

dapui.setup({
    force_buffers = true,
    icons = {
        expanded = require("utils.icons").get("ui").ArrowOpen,
        collapsed = require("utils.icons").get("ui").ArrowClosed,
        current_frame = require("utils.icons").get("ui").Indicator,
    },
    mappings = {
        edit = "e",
        expand = { "<Tab>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes",     size = 0.3 },
                { id = "watches",    size = 0.3 },
                { id = "stacks",     size = 0.3 },
                { id = "breakpoints", size = 0.1 },
            },
            size = 0.34,
            position = "right",
        },
        {
            elements = {
                { id = "repl",    size = 0.55 },
                { id = "console", size = 0.45 },
            },
            position = "bottom",
            size = 0.25,
        },
    },
    controls = {
        enabled = true,
        element = "repl",
        icons = {
            pause = icons.dap.Pause,
            play = icons.dap.Play,
            step_into = icons.dap.StepInto,
            step_over = icons.dap.StepOver,
            step_out = icons.dap.StepOut,
            step_back = icons.dap.StepBack,
            run_last = icons.dap.RunLast,
            terminate = icons.dap.Terminate,
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    render = { indent = 1, max_value_lines = 85 },
})

require("nvim-dap-virtual-text").setup({
    display_callback = function(variable, _, _, _, _)
        return " " .. variable.value
    end,
})

require("nvim-dap-repl-highlights").setup()
