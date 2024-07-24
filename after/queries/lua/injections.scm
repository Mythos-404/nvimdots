; extends

(function_call
  name: (dot_index_expression) @_method
  arguments: (arguments
              .
              (_)
              .
              (string
                (string_content) @injection.content))
 (#any-of? @_method "vim.split" "vim.gsplit")
 (#set! injection.language "luap"))

;; Arbitrary string injections using `--> INJECT: <parser>`
;; local exec_lua = [[
;;     print("test")
;; ]] --> INJECT: lua
(_
  (variable_declaration
    (assignment_statement
      (expression_list
        (string
          (string_content) @injection.content))))
  .
  (comment
    (comment_content) @injection.language)
 (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))
(_
  (string
    (string_content) @injection.content)
  .
  (comment
    (comment_content) @injection.language)
 (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))
(_
  (string
     (string_content) @injection.content)
  .
  (comment
    (comment_content) @injection.language)
 (#gsub! @injection.language "^ INJECT: ([%w_]+)$" "%1"))

(variable_list
  (identifier) @query
 (#lua-match? @query "^query"))

(string content: _ @query
 (#lua-match? @query "^%s*;+%s?query"))
