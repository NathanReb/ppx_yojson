module Einteger : sig
  val is_binary : Ppxlib.label -> bool
  val is_octal : Ppxlib.label -> bool
  val is_hexadecimal : Ppxlib.label -> bool
end

val expand_expr :
  loc: Ppxlib.Location.t ->
  path: string ->
  Ppxlib.expression ->
  Ppxlib.expression
