;;extends

; Math Operators
("lambda" @keyword.function (#set! conceal "λ"))
("del" @keyword  (#set! conceal "󰆴"))

; Functions
; used in function call contexts, e.g. `sum(...)` -> `∑(...)`
((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "sum")
 (#set! conceal "∑"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "all")
 (#set! conceal "∀"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "any")
 (#set! conceal "∃"))

((call function: (identifier) @function.builtin)
 (#eq? @function.builtin "len")
 (#set! conceal "#"))

((call function: (attribute) @method)
 (#eq? @method "math\.sqrt")
 (#set! conceal "√"))

; Important builtins
(((attribute) @constant)
 (#eq? @constant "math\.pi")
 (#set! conceal "π"))
(((attribute) @constant)
 (#eq? @constant "np\.pi")
 (#set! conceal "π"))
