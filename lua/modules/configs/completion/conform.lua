return function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            awk = { "awk" },

            bash = { "shfmt" },
            sh = { "shfmt" },
            zsh = { "beautysh" },

            c = { "clang-format" },
            cpp = { "clang-format" },

            vue = { "prettierd", "injected" },
            typescript = { "prettierd" },
            javascript = { "prettierd" },
            typescriptreact = { "prettierd" },
            javascriptreact = { "prettierd" },
            html = { "prettierd", "injected" },
            css = { "prettierd" },
            scss = { "prettierd" },
            markdown = { "mdformat" },
            json = { "prettierd" },
            jsonc = { "prettierd" },

            just = { "just" },

            rust = { "rustfmt" },

            go = { "goimports", "gofumpt" },

            python = { "ruff_format", "ruff_organize_imports", "injected" },

            lua = { "stylua", "injected" },

            yaml = { "yamlfmt" },

            glsl = { lsp_format = "fallback" },
            toml = { lsp_format = "fallback" },
        },
    })

    conform.formatters.injected = {
        options = {
            ignore_errors = true,
            lang_to_formatters = vim.tbl_extend("keep", {}, conform.formatters_by_ft),
        },
    }
    -- loader formatter config file
    for _, format_info in ipairs(conform.list_all_formatters()) do
        local ok, custom_handler = pcall(require, "completion.formatters." .. format_info.name)
        if ok then conform.formatters[format_info.name] = custom_handler end
    end

    require("completion.formatting").configure_format_on_save()
end
