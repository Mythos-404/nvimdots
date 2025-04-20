return function()
    require("cronex").setup({
        explainer = { -- Configuration on how to explain one cron expression goes here
            -- Command to call an external program that will translate the cron expression
            -- eg: "* * * * *" -> Every minute
            -- Any command that is available in your command line can be used here.
            -- examples:
            -- "/path/to/miniconda3/envs/neovim/bin/cronstrue" (point to a conda virtualenv)
            -- "python explainer.py" (assuming you have such a python script available)
            cmd = { os.getenv("HOME") .. "/.golang/bin/hcron" },
            -- Optional arguments to pass to the command
            -- eg: "/path/to/a/go/binary"  (assuming you have a go binary)
            -- args = { "-print-all" }  (assuming the program understands the flag 'print-all')
            args = { "-locale", "zh_CN" },
        },
    })
end
