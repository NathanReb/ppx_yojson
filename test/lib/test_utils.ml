open OUnit2

let test_remove =
  let test ~idx ~l ~expected ctxt =
    let actual = Ppx_yojson_lib.Utils.remove ~idx l in
    assert_equal ~ctxt ~cmp:[%eq: int list] ~printer:[%show: int list] expected actual
  in
  "remove" >:::
  [ "Empty" >:: test ~idx:0 ~l:[] ~expected:[]
  ; "First" >:: test ~idx:0 ~l:[1] ~expected:[]
  ; "Last" >:: test ~idx:1 ~l:[1; 2] ~expected:[1]
  ; "Some" >:: test ~idx:2 ~l:[1; 2; 3; 4] ~expected:[1; 2; 4]
  ]

let test_permutations =
  let test l expected ctxt =
    let actual = Ppx_yojson_lib.Utils.permutations l in
    assert_equal ~ctxt ~cmp:[%eq: int list list] ~printer:[%show: int list list] expected actual
  in
  "permutations" >:::
  [ "Empty" >:: test [] [[]]
  ; "One" >:: test [1] [[1]]
  ; "Two" >:: test [1; 2] [[1; 2]; [2; 1]]
  ; "Three" >:: test [1; 2; 3] [[1; 2; 3]; [1; 3; 2]; [2; 1; 3]; [2; 3; 1]; [3; 1; 2]; [3; 2; 1]]
  ]

let suite =
  "Utils" >:::
  [ test_remove
  ; test_permutations
  ]
