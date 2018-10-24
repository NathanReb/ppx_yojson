(** General puprose helper functions *)

(** Return the given list without the element at index [idx].
    If [idx] is not a valid index in the given list, it is returned as is.
*)
val remove : idx: int -> 'a list -> 'a list

(** Return all the permutations of the given list *)
val permutations : 'a list -> 'a list list
