---@diagnostic disable: undefined-global
local Plugin = require("core.plugin")

local map_callback = require("keymap.bind").map_callback

-- Snacks spawns the shell directly and ignores shellcmdflag, so terminals
-- reuse the PowerShell setup by simple concatenation.
-- `-NoExit` keeps the session interactive after the `-Command` script runs.
local terminal_shell = vim.o.shell
if vim.fn.has("win32") == 1 and vim.o.shellcmdflag ~= "" then
    terminal_shell = vim.o.shell .. " -NoExit " .. vim.o.shellcmdflag
end

local FLOAT_WIN = {
    position = "float",
    height = 0.6,
    width = 0.7,
    backdrop = 60,
    border = "rounded",
}

---Toggle a dedicated terminal layout.
---`count` keeps bottom/right/float as separate snacks terminal instances,
---otherwise they would share one instance (the terminal id ignores the layout).
---@param win table
---@param count integer
local function terminal_toggle(win, count)
    require("snacks").terminal.toggle(nil, { win = win, count = count })
end

---Switch directly from inside a terminal to another layout:
---hide the current snacks terminal, then open the target one.
---@param win table
---@param count integer
local function terminal_switch(win, count)
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype == "terminal" then
        for _, term in ipairs(require("snacks").terminal.list()) do
            if term.buf == buf then
                local term_id = vim.b[buf].snacks_terminal and vim.b[buf].snacks_terminal.id
                if term_id == count then
                    -- Same layout: just close it (toggleterm behavior)
                    term:hide()
                    return
                end
                term:hide()
            end
        end
    end
    require("snacks").terminal.focus(nil, { win = win, count = count })
end

return Plugin:new("folke/snacks.nvim")
    :lazy(false)
    :priority(10000)
    :opts({
        animate      = {
            duration = 20, -- ms per step
            easing = "linear",
            fps = 150,
        },
        bigfile      = { enabled = require("core.settings").load_big_files_faster },
        quicker      = { enabled = true },
        statuscolumn = { enabled = true },
        scroll       = { enabled = true },
        dashboard    = { enabled = true },
        notifier     = { enabled = true },
        image        = { enabled = true },
        indent       = { enabled = true },
        input        = { enabled = true },
        terminal     = {
            shell = terminal_shell,
            win = {
                style = "terminal",
            },
        },
    })
    :init(function()
        _G.dd = function(...)
            Snacks.debug.inspect(...)
        end
        _G.bt = function()
            Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
            ---@diagnostic disable-next-line: duplicate-set-field
            vim._print = function(_, ...)
                dd(...)
            end
        else
            vim.print = _G.dd
        end
    end)
    :lazy_keys({
        ["n|<A-q>"] = map_callback(function()
                require("keymap.helpers").bufdelete()
            end)
            :with_desc("buffer: Close current"),
        ["n|<leader>gg"] = map_callback(function()
                Snacks.lazygit()
            end)
            :with_desc("git: Toggle lazygit"),

        ["n|<C-\\>"] = map_callback(function()
                terminal_toggle({ position = "bottom", height = 0.3 }, 1)
            end)
            :with_desc("terminal: Toggle bottom"),
        ["i|<C-\\>"] = map_callback(function()
                vim.cmd("stopinsert")
                terminal_toggle({ position = "bottom", height = 0.3 }, 1)
            end)
            :with_desc("terminal: Toggle bottom"),
        ["t|<C-\\>"] = map_callback(function()
                terminal_switch({ position = "bottom", height = 0.3 }, 1)
            end)
            :with_desc("terminal: Switch bottom"),
        ["n|<A-\\>"] = map_callback(function()
                terminal_toggle({ position = "right", width = 0.4 }, 2)
            end)
            :with_desc("terminal: Toggle right"),
        ["i|<A-\\>"] = map_callback(function()
                vim.cmd("stopinsert")
                terminal_toggle({ position = "right", width = 0.4 }, 2)
            end)
            :with_desc("terminal: Toggle right"),
        ["t|<A-\\>"] = map_callback(function()
                terminal_switch({ position = "right", width = 0.4 }, 2)
            end)
            :with_desc("terminal: Switch right"),
        ["n|<A-d>"] = map_callback(function()
                terminal_toggle(FLOAT_WIN, 3)
            end)
            :with_desc("terminal: Toggle float"),
        ["i|<A-d>"] = map_callback(function()
                vim.cmd("stopinsert")
                terminal_toggle(FLOAT_WIN, 3)
            end)
            :with_desc("terminal: Toggle float"),
        ["t|<A-d>"] = map_callback(function()
                terminal_switch(FLOAT_WIN, 3)
            end)
            :with_desc("terminal: Switch float"),

        ["n|<leader>`"] = map_callback(function()
                Snacks.scratch()
            end)
            :with_desc("snacks: Toggle scratch buffer"),
        ["n|<leader>."] = map_callback(function()
                Snacks.scratch.select()
            end)
            :with_desc("snacks: Select scratch buffer"),
    })
