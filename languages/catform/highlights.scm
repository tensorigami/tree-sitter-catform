; Catform syntax highlighting — see SYNTAX.md for role definitions.
; Ordered general → specific so deeper captures override.

; ── Comments ─────────────────────────────────────────────────
(comment) @comment

; ── Op names + function names → same color ───────────────────
(builtin_op) @keyword
(op_call op_type: (op_type (identifier) @keyword))
(function_def name: (identifier) @keyword)

; ── Specifier functions — distinct from op names ─────────────
(builtin_fn) @function.builtin
(specifier_list (identifier) @function.builtin)

; ── Specifier keywords (over=, count=) ───────────────────────
(keyword_specifier key: (identifier) @property)

; ── dtype — bold type color ──────────────────────────────────
(dtype) @type.builtin

; ── Shape dimensions — lighter type color ────────────────────
(shape_dim (identifier) @type)

; ── Pattern strings ──────────────────────────────────────────
(pattern_string) @string

; ── Numbers ──────────────────────────────────────────────────
(number) @number

; ── param.X — prefix colored distinctly ──────────────────────
(dotted_name
  (identifier) @attribute
  (#eq? @attribute "param")
  (identifier) @constant)

; ── Weight references (model.X, layer.X, lm_head.X) ─────────
((dotted_name) @variable.member
  (#match? @variable.member "^(model|layer|lm_head)\\."))

; ── Language literals (mathematical constants) ────────────────
((identifier) @constant.builtin
  (#match? @constant.builtin "^(rot_I|rot_J|neg_inf|zero|one)$"))

; ── Variables — all the same plain color ─────────────────────
(param_entry name: (identifier) @variable)
(assignment output: (identifier) @variable)
(tuple_assignment output: (tuple_pattern (identifier) @variable))
(arg_list (identifier) @variable)

; ── Arrow ────────────────────────────────────────────────────
"->" @keyword

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
