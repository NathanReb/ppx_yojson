open OUnit2

module Einteger = struct
  let test_is_binary =
    let test = Utils.test_prop Ppx_yojson_lib.Einteger.is_binary in
    let open Utils.Infix in
    "is_binary" >:::
    [ "0b1" >:= test true
    ; "0B1" >:= test true
    ; "123" >:= test false
    ]

  let test_is_octal =
    let test = Utils.test_prop Ppx_yojson_lib.Einteger.is_octal in
    let open Utils.Infix in
    "is_octal" >:::
    [ "0o1" >:= test true
    ; "0O1" >:= test true
    ; "123" >:= test false
    ]

  let test_is_hexadecimal =
    let test = Utils.test_prop Ppx_yojson_lib.Einteger.is_hexadecimal in
    let open Utils.Infix in
    "is_hexadecimal" >:::
    [ "0x1" >:= test true
    ; "0X1" >:= test true
    ; "123" >:= test false
    ]

  let suite =
    "Einteger" >:::
    [ test_is_binary
    ; test_is_octal
    ; test_is_hexadecimal
    ]
end

let suite =
  "Ppx_yojson_lib" >:::
  [ Einteger.suite
  ]

let () = run_test_tt_main suite
