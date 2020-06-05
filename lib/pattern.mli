(** Pattern rewriting *)

val expand :
  loc: Ppx.Location.t ->
  path: string ->
  Ppx.pattern ->
  Ppx.pattern
