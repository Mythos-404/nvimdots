return {
    flags = { debounce_text_changes = 500 },
    cmd = { "gopls", "-remote=auto" },
    settings = {
        gopls = {
            gofumpt = true,
            usePlaceholders = true,
            analyses = { nilness = true, shadow = true, unusedparams = true, unusewrites = true },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}
