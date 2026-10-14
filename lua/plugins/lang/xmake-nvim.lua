local Plugin = require("core.plugin")

local function is_xmake_project(bufnr)
    if vim.fn.executable("xmake") ~= 1 then return false end
    local root = vim.fs.root(bufnr, "xmake.lua")
    if not root then return false end
    if vim.g.loaded_xmake ~= nil then return vim.g.loaded_xmake == true end
    -- A failed project probe must not interrupt BufReadPost and mark a
    -- successfully read file as having read errors (which later causes E13).
    local ok, result = pcall(function()
        return vim.system({ "xmake", "show", "--list=targets" }, { cwd = root, text = true }):wait(3000)
    end)
    return ok and result.code == 0
end

return Plugin:new("Mythos-404/xmake.nvim")
    :enabled(function()
        return vim.fn.executable("xmake") == 1
    end)
    :lazy(true)
    :on("BufReadPost")
    :opts({
        lsp = {
            language = "zh-cn",
        },
    })
    :local_keys({ event = { "BufReadPost", "BufNewFile" } }, function(ctx, bind)
        if not is_xmake_project(ctx.buf) then return {} end

        return {
            ["n|<leader>xb"] = bind.map_cr("Xmake build @"):with_desc("xmake: Build target"),
            ["n|<leader>xr"] = bind.map_cr("Xmake run @"):with_desc("xmake: Run target"),
            ["n|<leader>xd"] = bind.map_cr("Xmake debug @"):with_desc("xmake: Debug target"),
            ["n|<leader>xc"] = bind.map_cr("Xmake clean @"):with_desc("xmake: Clean target"),
            ["n|<leader>xm"] = bind.map_args("Xmake mode"):with_desc("xmake: Set build mode"),
            ["n|<leader>xp"] = bind.map_args("Xmake plat"):with_desc("xmake: Set platform"),
            ["n|<leader>xa"] = bind.map_args("Xmake arch"):with_desc("xmake: Set architecture"),
            ["n|<leader>xt"] = bind.map_args("Xmake toolchain"):with_desc("xmake: Set toolchain"),
        }
    end)
