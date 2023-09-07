(** General puprose helper functions *)

val remove : idx:int -> 'a list -> 'a list
(** Return the given list without the element at index [idx].
    If [idx] is not a valid index in the given list, it is returned as is.
*)

val permutations : 'a list -> 'a list list
(** Return all the permutations of the given list *)

val rewrite_field_name : string -> string
(** Map OCaml record field name to the corresponding JSON field name.

    Ie. trim one leading undescore. *)
