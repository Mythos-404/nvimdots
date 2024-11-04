return function()
    require("refactoring").setup({
        prompt_func_return_type = {
            h = false,
            hpp = false,
            c = false,
            cpp = false,
            cxx = false,
            go = false,
            java = false,
        },
        prompt_func_param_type = {
            h = false,
            hpp = false,
            c = false,
            cpp = false,
            cxx = false,
            go = false,
            java = false,
        },
        printf_statements = {},
        print_var_statements = {},
        show_success_message = false, -- shows a message with information about the refactor on success
    })
end
