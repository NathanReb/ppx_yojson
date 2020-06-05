(** Expression rewriting *)

val expand :
  loc: Ppx.Location.t ->
  path: string ->
  Ppx.expression ->
  Ppx.expression
