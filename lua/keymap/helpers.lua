---@diagnostic disable: undefined-global
_G._command_panel = function()
    require("telescope.builtin").keymaps({
        lhs_filter = function(lhs)
            return not string.find(lhs, "Þ")
        end,
        layout_config = {
            width = 0.6,
            height = 0.6,
            prompt_position = "top",
        },
    })
end

_G._flash_esc_or_noh = function()
    local flash_active, state = pcall(function()
        return require("flash.plugins.char").state
    end)
    if not (flash_active and state) then return pcall(vim.cmd.noh) end
    state:hide()
end

_G._mini_file_open = function()
    if not MiniFiles.close() then
        local file = vim.api.nvim_buf_get_name(0)
        local file_exists = vim.fn.filereadable(file) ~= 0
        MiniFiles.open(file_exists and file or nil)
        MiniFiles.reveal_cwd()
    end
end

_G._async_compile_and_debug = function()
    local file_ext = vim.fn.expand("%:e")
    local file_path = vim.fn.expand("%:p")
    local out_name = vim.fn.expand("%:p:h") .. "/" .. vim.fn.expand("%:t:r") .. ".out"
    local compile_cmd = ({
        cpp = { "g++", "-g", file_path, "-o", out_name },
        cc = { "g++", "-g", file_path, "-o", out_name },
        c = { "gcc", "-g", file_path, "-o", out_name },
        go = { "go", "build", "-o", file_path, out_name },
    })[file_ext]
    if not compile_cmd then return vim.schedule(require("dap").continue) end

    local notify_title = "Debug Pre-compile"
    vim.system(compile_cmd, {}, function(out)
        if out.code ~= 0 then
            return vim.notify(
                "Compilation failed with exit code: " .. out.code,
                vim.log.levels.ERROR,
                { title = notify_title }
            )
        end
        vim.notify("Compilation succeeded! Executable: " .. out_name, vim.log.levels.INFO, { title = notify_title })
        vim.schedule(require("dap").continue)
    end)
end
