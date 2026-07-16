local event = {}

---@param group string
---@param opts table
local function autocmd(group, opts)
    local ev = opts.event
    opts.event = nil
    local clear = opts.clear
    if clear == nil then clear = true end
    opts.clear = nil
    opts.group = vim.api.nvim_create_augroup(group, { clear = clear })
    vim.api.nvim_create_autocmd(ev, opts)
end

local function is_special_ui_ft()
    local ft = vim.bo.filetype
    return ft:match("^dashboard") or ft:match("^clap_") or vim.wo.previewwindow
end

-- LSP Inlay Hints（键位由各插件 local_keys / lazy_keys 声明）
autocmd("LspInlayHints", {
    event = "LspAttach",
    callback = function(ev)
        local inlayhints_enabled = require("core.settings").lsp_inlayhints
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.inlayHintProvider ~= nil then
            vim.lsp.inlay_hint.enable(inlayhints_enabled == true, { bufnr = ev.buf })
        end
    end,
})

-- auto close NvimTree when it is the last window
autocmd("NvimTreeClose", {
    event = "BufEnter",
    pattern = "NvimTree_*",
    callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if
            layout[1] == "leaf"
            and vim.bo[vim.api.nvim_win_get_buf(layout[2])].filetype == "NvimTree"
            and layout[3] == nil
        then
            vim.cmd("confirm quit")
        end
    end,
})

-- auto close some filetype with <q>
autocmd("QuickClose", {
    event = "FileType",
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "nofile",
        "lspinfo",
        "terminal",
        "prompt",
        "toggleterm",
        "copilot",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = ev.buf, silent = true })
    end,
})

autocmd("KeepYankPosition", {
    event = "ModeChanged",
    pattern = { "V:n", "n:V", "v:n", "n:v" },
    callback = function(ev)
        local match = ev.match
        if vim.tbl_contains({ "n:V", "n:v" }, match) then
            vim.b.user_yank_last_pos = vim.api.nvim_win_get_cursor(0)
            return
        end
        if vim.v.operator == "y" then
            local last_pos = vim.b.user_yank_last_pos
            if last_pos then vim.api.nvim_win_set_cursor(0, last_pos) end
        end
        vim.b.user_yank_last_pos = nil
    end,
})

-- Jump to last edit position
autocmd("LastEdit", {
    event = "BufReadPost",
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(ev.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Disable undofile for temp / vcs messages
autocmd("NoUndoTemp", {
    event = "BufWritePre",
    pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
    callback = function()
        vim.opt_local.undofile = false
    end,
})

-- Cursorline only in focused window
autocmd("CursorLineFocus", {
    event = { "WinEnter", "BufEnter", "InsertLeave" },
    callback = function()
        if not vim.wo.cursorline and not is_special_ui_ft() then
            vim.wo.cursorline = true
        end
    end,
})

autocmd("CursorLineBlur", {
    event = { "WinLeave", "BufLeave", "InsertEnter" },
    callback = function()
        if vim.wo.cursorline and not is_special_ui_ft() then
            vim.wo.cursorline = false
        end
    end,
})

autocmd("CheckTime", {
    event = "FocusGained",
    command = "checktime",
})

autocmd("EqualWindows", {
    event = "VimResized",
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

autocmd("FormatOptions", {
    event = "FileType",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

autocmd("AlphaTabline", {
    event = "FileType",
    pattern = "alpha",
    callback = function()
        vim.opt_local.showtabline = 0
    end,
})

autocmd("MarkdownWrap", {
    event = "FileType",
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
    end,
})

autocmd("DapReplComplete", {
    event = "FileType",
    pattern = "dap-repl",
    callback = function()
        pcall(function()
            require("dap.ext.autocompl").attach()
        end)
    end,
})

autocmd("ClangdHeader", {
    event = "FileType",
    pattern = { "c", "cpp" },
    callback = function(ev)
        vim.keymap.set("n", "<leader>h", "<Cmd>ClangdSwitchSourceHeaderVSplit<CR>", {
            buffer = ev.buf,
            desc = "clangd: Switch source/header",
        })
    end,
})

autocmd("YankHighlight", {
    event = "TextYankPost",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})

return event
