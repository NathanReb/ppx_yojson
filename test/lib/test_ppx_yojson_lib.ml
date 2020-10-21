let () =
  Alcotest.run "ppx_yojson_lib" [ Test_integer_const.suite; Test_utils.suite ]
