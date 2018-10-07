open Ppxlib

let name = "yojson"

let expr_extension =
  Extension.declare
    name
    Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    Ppx_yojson_lib.Expression.expand

let expr_rule = Ppxlib.Context_free.Rule.extension expr_extension

let pattern_extension =
  Extension.declare
    name
    Extension.Context.pattern
    Ast_pattern.(ppat __ none)
    Ppx_yojson_lib.Pattern.expand

let pattern_rule = Ppxlib.Context_free.Rule.extension pattern_extension

let () =
  Ppxlib.Driver.register_transformation
    ~rules:[expr_rule; pattern_rule]
    name
