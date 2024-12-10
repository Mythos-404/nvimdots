;; extends

;; Math Operators
("lambda" @keyword.function (#set! conceal "λ"))

;; Important builtins
(((attribute) @constant) (#match? @constant "^(math|np)\.pi$") (#set! conceal "π"))

;; Functions
;; used in function call contexts, e.g. `sum(...)` -> `∑(...)`
((call function: (identifier) @function.builtin) (#eq? @function.builtin "all") (#set! conceal "∀"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "any") (#set! conceal "∃"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "product") (#set! conceal "∏"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "sqrt") (#set! conceal "√"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "sum") (#set! conceal "∑"))
((call function: (attribute) @method) (#eq? @method "math\.sqrt") (#set! conceal "√"))

;; Use a highlight group for test function/method definitions
((class_definition
  body: (block
          (function_definition
            name: (identifier) @function.method.test)))
 (#lua-match? @function.method.test "^test_"))
((function_definition
  name: (identifier) @function.test)
 (#lua-match? @function.test "^test_"))
