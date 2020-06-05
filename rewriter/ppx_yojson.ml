open Ppx

let name = "yojson"

let expr_extension =
  Ext.declare
    name
    Ext.Context.expression
    Ast_pattern.(single_expr_payload __)
    Ppx_yojson_lib.Expression.expand

let expr_rule = Ppx.Context_free.Rule.extension expr_extension

let pattern_extension =
  Ext.declare
    name
    Ext.Context.pattern
    Ast_pattern.(ppat __ none)
    Ppx_yojson_lib.Pattern.expand

let pattern_rule = Ppx.Context_free.Rule.extension pattern_extension

let () =
  Ppx.Driver.register_transformation 
    ~rules:[expr_rule; pattern_rule]
    name
