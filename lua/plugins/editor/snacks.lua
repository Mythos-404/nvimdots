---@diagnostic disable: undefined-global
local Plugin = require("core.plugin")

return Plugin:new("folke/snacks.nvim")
    :lazy(false)
    :priority(10000)
    :opts({
        animate      = {
            duration = 20, -- ms per step
            easing = "linear",
            fps = 150,
        },
        quicker      = { enabled = true },
        statuscolumn = { enabled = true },
        scroll       = { enabled = true },
        dashboard    = { enabled = true },
        notifier     = { enabled = true },
        image        = { enabled = true },
        input        = { enabled = true },
    })
    :init(function(plugin)
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
