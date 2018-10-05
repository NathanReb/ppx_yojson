(** Test function for properties.
    [test_prop prop expected input ctxt] is [assert_equal ~ctxt expected (prop input)]
*)
val test_prop : ('a -> bool) -> bool -> 'a -> OUnit2.test_ctxt -> unit

module Infix : sig
  (** Create a test which also takes its label as input *)
  val (>:=) : string -> (string -> OUnit2.test_fun) -> OUnit2.test
end
