;; extends

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
(
  [
    (_
      (variable_declaration
        (assignment_statement
          (expression_list
            (string
              (string_content) @injection.content))))
     .
     (comment
       (comment_content) @injection.language))
    (_
      (block
        (assignment_statement
          (expression_list
            (function_call
              (arguments
                (string
                  (string_content) @injection.content))))))
      .
      (comment
        (comment_content) @injection.language))
    (_
      (string
        (string_content) @injection.content)
      .
      (comment
        (comment_content) @injection.language))
    (_
      (field
        (string
          (string_content) @injection.content))
      .
      (comment
        (comment_content) @injection.language))]
  (#gsub! @injection.language "^> INJECT: ([%w_]+)$" "%1"))

(_
  (comment
    (comment_content) @injection.language)
  .
  [
   (string
    (string_content) @injection.content)
   (expression_list
    (string
        (string_content) @injection.content))]
  (#gsub! @injection.language "%s*([%w%p]+)%s*" "%1")
  (#set! injection.combined))
