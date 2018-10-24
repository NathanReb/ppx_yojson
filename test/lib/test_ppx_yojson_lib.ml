open OUnit2

let suite =
  "Ppx_yojson_lib" >:::
  [ Test_integer_const.suite
  ; Test_utils.suite
  ]

let () = run_test_tt_main suite
