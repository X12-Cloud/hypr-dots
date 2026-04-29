;; Keywords
"return" @keyword
"if" @conditional
"else" @conditional
"while" @repeat
"print" @function.builtin
"struct" @keyword
"enum" @keyword
"const" @keyword

;; Types and Variables
(type) @type
(identifier) @variable
(number) @number
(string) @string

;; Functions
(function_definition (identifier) @function)
(call_expression (identifier) @function)

;; Comments
(comment) @comment
