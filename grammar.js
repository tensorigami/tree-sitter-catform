/// <reference types="tree-sitter-cli/dsl" />

module.exports = grammar({
  name: "catform",

  extras: ($) => [/\s/, $.comment],

  rules: {
    source_file: ($) => repeat($._definition),

    _definition: ($) =>
      choice($.param_decl, $.constant_decl, $.function_def),

    // ── Declarations ──────────────────────────────────────────

    param_decl: ($) =>
      seq("param", field("name", $.identifier), optional(seq("=", field("value", $.expression)))),

    constant_decl: ($) =>
      seq("constant", field("name", $.identifier), "=", field("value", $.expression)),

    // ── Function definition ───────────────────────────────────

    function_def: ($) =>
      seq(
        field("name", $.identifier),
        "(", optional($.param_list), ")",
        optional(seq("->", field("return_type", $.type))),
        "{", repeat($._statement), "}"
      ),

    param_list: ($) => seq($.param_entry, repeat(seq(",", $.param_entry))),

    param_entry: ($) =>
      seq(field("name", $.identifier), ":", field("type", $.type)),

    // ── Statements ────────────────────────────────────────────

    _statement: ($) => choice($.assignment, $.return_expr),

    assignment: ($) =>
      seq(
        field("output", $.identifier),
        ":",
        field("type", $.type),
        "=",
        field("op", $.op_call)
      ),

    return_expr: ($) => $.identifier,

    // ── Op call ───────────────────────────────────────────────

    op_call: ($) =>
      seq(
        field("op_type", $.op_type),
        optional(field("specifiers", $.specifier_block)),
        "(", optional($.arg_list), ")"
      ),

    op_type: ($) =>
      choice(
        $.builtin_op,
        $.identifier
      ),

    builtin_op: (_) =>
      choice("view", "map", "fold", "tile", "gather", "scatter", "contract", "call", "loop"),

    specifier_block: ($) =>
      seq("[", $.specifier_list, "]"),

    specifier_list: ($) => seq($._specifier, repeat(seq(",", $._specifier))),

    _specifier: ($) =>
      choice(
        $.keyword_specifier,
        $.pattern_string,
        $.builtin_fn,
        $.identifier,
        $.number
      ),

    keyword_specifier: ($) =>
      seq(field("key", $.identifier), "=", field("value", $._specifier_value)),

    _specifier_value: ($) =>
      choice($.dotted_name, $.identifier, $.number),

    builtin_fn: (_) =>
      choice(
        "add", "mul", "sub", "div", "exp", "cos", "sin",
        "silu", "rsqrt", "where", "ge", "mean", "max", "min",
        "sum", "sqrt"
      ),

    // ── Arguments ─────────────────────────────────────────────

    arg_list: ($) => seq($.expression, repeat(seq(",", $.expression))),

    // ── Types ─────────────────────────────────────────────────

    type: ($) =>
      seq(
        field("dtype", $.dtype),
        optional(seq("[", $.shape_list, "]"))
      ),

    dtype: (_) => choice("bf16", "f16", "f32", "int32", "i32"),

    shape_list: ($) => seq($.shape_dim, repeat(seq(",", $.shape_dim))),

    shape_dim: ($) =>
      choice(
        $.number,
        $.identifier,
        seq("(", $.shape_dim, repeat(seq(" ", $.shape_dim)), ")")
      ),

    // ── Expressions ───────────────────────────────────────────

    expression: ($) =>
      choice(
        $.number,
        $.call_expr,
        $.dotted_name,
        $.identifier,
        $.pattern_string,
        $.array_literal,
        $.unary_expr,
        $.binary_expr,
        seq("(", $.expression, ")")
      ),

    call_expr: ($) =>
      seq(field("function", $.identifier), "(", optional($.arg_list), ")"),

    unary_expr: ($) => prec(3, seq("-", $.expression)),

    binary_expr: ($) =>
      choice(
        prec.left(1, seq($.expression, choice("+", "-"), $.expression)),
        prec.left(2, seq($.expression, choice("*", "/"), $.expression))
      ),

    array_literal: ($) =>
      seq("[", $.expression, repeat(seq(",", $.expression)), "]"),

    dotted_name: ($) =>
      seq($.identifier, repeat1(seq(".", $.identifier))),

    // ── Atoms ─────────────────────────────────────────────────

    pattern_string: (_) => seq('"', /[^"]*/, '"'),

    number: (_) => token(choice(
      /-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?/,
      /-?inf/
    )),

    identifier: (_) => /[a-zA-Z_]\w*/,

    comment: (_) => token(seq("//", /.*/)),
  },
});
