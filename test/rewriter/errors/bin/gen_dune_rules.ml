let output_stanzas filename =
  let base = Filename.remove_extension filename in
  Printf.printf
    {|
(rule
  (targets %s.actual)
  (deps (:pp bin/pp.exe) (:input %s.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %%{targets}
          (run ./%%{pp} -no-color --impl %%{input}))))))

(rule
  (alias runtest)
  (action (diff %s.expected %s.actual)))
|}
    base base base base

let is_error_test filename = Filename.check_suffix filename ".ml"

let () =
  Sys.readdir "." |> Array.to_list |> List.sort String.compare
  |> List.filter is_error_test |> List.iter output_stanzas
