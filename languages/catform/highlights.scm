; ── Comments ──────────────────────────────────────────────────
(comment) @comment

; ── Keywords ─────────────────────────────────────────────────
"param" @keyword
"constant" @keyword

; ── Op types ─────────────────────────────────────────────────
(builtin_op) @function.builtin

; ── Builtin functions (specifiers) ───────────────────────────
(builtin_fn) @function.builtin

; ── Function definitions ─────────────────────────────────────
(function_def name: (identifier) @function)

; ── Function calls in constant expressions ───────────────────
(call_expr function: (identifier) @function)

; ── Op calls ─────────────────────────────────────────────────
(op_call op_type: (op_type (identifier) @function))

; ── Keyword specifiers (over=, count=) ───────────────────────
(keyword_specifier key: (identifier) @property)

; ── Types ────────────────────────────────────────────────────
(dtype) @type.builtin

; ── Strings (einops patterns) ────────────────────────────────
(pattern_string) @string

; ── Numbers ──────────────────────────────────────────────────
(number) @number

; ── Identifiers ──────────────────────────────────────────────
(param_decl name: (identifier) @variable.parameter)
(constant_decl name: (identifier) @constant)
(param_entry name: (identifier) @variable.parameter)
(assignment output: (identifier) @variable)
(dotted_name) @variable.member

; ── Punctuation ──────────────────────────────────────────────
"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

"," @punctuation.delimiter
":" @punctuation.delimiter
"." @punctuation.delimiter
"=" @operator
"->" @operator
"+" @operator
"-" @operator
"*" @operator
"/" @operator
