(** Expression rewriting *)

val expand :
  loc: Ppxlib.Location.t ->
  path: string ->
  Ppxlib.expression ->
  Ppxlib.expression
