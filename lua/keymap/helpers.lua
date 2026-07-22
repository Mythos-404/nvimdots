---@diagnostic disable: undefined-global
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

M.select_chat_model = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local finder = require("telescope.finders")
    local pickers = require("telescope.pickers")
    local type = require("telescope.themes").get_dropdown()
    local conf = require("telescope.config").values
    local ai = require("utils.ai")
    local models = ai.get_codecompanion_models()
    local current_model = vim.g.current_chat_model or ai.get_codecompanion_default_model()

    pickers
        .new(type, {
            prompt_title = "(CodeCompanion) Select Model",
            finder = finder.new_table({ results = models }),
            sorter = conf.generic_sorter(type),
            attach_mappings = function(bufnr)
                actions.select_default:replace(function()
                    actions.close(bufnr)
                    current_model = action_state.get_selected_entry()[1]
                    vim.g.current_chat_model = current_model
                    vim.notify("Model selected: " .. current_model, vim.log.levels.INFO, { title = "CodeCompanion" })
                end)

                return true
            end,
        })
        :find()
end

return M
