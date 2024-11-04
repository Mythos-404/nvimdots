return function()
    -- This list delineates the per-language nodes used for guiding |ibl| in highlighting the current scope
    -- It is extracted from each language's `indents.scm` file
    -- NOTE: Only a subset of the supported programming languages is included
    --       If your preferred language isn't listed, you can add it to the user config
    local nodes = {
        bibtex = {
            "entry",
        },
        c = {
            "case_statement",
            "compound_literal_expression",
            "enumerator_list",
            "field_declaration_list",
            "initializer_list",
            "init_declarator",
        },
        cmake = {
            "block_def",
            "foreach_loop",
            "function_def",
            "if_condition",
            "macro_def",
            "normal_command",
            "while_loop",
        },
        cpp = {
            "case_statement",
            "compound_literal_expression",
            "condition_clause",
            "enumerator_list",
            "field_declaration_list",
            "field_initializer_list",
            "init_declarator",
            "initializer_list",
            "namespace_definition",
        },
        css = {
            "block",
            "declaration",
        },
        d = {
            "aggregate_body",
            "block_statement",
            "case_statement",
            "expression_statement",
            "function_body",
            "parameters",
            "scope_statement",
            "template_parameters",
        },
        dart = {
            "arguments",
            "class_body",
            "formal_parameter",
            "formal_parameter_list",
            "function_body",
            "function_expression_body",
            "initializers",
            "list_literal",
            "return_statement",
            "switch_block",
        },
        dot = {
            "block",
            "attr_list",
        },
        ecma = {
            "arguments",
            "array",
            "binary_expression",
            "call_expression",
            "class_body",
            "export_clause",
            "formal_parameters",
            "named_imports",
            "object",
            "object_pattern",
            "parenthesized_expression",
            "return_statement",
            "switch_case",
            "switch_default",
            "switch_statement",
            "template_substitution",
            "ternary_expression",
        },
        elixir = {
            "arguments",
            "block",
            "do_block",
            "list",
            "map",
            "tuple",
        },
        firrtl = {
            "memory",
        },
        fortran = {
            "derived_type_definition",
            "do_loop_statement",
            "enum",
            "function",
            "if_statement",
            "module",
            "program",
            "subroutine",
            "where_statement",
        },
        gleam = {
            "anonymous_function",
            "assert",
            "case",
            "constant",
            "external_function",
            "function",
            "import",
            "let",
            "list",
            "constant",
            "function",
            "type_definition",
            "type_alias",
            "todo",
            "tuple",
        },
        go = {
            "call_expression",
            "communication_case",
            "const_declaration",
            "default_case",
            "expression_case",
            "import_declaration",
            "literal_value",
            "parameter_list",
            "struct_type",
            "type_case",
            "type_declaration",
            "var_declaration",
        },
        html = {
            "start_tag",
            "self_closing_tag",
        },
        java = {
            "annotation_argument_list",
            "annotation_type_body",
            "argument_list",
            "array_initializer",
            "class_body",
            "constructor_body",
            "element_value_array_initializer",
            "enum_body",
            "formal_parameters",
            "interface_body",
            "method_invocation",
            "switch_block",
        },
        javascript = {
            "arguments",
            "array",
            "binary_expression",
            "call_expression",
            "class_body",
            "export_clause",
            "formal_parameters",
            "jsx_expression",
            "jsx_self_closing_element",
            "named_imports",
            "object",
            "object_pattern",
            "parenthesized_expression",
            "return_statement",
            "switch_case",
            "switch_default",
            "switch_statement",
            "template_substitution",
            "ternary_expression",
        },
        julia = {
            "assignment",
            "call_expression",
            "compound_statement",
            "comprehension_expression",
            "for_binding",
            "if_statement",
            "matrix_expression",
            "parenthesized_expression",
            "struct_definition",
            "tuple_expression",
            "vector_expression",
        },
        just = {
            "external_command",
            "recipe",
            "string",
        },
        linkerscript = {
            "memory_command",
            "output_section",
            "phdrs_command",
            "sections_command",
        },
        lua = {
            "arguments",
            "field",
            "method_index_expression",
            "return_statement",
            "table_constructor",
        },
        matlab = {
            "class_definition",
            "enumeration",
            "events",
            "for_statement",
            "if_statement",
            "methods",
            "properties",
            "switch_statement",
            "try_statement",
            "while_statement",
        },
        ninja = {
            "build",
            "pool",
            "rule",
        },
        ocaml = {
            "application_expression",
            "do_clause",
            "external",
            "field_expression",
            "if_expression",
            "list_expression",
            "parenthesized_expression",
            "record_declaration",
            "record_expression",
            "try_expression",
            "type_binding",
            "value_specification",
        },
        pascal = {
            "arrInitializer",
            "block",
            "declArgs",
            "declClass",
            "declConsts",
            "declProc",
            "declTypes",
            "declUses",
            "declVars",
            "defaultValue",
            "exprArgs",
            "exprBrackets",
            "exprParens",
            "exprSubscript",
            "recInitializer",
            "statement",
        },
        php = {
            "arguments",
            "array_creation_expression",
            "binary_expression",
            "case_statement",
            "compound_statement",
            "declaration_list",
            "default_statement",
            "enum_declaration_list",
            "formal_parameters",
            "match_block",
            "member_call_expression",
            "parenthesized_expression",
            "return_statement",
            "switch_block",
        },
        python = {
            "binary_operator",
            "case_clause",
            "concatenated_string",
            "for_statement",
            "generator_expression",
            "if_statement",
            "import_from_statement",
            "lambda",
            "list_pattern",
            "match_statement",
            "parenthesized_expression",
            "try_statement",
            "tuple_pattern",
            "while_statement",
            "with_statement",
        },
        query = {
            "list",
            "predicate",
        },
        r = {
            "brace_list",
            "call",
            "paren_list",
            "pipe",
            "special",
        },
        readline = {
            "conditional_construct",
        },
        ruby = {
            "argument_list",
            "array",
            "assignment",
            "begin",
            "call",
            "case",
            "for",
            "hash",
            "if",
            "module",
            "parenthesized_statements",
            "singleton_class",
            "singleton_method",
            "unless",
            "until",
            "while",
        },
        rust = {
            "arguments",
            "array_expression",
            "assignment_expression",
            "call_expression",
            "enum_variant_list",
            "field_declaration_list",
            "macro_definition",
            "match_block",
            "mod_item",
            "ordered_field_declaration_list",
            "parameters",
            "struct_expression",
            "struct_pattern",
            "token_repetition",
            "token_tree",
            "trait_item",
            "tuple_expression",
            "tuple_pattern",
            "tuple_struct_pattern",
            "tuple_type",
            "use_list",
            "where_clause",
        },
        scss = {
            "block",
            "declaration",
            "each_statement",
            "mixin_statement",
            "while_statement",
        },
        sql = {
            "case",
            "column_definitions",
            "cte",
            "insert",
            "select",
            "subquery",
            "when_clause",
        },
        ssh_config = {
            "host_declaration",
            "match_declaration",
        },
        swift = {
            "array_literal",
            "array_type",
            "assignment",
            "call_expression",
            "class_body",
            "computed_getter",
            "computed_property",
            "computed_setter",
            "control_transfer_statement",
            "deinit_declaration",
            "dictionary_literal",
            "dictionary_type",
            "didset_clause",
            "enum_class_body",
            "init_declaration",
            "lambda_literal",
            "protocol_body",
            "subscript_declaration",
            "tuple_expression",
            "tuple_type",
            "type_parameters",
            "willset_clause",
            "willset_didset_block",
        },
        tablegen = {
            "assert",
            "value_suffix",
        },
        tcl = {
            "braced_word_simple",
            "command",
            "command_substitution",
            "conditional",
            "foreach",
            "namespace",
            "procedure",
            "try",
            "while",
        },
        teal = {
            "record_declaration",
            "function_body",
            "table_constructor",
            "return_statement",
            "while_statement",
        },
        terraform = {
            "block",
            "function_call",
            "object",
            "tuple",
        },
        textproto = {
            "message_list",
            "message_value",
            "scalar_list",
        },
        toml = {
            "array",
            "inline_table",
        },
        typescript = {
            "arguments",
            "array",
            "binary_expression",
            "call_expression",
            "class_body",
            "enum_declaration",
            "export_clause",
            "formal_parameters",
            "interface_declaration",
            "named_imports",
            "object",
            "object_pattern",
            "object_type",
            "parenthesized_expression",
            "return_statement",
            "switch_case",
            "switch_default",
            "switch_statement",
            "template_substitution",
            "ternary_expression",
        },
        vue = {
            "start_tag",
        },
        xml = {
            "element",
        },
        zig = {
            "Block",
            "ContainerDecl",
            "InitList",
            "SwitchExpr",
        },
    }

    require("ibl").setup({
        enabled = true,
        debounce = 200,
        indent = {
            char = "│",
            tab_char = "│",
            smart_indent_cap = true,
            priority = 2,
        },
        whitespace = { remove_blankline_trail = true },
        -- Note: The `scope` field requires treesitter to be set up
        scope = {
            enabled = true,
            char = "▎",
            show_start = true,
            show_end = true,
            injected_languages = true,
            priority = 1000,
            include = {
                node_type = {
                    angular = nodes.html,
                    arduino = nodes.cpp,
                    astro = nodes.html,
                    bibtex = nodes.bibtex,
                    c = nodes.c,
                    cmake = nodes.cmake,
                    cpp = nodes.cpp,
                    css = nodes.css,
                    cuda = nodes.cpp,
                    d = nodes.d,
                    dart = nodes.dart,
                    dot = nodes.dot,
                    ecma = nodes.ecma,
                    elixir = nodes.elixir,
                    firrtl = nodes.firrtl,
                    fortran = nodes.fortran,
                    glsl = nodes.c,
                    gleam = nodes.gleam,
                    go = nodes.go,
                    hlsl = nodes.cpp,
                    html = nodes.html,
                    java = nodes.java,
                    javascript = nodes.javascript,
                    julia = nodes.julia,
                    just = nodes.just,
                    linkerscript = nodes.linkerscript,
                    lua = nodes.lua,
                    luau = nodes.lua,
                    matlab = nodes.matlab,
                    ninja = nodes.ninja,
                    objc = nodes.c,
                    ocaml = nodes.ocaml,
                    ocaml_interface = nodes.ocaml,
                    pascal = nodes.pascal,
                    php = nodes.php,
                    python = nodes.python,
                    query = nodes.query,
                    r = nodes.r,
                    readline = nodes.readline,
                    ruby = nodes.ruby,
                    rust = nodes.rust,
                    scss = nodes.scss,
                    sql = nodes.sql,
                    ssh_config = nodes.ssh_config,
                    swift = nodes.swift,
                    tablegen = nodes.tablegen,
                    tcl = nodes.tcl,
                    teal = nodes.teal,
                    terraform = nodes.terraform,
                    textproto = nodes.textproto,
                    toml = nodes.toml,
                    typescript = nodes.typescript,
                    vue = nodes.vue,
                    xml = nodes.xml,
                    zig = nodes.zig,
                },
            },
        },
        exclude = {
            buftypes = {
                "help",
                "nofile",
                "prompt",
                "quickfix",
                "terminal",
            },
            filetypes = {
                "", -- for all buffers without a file type
                "alpha",
                "bigfile",
                "checkhealth",
                "dap-repl",
                "diff",
                "fugitive",
                "fugitiveblame",
                "git",
                "gitcommit",
                "help",
                "log",
                "markdown",
                "notify",
                "NvimTree",
                "Outline",
                "qf",
                "TelescopePrompt",
                "text",
                "toggleterm",
                "undotree",
                "vimwiki",
            },
        },
    })
end
