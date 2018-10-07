open Ppxlib

let expand_string ~loc s = [%expr `String [%e Ast_builder.Default.estring ~loc s]]

let expand_int ~loc s =
  match Ocaml_compat.int_of_string_opt s with
  | Some i -> [%expr `Int [%e Ast_builder.Default.eint ~loc i]]
  | None when Integer_const.is_binary s -> Raise.unsupported_payload ~loc
  | None when Integer_const.is_octal s -> Raise.unsupported_payload ~loc
  | None when Integer_const.is_hexadecimal s -> Raise.unsupported_payload ~loc
  | None -> [%expr `Intlit [%e Ast_builder.Default.estring ~loc s]]

let expand_float ~loc s = [%expr `Float [%e Ast_builder.Default.efloat ~loc s]]

let rec expand ~loc ~path expr =
  match expr with
  | [%expr None] -> [%expr `Null]
  | [%expr true] -> [%expr (`Bool true)]
  | [%expr false] -> [%expr (`Bool false)]
  | {pexp_desc = Pexp_constant (Pconst_string (s, None)); _} -> expand_string ~loc s
  | {pexp_desc = Pexp_constant (Pconst_integer (s, None)); _} -> expand_int ~loc s
  | {pexp_desc = Pexp_constant (Pconst_float (s, None)); _} -> expand_float ~loc s
  | [%expr []] -> [%expr `List []]
  | [%expr [%e? _]::[%e? _]] -> [%expr `List [%e expand_list ~loc ~path expr]]
  | {pexp_desc = Pexp_record (l, None); _} -> [%expr `Assoc [%e expand_record ~loc ~path l]]
  | _ -> Raise.unsupported_payload ~loc:expr.pexp_loc
and expand_list ~loc ~path = function
  | [%expr []]
    ->
    [%expr []]
  | [%expr [%e? hd]::[%e? tl]]
    ->
    let json_hd = expand ~loc ~path hd in
    let json_tl = expand_list ~loc ~path tl in
    [%expr [%e json_hd]::[%e json_tl]]
  | _ -> assert false
and expand_record ~loc ~path l =
  let field = function
    | {txt = Lident s; _} -> [%expr [%e Ast_builder.Default.estring ~loc s]]
    | {txt = _; loc} -> Raise.unsupported_record_field ~loc
  in
  let expand_one (f, e) =
    [%expr ([%e field f], [%e expand ~loc:e.pexp_loc ~path e])]
  in
  let expr_list = List.map expand_one l in
  [%expr [%e Ast_builder.Default.elist ~loc expr_list]]
