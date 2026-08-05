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

---Delete a buffer without disrupting the window layout.
---When it is the last listed buffer, quit Neovim instead of leaving
---an empty scratch buffer behind (nvim-bufdel style behavior).
---@param buf? integer
function M.bufdelete(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    local listed = vim.tbl_filter(function(b)
        return vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())

    if vim.tbl_contains(listed, buf) and #listed <= 1 then
        local discard = false
        if vim.bo[buf].modified then
            local ok, choice = pcall(
                vim.fn.confirm,
                ("Save changes to %q?"):format(vim.fn.bufname(buf)),
                "&Yes\n&No\n&Cancel"
            )
            if not ok or choice == 0 or choice == 3 then
                return
            elseif choice == 1 then
                vim.api.nvim_buf_call(buf, vim.cmd.write)
            else
                discard = true
            end
        end

        if discard then
            vim.cmd("bdelete! " .. buf)
        end
        vim.cmd("confirm qall")
        return
    end

    require("snacks").bufdelete(buf)
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

function M.picker(method, tele_opts)
    local fzf_opts = { ["--layout"] = require("core.settings").search_prompt_position == "top" and "reverse" or "default" }
    if require("core.settings").search_backend == "fzf" then
        require("fzf-lua")[method]({
            fzf_opts = fzf_opts,
        })
    else
        require("telescope.builtin")[method](tele_opts)
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
