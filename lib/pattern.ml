open Ppxlib

let expand_string ~loc s =
  [%pat? `String [%p Ast_builder.Default.pstring ~loc s]]

let expand_intlit ~loc s =
  [%pat? `Intlit [%p Ast_builder.Default.pstring ~loc s]]

let expand_int ~loc ~ppat_loc s =
  match int_of_string_opt s with
  | Some i -> [%pat? `Int [%p Ast_builder.Default.pint ~loc i]]
  | None when Integer_const.is_binary s ->
      Ast_builder.Default.ppat_extension ~loc:ppat_loc
        (Error.unsupported_payload ~loc:ppat_loc)
  | None when Integer_const.is_octal s ->
      Ast_builder.Default.ppat_extension ~loc:ppat_loc
        (Error.unsupported_payload ~loc:ppat_loc)
  | None when Integer_const.is_hexadecimal s ->
      Ast_builder.Default.ppat_extension ~loc:ppat_loc
        (Error.unsupported_payload ~loc:ppat_loc)
  | None -> expand_intlit ~loc s

let expand_float ~loc s = [%pat? `Float [%p Ast_builder.Default.pfloat ~loc s]]
let expand_var ~loc var = Ast_builder.Default.ppat_var ~loc var

let expand_anti_quotation ~ppat_loc = function
  | PPat (ppat, _) -> ppat
  | PStr _ | PSig _ | PTyp _ ->
      Ast_builder.Default.ppat_extension ~loc:ppat_loc
        (Error.bad_pat_antiquotation_payload ~loc:ppat_loc)

let rec expand ~loc ~path pat =
  match pat with
  | [%pat? _] -> [%pat? _]
  | [%pat? None] -> [%pat? `Null]
  | [%pat? true] -> [%pat? `Bool true]
  | [%pat? false] -> [%pat? `Bool false]
  | { ppat_desc = Ppat_constant (Pconst_string (s, _, None)); _ } ->
      expand_string ~loc s
  | { ppat_desc = Ppat_constant (Pconst_integer (s, None)); ppat_loc; _ } ->
      expand_int ~loc ~ppat_loc s
  | {
   ppat_desc = Ppat_constant (Pconst_integer (s, Some ('l' | 'L' | 'n')));
   _;
  } ->
      expand_intlit ~loc s
  | { ppat_desc = Ppat_constant (Pconst_float (s, None)); _ } ->
      expand_float ~loc s
  | { ppat_desc = Ppat_var v; _ } -> expand_var ~loc v
  | { ppat_desc = Ppat_extension ({ txt = "y" | "aq"; _ }, p); ppat_loc; _ } ->
      expand_anti_quotation ~ppat_loc p
  | [%pat? [%p? left] | [%p? right]] ->
      [%pat? [%p expand ~loc ~path left] | [%p expand ~loc ~path right]]
  | { ppat_desc = Ppat_alias (pat, var); _ } ->
      let pat = expand ~loc ~path pat in
      Ast_builder.Default.ppat_alias ~loc pat var
  | [%pat? []] -> [%pat? `List []]
  | [%pat? [%p? _] :: [%p? _]] -> [%pat? `List [%p expand_list ~loc ~path pat]]
  | { ppat_desc = Ppat_record (l, Closed); ppat_loc; _ } ->
      expand_record ~loc ~ppat_loc ~path l
  | { ppat_loc = loc; _ } ->
      Ast_builder.Default.ppat_extension ~loc (Error.unsupported_payload ~loc)

and expand_list ~loc ~path = function
  | [%pat? []] -> [%pat? []]
  | [%pat? [%p? hd] :: [%p? tl]] ->
      let json_hd = expand ~loc ~path hd in
      let json_tl = expand_list ~loc ~path tl in
      [%pat? [%p json_hd] :: [%p json_tl]]
  | _ -> assert false

and expand_record ~loc ~ppat_loc ~path l =
  let expand_one (f, p) =
    let as_attr =
      List.find_opt
        (fun attr -> String.equal attr.attr_name.txt "as")
        p.ppat_attributes
    in
    let field =
      match (as_attr, f) with
      | Some { attr_payload; attr_loc = loc; _ }, _ ->
          Ast_pattern.(parse (single_expr_payload (estring __)))
            loc attr_payload (fun e -> Ok e)
      | None, { txt = Lident s; _ } -> Ok (Utils.rewrite_field_name s)
      | None, { txt = _; loc } ->
          let pat_ext =
            Ast_builder.Default.ppat_extension ~loc
              (Error.unsupported_record_field ~loc)
          in
          Error pat_ext
    in
    match field with
    | Ok field ->
        [%pat?
          [%p Ast_builder.Default.pstring ~loc field], [%p expand ~loc ~path p]]
    | Error extension -> extension
  in
  let assoc_pattern pat_list =
    [%pat? `Assoc [%p Ast_builder.Default.plist ~loc pat_list]]
  in
  if List.length l > 4 then
    Ast_builder.Default.ppat_extension ~loc:ppat_loc
      (Error.too_many_fields_in_record_pattern ~loc:ppat_loc)
  else
    let pat_list = List.map expand_one l in
    let permutations = Utils.permutations pat_list in
    let assoc_patterns = List.map assoc_pattern permutations in
    match assoc_patterns with
    | [] -> assert false
    | [ single ] -> single
    | hd :: tl ->
        List.fold_left (fun acc elm -> [%pat? [%p acc] | [%p elm]]) hd tl
