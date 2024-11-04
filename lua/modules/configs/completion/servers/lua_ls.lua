-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
return {
    on_init = function(client)
        if not client.config.cmd_cwd:find("nvim") then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            diagnostics = {
                globals = { "vim" },
                disable = { "different-requires" },
            },
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    "${3rd}/luv/library",
                },
                ignoreDir = { "types/stable" },
            },
        })
    end,
    cmd = { "lua-language-server", '--locale="zh-cn"' },
    settings = {
        Lua = {
            workspace = {
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            hint = { enable = true, setType = true },
            format = { enable = false },
            telemetry = { enable = false },
            -- Do not override treesitter lua highlighting with lua_ls's highlighting
            semantic = { enable = false },
        },
    },
}
