open Ppxlib

let name = "yojson"

let expr_extension =
  Extension.declare
    name
    Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    Ppx_yojson_lib.Expression.expand

let expr_rule = Ppxlib.Context_free.Rule.extension expr_extension

let () =
  Ppxlib.Driver.register_transformation
    ~rules:[expr_rule]
    name
