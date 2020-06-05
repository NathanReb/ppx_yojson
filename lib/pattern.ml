open Ppx
open V4_07

let expand_string ~loc s = [%pat? `String [%p pstring ~loc s]]

let expand_intlit ~loc s = [%pat? `Intlit [%p pstring ~loc s]]

let expand_int ~loc ~ppat_loc s =
  match Ocaml_compat.int_of_string_opt s with
  | Some i -> [%pat? `Int [%p Ast_builder.pint ~loc i]]
  | None when Integer_const.is_binary s -> Raise.unsupported_payload ~loc:ppat_loc
  | None when Integer_const.is_octal s -> Raise.unsupported_payload ~loc:ppat_loc
  | None when Integer_const.is_hexadecimal s -> Raise.unsupported_payload ~loc:ppat_loc
  | None -> expand_intlit ~loc s

let expand_float ~loc s = [%pat? `Float [%p Ast_builder.pfloat ~loc s]]

let expand_var ~loc var = ppat_var ~loc var

let expand_anti_quotation ~ppat_loc = function%view
  | PPat (ppat, _) -> ppat
  | PStr _
  | PSig _
  | PTyp _ -> Raise.bad_pat_antiquotation_payload ~loc:ppat_loc

let rec expand ~loc ~path pat =
  match%view pat with
  | {ppat_desc = Ppat_any; _} -> [%pat? _]
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "None";_}, None); _} -> [%pat? `Null]
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "true"; _}, None); _} -> [%pat? `Bool true]
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "false"; _}, None); _} -> [%pat? `Bool false]
  | {ppat_desc = Ppat_constant (Pconst_string (s, None)); _} -> expand_string ~loc s
  | {ppat_desc = Ppat_constant (Pconst_integer (s, None)); ppat_loc; _}
    ->
    expand_int ~loc ~ppat_loc s
  | {ppat_desc = Ppat_constant (Pconst_integer (s, Some ('l' | 'L' | 'n'))); _}
    ->
    expand_intlit ~loc s
  | {ppat_desc = Ppat_constant (Pconst_float (s, None)); _} -> expand_float ~loc s
  | {ppat_desc = Ppat_var v; _} -> expand_var ~loc v
  | {ppat_desc = Ppat_extension (Extension ({txt = "y"; _}, p)); ppat_loc;_} 
    ->
    expand_anti_quotation ~ppat_loc p
  | {ppat_desc = Ppat_or (left, right); _}
    ->
    ([%pat? [%p expand ~loc ~path left] | [%p expand ~loc ~path right]])
  | {ppat_desc = Ppat_alias (pat, var); _}
    ->
    let pat = expand ~loc ~path pat in
    ppat_alias ~loc pat var
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "[]"; _}, None); _} -> [%pat? `List []]
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "::"; _}, Some {ppat_desc = Ppat_tuple [_; _]; _}); _}
    -> 
    [%pat? `List [%p expand_list ~loc ~path pat]]
  | {ppat_desc=Ppat_record (l, Closed); ppat_loc; _} -> expand_record ~loc ~ppat_loc ~path l
  | {ppat_loc = loc; _} -> Raise.unsupported_payload ~loc
and expand_list ~loc ~path = function%view
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "[]"; _}, None); _} -> [%pat? []]
  | {ppat_desc = Ppat_construct (Longident_loc {txt = Lident "::"; _}, Some {ppat_desc = Ppat_tuple [hd; tl]; _}); _}
    ->
    let json_hd = expand ~loc ~path hd in
    let json_tl = expand_list ~loc ~path tl in
    [%pat? [%p json_hd]::[%p json_tl]]
  | _ -> assert false
and expand_record ~loc ~ppat_loc ~path l =
  let field = function%view
    | Longident_loc {txt = Lident s; _} -> [%pat? [%p Ast_builder.pstring ~loc s]]
    | Longident_loc {txt = _; loc} -> Raise.unsupported_record_field ~loc
  in
  let expand_one (f, p) =
    [%pat? ([%p field f], [%p expand ~loc ~path p])]
  in
  let assoc_pattern pat_list = [%pat? `Assoc [%p Ast_builder.plist ~loc pat_list]] in
  if List.length l > 4 then
    Raise.too_many_fields_in_record_pattern ~loc:ppat_loc
  else
    let pat_list = List.map expand_one l in
    let permutations = Utils.permutations pat_list in
    let assoc_patterns = List.map assoc_pattern permutations in
    match assoc_patterns with
    | [] -> assert false
    | [single] -> single
    | hd::tl -> List.fold_left (fun acc elm -> [%pat? [%p acc] | [%p elm]]) hd tl
