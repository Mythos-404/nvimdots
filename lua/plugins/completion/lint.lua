local Plugin = require("core.plugin")
local tools = require("core.tools")

local linters_by_ft = {
    ghaction = { "actionlint" },
    bash = { "shellcheck" },
    sh = { "shellcheck" },
}

local LINT_DEBOUNCE_MS = 300

return Plugin:new("mfussenegger/nvim-lint"):lazy(true):on("CursorHold", "CursorHoldI"):config(function()
    local lint = require("lint")

    lint.linters_by_ft = linters_by_ft

    local timer = vim.uv.new_timer()
    if not timer then return end

    local function try_lint(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end
        vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint(nil, {
                filter = function(linter)
                    local command = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
                    return tools.executable(command) ~= nil
                end,
                wrap_linter = function(linter)
                    local command = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
                    linter.cmd = tools.executable(command, true)
                    return linter
                end,
            })
        end)
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
        group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
        callback = function(ev)
            timer:start(
                LINT_DEBOUNCE_MS,
                0,
                vim.schedule_wrap(function()
                    try_lint(ev.buf)
                end)
            )
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        once = true,
        callback = function()
            timer:stop()
            timer:close()
        end,
    })
end)
