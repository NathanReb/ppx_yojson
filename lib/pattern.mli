(** Pattern rewriting *)

val expand :
  loc:Ppxlib.Location.t -> path:string -> Ppxlib.pattern -> Ppxlib.pattern
