(** Functions to raise ppx_yojson rewriting errors.

    The [loc] argument should be the loc of the problematic expression within the payload
    and not the [loc] argument of the [expand] function to provide the user
    accurate information as to what should be fixed.
*)

(** Use this for unsupported payload expressions. *)
val unsupported_payload :
  loc: Ppx.Location.t ->
  'a

(** Use this for unsupported Longident used as record fields. *)
val unsupported_record_field :
  loc: Ppx.Location.t ->
  'a

(** Use this for record pattern with more than 4 fields. *)
val too_many_fields_in_record_pattern :
  loc: Ppx.Location.t ->
  'a

(** Use this for bad payload in expression antiquotation [[%y ...]]. *)
val bad_expr_antiquotation_payload :
  loc: Ppx.Location.t ->
  'a

(** Use this for bad payload in pattern antiquotation [[%y? ...]]. *)
val bad_pat_antiquotation_payload :
  loc: Ppx.Location.t ->
  'a
