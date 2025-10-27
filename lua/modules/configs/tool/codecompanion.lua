return function()
    local chat_lang = require("core.settings").chat_lang

    require("codecompanion").setup({
        strategies = {
            chat = {
                adapter = {
                    name = "copilot",
                    model = "claude-sonnet-4",
                },
            },
            inline = {
                adapter = "copilot",
            },
            cmd = {
                adapter = "copilot",
            },
        },
        opts = {
            language = chat_lang,
        },
        display = {
            diff = {
                enabled = true,
                close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
                layout = "vertical", -- vertical|horizontal split for default provider
                opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
                provider = "default", -- default|mini_diff
            },
            chat = {
                show_settings = true,
                window = {
                    layout = "vertical", -- float|vertical|horizontal|buffer
                    position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
                    border = "single",
                    width = 0.25,
                    relative = "editor",
                    full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
                },
            },
        },
        extensions = {
            history = {
                enabled = true,
                opts = {
                    -- Keymap to open history from chat buffer (default: gh)
                    keymap = "gh",
                    -- Automatically generate titles for new chats
                    auto_generate_title = true,
                    ---On exiting and entering neovim, loads the last chat on opening chat
                    continue_last_chat = false,
                    ---When chat is cleared with `gx` delete the chat from history
                    delete_on_clearing_chat = false,
                    -- Picker interface ("telescope", "snacks" or "default")
                    picker = "telescope",
                    ---Enable detailed logging for history extension
                    enable_logging = false,
                    ---Directory path to save the chats
                    dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                    -- Save all chats by default
                    auto_save = true,
                    -- Keymap to save the current chat manuallyAdd commentMore actions
                    save_chat_keymap = "sc",
                    -- Number of days after which chats are automatically deleted (0 to disable)
                    expiration_days = 0,
                },
            },
        },
    })
end
