return {
    env = {
        PRETTIERD_DEFAULT_CONFIG = vim.fs.normalize(
            ("%s/lua/plugins/completion/formatters/.prettierrc.yaml"):format(require("core.global").vim_path)
        ),
    },
}
