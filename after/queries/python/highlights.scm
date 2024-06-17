;;extends

;; Math Operators
("lambda" @keyword.function (#set! conceal "λ"))
("del" @keyword  (#set! conceal "󰆴"))

;; Important builtins
(((attribute) @constant) (#eq? @constant "math\.pi") (#set! conceal "π"))
(((attribute) @constant) (#eq? @constant "np\.pi") (#set! conceal "π"))

;; Functions
;; used in function call contexts, e.g. `sum(...)` -> `∑(...)`
((call function: (identifier) @function.builtin) (#eq? @function.builtin "sum") (#set! conceal "∑"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "all") (#set! conceal "∀"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "any") (#set! conceal "∃"))
((call function: (identifier) @function.builtin) (#eq? @function.builtin "len") (#set! conceal "#"))
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
