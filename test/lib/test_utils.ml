let test_remove =
  let make_test ~name ~idx ~l ~expected =
    let test_name = "remove: " ^ name in
    let test_fun () =
      Alcotest.(check (list int))
        test_name
        expected
        (Ppx_yojson_lib.Utils.remove ~idx l)
    in
    (test_name, `Quick, test_fun)
  in
  [ make_test ~name:"Empty" ~idx:0 ~l:[] ~expected:[]
  ; make_test ~name:"First" ~idx:0 ~l:[1] ~expected:[]
  ; make_test ~name:"Last" ~idx:1 ~l:[1; 2] ~expected:[1]
  ; make_test ~name:"Some" ~idx:2 ~l:[1; 2; 3; 4] ~expected:[1; 2; 4]
  ]

let test_permutations =
  let make_test ~name ~input ~expected =
    let test_name = "permutations: " ^ name in
    let test_fun () =
      Alcotest.(check (list (list int)))
        test_name
        expected
        (Ppx_yojson_lib.Utils.permutations input)
    in
    (test_name, `Quick, test_fun)
  in
  [ make_test ~name:"Empty" ~input:[] ~expected:[[]]
  ; make_test ~name:"One" ~input:[1] ~expected:[[1]]
  ; make_test ~name:"Two" ~input:[1; 2] ~expected:[[1; 2]; [2; 1]]
  ; make_test ~name:"Three" ~input:[1; 2; 3]
      ~expected:[[1; 2; 3]; [1; 3; 2]; [2; 1; 3]; [2; 3; 1]; [3; 1; 2]; [3; 2; 1]]
  ]

let suite =
  ("Utils",
   List.concat
     [ test_remove
     ; test_permutations
     ]
  )
