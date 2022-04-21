open Ppxlib

module type EXPANDER = sig
  val expand_bool : loc:location -> bool -> expression

  val expand_float : loc:location -> string -> expression

  val expand_int : loc:location -> pexp_loc:location -> string -> expression

  val expand_intlit : loc:location -> string -> expression

  val expand_list : loc:location -> expression list -> expression

  val expand_none : loc:location -> unit -> expression

  val expand_record : loc:location -> (string * expression) list -> expression
  (** Expands a list of field names and associated expanded expressions into 
      the corresponding JSON object encoding. *)

  val expand_string : loc:location -> string -> expression
end

module Common = struct
  let expand_bool ~loc = function
    | true -> [%expr `Bool true]
    | false -> [%expr `Bool false]

  let expand_float ~loc s =
    [%expr `Float [%e Ast_builder.Default.efloat ~loc s]]

  let expand_none ~loc () = [%expr `Null]

  let expand_string ~loc s =
    [%expr `String [%e Ast_builder.Default.estring ~loc s]]

  let expand_list ~loc wrap exprs = wrap (Ast_builder.Default.elist ~loc exprs)

  let expand_record ~loc wrap fields =
    let fields =
      let f (name, value) =
        [%expr [%e Ast_builder.Default.estring ~loc name], [%e value]]
      in
      List.map f fields
    in
    wrap (Ast_builder.Default.elist ~loc fields)
end

module Ezjsonm_expander : EXPANDER = struct
  include Common

  let expand_intlit ~loc _ = Raise.unsupported_payload ~loc

  let expand_int ~loc ~pexp_loc s =
    match int_of_string_opt s with
    | Some i ->
        [%expr `Float [%e Ast_builder.Default.efloat ~loc (string_of_int i)]]
    | _ -> Ast_builder.Default.pexp_extension ~loc
                    @@ Location.error_extensionf ~loc:pexp_loc "ppx_yojson: unsupported payload"

  let expand_list ~loc exprs =
    expand_list ~loc (fun e -> [%expr `A [%e e]]) exprs

  let expand_record ~loc fields =
    expand_record ~loc (fun e -> [%expr `O [%e e]]) fields
end

module Yojson_expander : EXPANDER = struct
  include Common

  let expand_intlit ~loc s =
    [%expr `Intlit [%e Ast_builder.Default.estring ~loc s]]

  let expand_int ~loc ~pexp_loc s =
    match int_of_string_opt s with
    | Some i -> [%expr `Int [%e Ast_builder.Default.eint ~loc i]]
    | None when Integer_const.is_binary s ->
        Ast_builder.Default.pexp_extension ~loc
                    @@ Location.error_extensionf ~loc:pexp_loc "ppx_yojson: unsupported payload"
    | None when Integer_const.is_octal s ->
        Ast_builder.Default.pexp_extension ~loc
                    @@ Location.error_extensionf ~loc:pexp_loc "ppx_yojson: unsupported payload"
    | None when Integer_const.is_hexadecimal s ->
        Ast_builder.Default.pexp_extension ~loc
                    @@ Location.error_extensionf ~loc:pexp_loc "ppx_yojson: unsupported payload"
    | None -> expand_intlit ~loc s

  let expand_list ~loc exprs =
    expand_list ~loc (fun e -> [%expr `List [%e e]]) exprs

  let expand_record ~loc fields =
    expand_record ~loc (fun e -> [%expr `Assoc [%e e]]) fields
end

module Make (Expander : EXPANDER) = struct
  let expand_anti_quotation ~pexp_loc = function
    | PStr [ { pstr_desc = Pstr_eval (expr, _); _ } ] -> expr
    | PStr _ | PSig _ | PTyp _ | PPat _ ->
        Raise.bad_expr_antiquotation_payload ~loc:pexp_loc

  let rec expand ~loc ~path expr =
    match expr with
    | [%expr None] -> Expander.expand_none ~loc ()
    | [%expr true] -> Expander.expand_bool ~loc true
    | [%expr false] -> Expander.expand_bool ~loc false
    | { pexp_desc = Pexp_constant (Pconst_string (s, _, None)); _ } ->
        Expander.expand_string ~loc s
    | { pexp_desc = Pexp_constant (Pconst_integer (s, None)); pexp_loc; _ } ->
        Expander.expand_int ~loc ~pexp_loc s
    | {
     pexp_desc = Pexp_constant (Pconst_integer (s, Some ('l' | 'L' | 'n')));
     _;
    } ->
        Expander.expand_intlit ~loc s
    | { pexp_desc = Pexp_constant (Pconst_float (s, None)); _ } ->
        Expander.expand_float ~loc s
    | [%expr []] -> Expander.expand_list ~loc []
    | [%expr [%e? _] :: [%e? _]] ->
        Expander.expand_list ~loc (expand_list ~loc ~path expr)
    | { pexp_desc = Pexp_record (l, None); _ } ->
        Expander.expand_record ~loc (expand_record ~path l)
    | { pexp_desc = Pexp_extension ({ txt = "y" | "aq"; _ }, p); pexp_loc; _ }
      ->
        expand_anti_quotation ~pexp_loc p
    | _ -> Ast_builder.Default.pexp_extension ~loc
                    @@ Location.error_extensionf ~loc:expr.pexp_loc "ppx_yojson: unsupported payload"

  and expand_list ~loc ~path = function
    | [%expr []] -> []
    | [%expr [%e? hd] :: [%e? tl]] ->
        let json_hd = expand ~loc ~path hd in
        let json_tl = expand_list ~loc ~path tl in
        json_hd :: json_tl
    | _ -> assert false

  and expand_record ~path l =
    let field = function
      | { txt = Lident s; _ } -> s
      | { txt = _; loc } -> Raise.unsupported_record_field ~loc
    in
    let expand_one (f, e) = (field f, expand ~loc:e.pexp_loc ~path e) in
    List.map expand_one l
end

module Ezjsonm = Make (Ezjsonm_expander)
module Yojson = Make (Yojson_expander)

let expand_ezjsonm = Ezjsonm.expand

let expand_yojson = Yojson.expand
