open OUnit2

let test_prop prop expected input ctxt =
  let actual = prop input in
  assert_equal ~ctxt ~cmp:[%eq: bool] ~printer:[%show: bool] expected actual

module Infix = struct
  let (>:=) name test = name >:: test name
end
