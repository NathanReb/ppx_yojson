(** Expression rewriting *)

val expand_ezjsonm :
  loc:Ppxlib.Location.t -> path:string -> Ppxlib.expression -> Ppxlib.expression

val expand_yojson :
  loc:Ppxlib.Location.t -> path:string -> Ppxlib.expression -> Ppxlib.expression
