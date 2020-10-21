(** Helper functions to deal with AST's integer literals *)

val is_binary : string -> bool
(** Return whether this integer string representation is in binary form.
    i.e. if its in the form [0b100101].
*)

val is_octal : string -> bool
(** Return whether this integer string representation is in octal form.
    i.e. if its in the form [0o1702].
*)

val is_hexadecimal : string -> bool
(** Return whether this integer string representation is in hexadecimal form.
    i.e. if its in the form [0ox1a9f].
*)
