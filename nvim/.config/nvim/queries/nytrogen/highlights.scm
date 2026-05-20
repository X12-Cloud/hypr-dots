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

;; Preprocessor Directives
(preproc_include) @keyword.directive
(preproc_define) @keyword.directive
(preproc_ifndef) @keyword.directive
(preproc_endif) @keyword.directive

(preproc_ifndef name: (identifier) @constant)
(preproc_define name: (identifier) @constant)
(preproc_include path: (string) @string)

;; Comments
(comment) @comment
