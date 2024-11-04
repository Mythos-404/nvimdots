return function()
    require("cmake-tool").setup({
        cmake_executor = {
            name = "quickfix",
        },
        cmake_runner = {
            name = "toggleterm",
        },
    })
end
