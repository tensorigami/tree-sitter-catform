; Catform syntax highlighting — see SYNTAX.md for the 7 color groups.
; Ordered general → specific so deeper captures override.

; ── Comments (secondary) ──────────────────────────────────────
(comment) @comment

; ── §2: Op names + function names → same color ───────────────
(builtin_op) @keyword
(op_call op_type: (op_type (identifier) @keyword))
(function_def name: (identifier) @keyword)

; ── §7: Specifier functions — distinct from op names ─────────
(builtin_fn) @function.builtin
(specifier_list (identifier) @function.builtin)

; ── Specifier keywords (secondary: over=, count=) ────────────
(keyword_specifier key: (identifier) @property)

; ── §3: dtype ─────────────────────────────────────────────────
(dtype) @type.builtin

; ── §4: Shape dimensions — distinct from dtype ────────────────
(shape_dim (identifier) @type)

; ── §6: Pattern strings ──────────────────────────────────────
(pattern_string) @string

; ── Numbers (secondary) ──────────────────────────────────────
(number) @number

; ── §5: param.X — prefix colored distinctly ──────────────────
(dotted_name
  (identifier) @attribute
  (#eq? @attribute "param")
  (identifier) @constant)

; ── Weight references (secondary: model.X, layer.X) ──────────
((dotted_name) @variable.member
  (#match? @variable.member "^(model|layer|lm_head)\\."))

; ── Language literals (secondary: mathematical constants) ─────
((identifier) @constant.builtin
  (#match? @constant.builtin "^(rot_I|rot_J|neg_inf|zero|one)$"))

; ── §1: Variables — all the same plain color ─────────────────
(param_entry name: (identifier) @variable)
(assignment output: (identifier) @variable)
(tuple_assignment output: (tuple_pattern (identifier) @variable))
(arg_list (identifier) @variable)

; ── §2: Arrow ────────────────────────────────────────────────
"->" @keyword

; ── Punctuation (secondary) ──────────────────────────────────
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
