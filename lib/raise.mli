(** Functions to raise ppx_yojson rewriting errors.

    The [loc] argument should be the loc of the problematic expression within the payload
    and not the [loc] argument of the [expand] function to provide the user
    accurate information as to what should be fixed.
*)

(** Use this for unsupported payload expressions. *)
val unsupported_payload :
  loc: Ppxlib.Location.t ->
  'a

(** Use this for unsupported Longident used as record fields. *)
val unsupported_record_field :
  loc: Ppxlib.Location.t ->
  'a
