return {
    env = {
        PRETTIERD_DEFAULT_CONFIG = ("%s/.config/nvim/lua/modules/configs/completion/formatters/.prettierrc"):format(
            require("core.global").home
        ),
    },
}
