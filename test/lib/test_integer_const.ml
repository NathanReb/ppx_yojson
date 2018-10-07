open OUnit2

let test_is_binary =
  let test = Utils.test_prop Ppx_yojson_lib.Integer_const.is_binary in
  let open Utils.Infix in
  "is_binary" >:::
  [ "0b1" >:= test true
  ; "0B1" >:= test true
  ; "123" >:= test false
  ]

let test_is_octal =
  let test = Utils.test_prop Ppx_yojson_lib.Integer_const.is_octal in
  let open Utils.Infix in
  "is_octal" >:::
  [ "0o1" >:= test true
  ; "0O1" >:= test true
  ; "123" >:= test false
  ]

let test_is_hexadecimal =
  let test = Utils.test_prop Ppx_yojson_lib.Integer_const.is_hexadecimal in
  let open Utils.Infix in
  "is_hexadecimal" >:::
  [ "0x1" >:= test true
  ; "0X1" >:= test true
  ; "123" >:= test false
  ]

let suite =
  "Integer_const" >:::
  [ test_is_binary
  ; test_is_octal
  ; test_is_hexadecimal
  ]
