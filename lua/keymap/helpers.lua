local M = {}

function M.command_panel()
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

function M.flash_esc_or_noh()
    local flash_active, state = pcall(function()
        return require("flash.plugins.char").state
    end)
    if not (flash_active and state) then return pcall(vim.cmd.noh) end
    state:hide()
end

function M.mini_file_open()
    if not MiniFiles.close() then
        local file = vim.api.nvim_buf_get_name(0)
        local file_exists = vim.fn.filereadable(file) ~= 0
        MiniFiles.open(file_exists and file or nil)
        MiniFiles.reveal_cwd()
    end
end

function M.toggle_inlayhint()
    local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })

    vim.lsp.inlay_hint.enable(not is_enabled)
    vim.notify(
        (is_enabled and "Inlay hint disabled successfully" or "Inlay hint enabled successfully"),
        vim.log.levels.INFO,
        { title = "LSP Inlay Hint" }
    )
end

function M.toggle_virtualtext()
    local _vt_enabled = require("core.settings").diagnostics_virtual_text
    if _vt_enabled then
        local vt_config = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = vt_config })
        vim.notify(
            (vt_config and "Virtual text is now displayed" or "Virtual text is now hidden"),
            vim.log.levels.INFO,
            { title = "LSP Diagnostic" }
        )
    end

    local _vl_enabled = require("core.settings").diagnostics_virtual_lines
    if _vl_enabled then
        local vl_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = vl_config })
        vim.notify(
            (vl_config and "Virtual lines is now displayed" or "Virtual lines is now hidden"),
            vim.log.levels.INFO,
            { title = "LSP Diagnostic" }
        )
    end
end

-- Back-compat for any remaining _G callers during migration
_G._command_panel = M.command_panel
_G._flash_esc_or_noh = M.flash_esc_or_noh
_G._mini_file_open = M.mini_file_open
_G._toggle_inlayhint = M.toggle_inlayhint
_G._toggle_virtualtext = M.toggle_virtualtext

return M
