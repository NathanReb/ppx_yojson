open Ppxlib

let name = "yojson"

let unsupported ~loc =
  Location.raise_errorf ~loc "ppx_yojson: unsupported payload"

module Estring = struct
  let expand ~loc ~path:_ s = [%expr `String [%e Ast_builder.Default.estring ~loc s]]
end

module Einteger = struct
  let int_of_string_opt s =
    try
      Some (int_of_string s)
    with Failure _ ->
      None

  let is_special_encoding c s =
    s.[0] = '0' && (s.[1] = c || s.[1] = Char.uppercase_ascii c)

  let is_binary s = is_special_encoding 'b' s
  let is_octal s = is_special_encoding 'o' s
  let is_hexadecimal s = is_special_encoding 'x' s

  let expand ~loc ~path:_ s =
    match int_of_string_opt s with
    | Some i -> [%expr `Int [%e Ast_builder.Default.eint ~loc i]]
    | None when is_binary s -> unsupported ~loc
    | None when is_octal s -> unsupported ~loc
    | None when is_hexadecimal s -> unsupported ~loc
    | None -> [%expr `Intlit [%e Ast_builder.Default.estring ~loc s]]
end

module Efloat = struct
  let expand ~loc ~path:_ s = [%expr `Float [%e Ast_builder.Default.efloat ~loc s]]
end

let rec expand_expr ~loc ~path expr =
  match expr with
  | [%expr None] -> [%expr `Null]
  | [%expr true] -> [%expr (`Bool true)]
  | [%expr false] -> [%expr (`Bool false)]
  | {pexp_desc = Pexp_constant (Pconst_string (s, None)); _} -> Estring.expand ~loc ~path s
  | {pexp_desc = Pexp_constant (Pconst_integer (s, None)); _} -> Einteger.expand ~loc ~path s
  | {pexp_desc = Pexp_constant (Pconst_float (s, None)); _} -> Efloat.expand ~loc ~path s
  | [%expr []] -> [%expr `List []]
  | [%expr [%e? _]::[%e? _]] -> [%expr `List [%e expand_list_expr ~loc ~path expr]]
  | {pexp_desc = Pexp_record (l, None); _} -> [%expr `Assoc [%e expand_record ~loc ~path l]]
  | _ ->
    unsupported ~loc:expr.pexp_loc
and expand_list_expr ~loc ~path = function
  | [%expr []]
    ->
    [%expr []]
  | [%expr [%e? hd]::[%e? tl]]
    ->
    let json_hd = expand_expr ~loc ~path hd in
    let json_tl = expand_list_expr ~loc ~path tl in
    [%expr [%e json_hd]::[%e json_tl]]
  | _ -> assert false
and expand_record ~loc ~path l =
  let field = function
    | {txt = Lident s; _} -> [%expr [%e Ast_builder.Default.estring ~loc s]]
    | {txt = _; loc} -> Location.raise_errorf ~loc "ppx_yojson: unsupported record field"
  in
  let expand_one (f, e) =
    [%expr ([%e field f], [%e expand_expr ~loc:e.pexp_loc ~path e])]
  in
  let expr_list = List.map expand_one l in
  [%expr [%e Ast_builder.Default.elist ~loc expr_list]]

let expr_extension =
  Extension.declare
    name
    Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    expand_expr

let expr_rule = Ppxlib.Context_free.Rule.extension expr_extension

let () =
  Ppxlib.Driver.register_transformation
    ~rules:[expr_rule]
    name
