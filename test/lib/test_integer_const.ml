let test_is_binary =
  let make_test input expected =
    let test_name = Printf.sprintf "is_binary: %S" input in
    let test_fun () =
      Alcotest.(check bool)
        test_name
        expected
        (Ppx_yojson_lib.Integer_const.is_binary input)
    in
    (test_name, `Quick, test_fun)
  in
  [ make_test "0b1" true
  ; make_test "0B1" true
  ; make_test "123" false
  ]

let test_is_octal =
  let make_test input expected =
    let test_name = Printf.sprintf "is_octal: %S" input in
    let test_fun () =
      Alcotest.(check bool)
        test_name
        expected
        (Ppx_yojson_lib.Integer_const.is_octal input)
    in
    (test_name, `Quick, test_fun)
  in
  [ make_test "0o1" true
  ; make_test "0O1" true
  ; make_test "123" false
  ]

let test_is_hexadecimal =
  let make_test input expected =
    let test_name = Printf.sprintf "is_hexadecimal: %S" input in
    let test_fun () =
      Alcotest.(check bool)
        test_name
        expected
        (Ppx_yojson_lib.Integer_const.is_hexadecimal input)
    in
    (test_name, `Quick, test_fun)
  in
  [ make_test "0x1" true
  ; make_test "0X1" true
  ; make_test "123" false
  ]

let suite =
  ("Integer_const",
   List.concat
     [ test_is_binary
     ; test_is_octal
     ; test_is_hexadecimal
     ]
  )
