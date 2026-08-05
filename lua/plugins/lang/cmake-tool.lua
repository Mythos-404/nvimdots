local Plugin = require("core.plugin")

return Plugin:new("Civitasv/cmake-tools.nvim")
    :lazy(true)
    :ft("cmake")
    :opts({
        cmake_executor = {
            name = "quickfix",
        },
        cmake_runner = {
            name = "toggleterm",
        },
    })
