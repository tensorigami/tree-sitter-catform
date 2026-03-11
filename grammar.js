/// <reference types="tree-sitter-cli/dsl" />

module.exports = grammar({
  name: "catform",

  extras: ($) => [/\s/, $.comment],

  rules: {
    source_file: ($) => repeat($.function_def),

    // ── Function definition ───────────────────────────────────

    function_def: ($) =>
      seq(
        field("name", $.identifier),
        "(", optional($.param_list), ")",
        optional(seq("->", field("return_type", $.return_type))),
        "{", repeat($._statement), "}"
      ),

    param_list: ($) => seq($.param_entry, repeat(seq(",", $.param_entry))),

    param_entry: ($) =>
      seq(field("name", $.identifier), ":", field("type", $.type)),

    // Named tuple return: -> (name: type, name: type)
    return_type: ($) => seq("(", $.param_list, ")"),

    // ── Statements ────────────────────────────────────────────

    _statement: ($) => choice($.assignment, $.tuple_assignment),

    // name : type = op(...)
    assignment: ($) =>
      seq(
        field("output", $.identifier),
        ":",
        field("type", $.type),
        "=",
        field("op", $.op_call)
      ),

    // (a, b) : (type, type) = op(...)
    tuple_assignment: ($) =>
      seq(
        field("output", $.tuple_pattern),
        ":",
        field("type", $.tuple_type),
        "=",
        field("op", $.op_call)
      ),

    tuple_pattern: ($) =>
      seq("(", $.identifier, repeat(seq(",", $.identifier)), ")"),

    tuple_type: ($) =>
      seq("(", $.type, repeat(seq(",", $.type)), ")"),

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
        $.dotted_name,
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

    arg_list: ($) => seq($._arg, repeat(seq(",", $._arg))),

    _arg: ($) => choice($.dotted_name, $.identifier, $.number),

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
        $.dotted_name,
        $.identifier,
        seq("(", $.shape_dim, repeat(seq(" ", $.shape_dim)), ")")
      ),

    // ── Names ─────────────────────────────────────────────────

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
