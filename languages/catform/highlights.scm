; Catform syntax highlighting — see SYNTAX.md for role definitions.

; ── Comments (§11) ───────────────────────────────────────────
(comment) @comment

; ── Op names (§3) — the word before [...] or (...) after = ──
(builtin_op) @keyword
(op_call op_type: (op_type (identifier) @keyword))

; ── Specifier functions (§5) — identifiers inside [...] ──────
(builtin_fn) @function.builtin
; User-defined function names in specifiers (call[rmsnorm], loop[layer])
(specifier_list (identifier) @function.builtin)

; ── Specifier keywords (§6) — over=, count= ─────────────────
(keyword_specifier key: (identifier) @property)

; ── Function definitions (§10) ───────────────────────────────
(function_def name: (identifier) @function)

; ── Types (§2) — dtype and shape dimensions ──────────────────
(dtype) @type.builtin
(shape_dim (identifier) @type)
(shape_dim (dotted_name) @type)

; ── Strings / pattern strings (§4) ───────────────────────────
(pattern_string) @string

; ── Numbers (§12) ────────────────────────────────────────────
(number) @number

; ── Config references (§7) — param.X ─────────────────────────
((dotted_name) @constant
  (#match? @constant "^param\\."))

; ── Weight references (§8) — model.X, layer.X, lm_head.X ────
((dotted_name) @variable.member
  (#match? @variable.member "^(model|layer|lm_head)\\."))

; ── Language literals (§9) — mathematical constants ──────────
((identifier) @constant.builtin
  (#match? @constant.builtin "^(rot_I|rot_J|neg_inf|zero|one)$"))

; ── Terms (§1) — bound variables ─────────────────────────────
(param_entry name: (identifier) @variable.parameter)
(assignment output: (identifier) @variable)
(tuple_assignment output: (tuple_pattern (identifier) @variable))

; ── Arrow (§13) ──────────────────────────────────────────────
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
