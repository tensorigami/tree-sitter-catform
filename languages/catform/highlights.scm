; ── Comments ──────────────────────────────────────────────────
(comment) @comment

; ── Op types ─────────────────────────────────────────────────
(builtin_op) @function.builtin

; ── Builtin functions (specifiers) ───────────────────────────
(builtin_fn) @function.builtin

; ── Function definitions ─────────────────────────────────────
(function_def name: (identifier) @function)

; ── Op calls (user-defined function in op position) ──────────
(op_call op_type: (op_type (identifier) @function))

; ── Keyword specifiers (over=, count=) ───────────────────────
(keyword_specifier key: (identifier) @property)

; ── Types ────────────────────────────────────────────────────
(dtype) @type.builtin

; ── Strings (einops patterns) ────────────────────────────────
(pattern_string) @string

; ── Numbers ──────────────────────────────────────────────────
(number) @number

; ── Config references (param.name) ───────────────────────────
((dotted_name) @constant
  (#match? @constant "^param\\."))

; ── Weight references (model.x, layer.x, lm_head.x) ─────────
((dotted_name) @variable.member
  (#match? @variable.member "^(model|layer|lm_head)\\."))

; ── Language literals (mathematical constants) ────────────────
((identifier) @constant.builtin
  (#match? @constant.builtin "^(rot_I|rot_J|neg_inf|zero|one)$"))

; ── Identifiers ──────────────────────────────────────────────
(param_entry name: (identifier) @variable.parameter)
(assignment output: (identifier) @variable)
(tuple_assignment output: (tuple_pattern (identifier) @variable))

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
