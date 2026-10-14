local M = {}
local warned = {}

---Resolve the backend once, before any plugin can change PATH.
local function backend()
    local selected = vim.env.NVIMDOTS_TOOL_BACKEND or require("core.settings").tool_backend or "auto"
    if not vim.tbl_contains({ "auto", "system", "mason" }, selected) then
        error("tool_backend must be one of: auto, system, mason")
    end
    if selected ~= "auto" then return selected end

    local ok, lines = pcall(vim.fn.readfile, "/etc/os-release")
    if ok then
        for _, line in ipairs(lines) do
            if line:match("^ID=[\"']?nixos[\"']?$") then return "system" end
        end
    end
    return "mason"
end

M.backend = backend()

function M.use_mason()
    return M.backend == "mason"
end

---@param name string
function M.missing(name)
    if warned[name] then return end
    warned[name] = true
    local hint = M.use_mason() and "Install it with Mason or your system/SDK package manager."
        or "Add it to the project's devShell (or system PATH), then restart Neovim from that environment."
    vim.schedule(function()
        vim.notify(("Tool `%s` is unavailable. %s"):format(name, hint), vim.log.levels.WARN, { title = "nvimdots" })
    end)
end

---@param name string
---@param quiet? boolean
---@return string|nil
function M.executable(name, quiet)
    local path = vim.fn.exepath(name)
    if path ~= "" then return path end
    if not quiet then M.missing(name) end
end

---Check existing buffers too: these plugins may load after FileType has fired.
---@param filetypes string[]
---@param callback fun(bufnr: integer)
function M.on_filetype(filetypes, callback)
    if #filetypes == 0 then return end
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(ev)
            callback(ev.buf)
        end,
    })
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.tbl_contains(filetypes, vim.bo[bufnr].filetype) then
            callback(bufnr)
        end
    end
end

return M
