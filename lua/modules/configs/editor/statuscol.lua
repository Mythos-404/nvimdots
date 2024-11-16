return function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
        relculright = true,
        segments = {
            { sign = { namespace = { "gitsigns" }, auto = true, fillchar = "", colwidth = 1 }, click = "v:lua.ScLa" },
            { sign = { namespace = { "diagnostic/signs" }, auto = true }, click = "v:lua.ScLa" },
            { sign = { name = { "Dap.*" }, auto = true }, click = "v:lua.ScLa" },
            { sign = { namespace = { ".*" }, auto = true } },
            {
                text = {
                    function(args)
                        return (args.relnum == 0) and " " or ""
                    end,
                },
                auto = true,
            },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
    })
end
