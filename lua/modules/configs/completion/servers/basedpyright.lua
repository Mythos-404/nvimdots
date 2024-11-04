return {
    cmd_env = { LANG = "zh-cn" },
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            disableTaggedHints = false,

            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",

                typeCheckingMode = "standard",
            },
        },
    },
}
