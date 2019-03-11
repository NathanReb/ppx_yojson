let output_stanzas filename =
  let base = Filename.remove_extension filename in
  Printf.printf
    {|
(rule
  (targets %s.actual)
  (deps (:pp pp.exe) (:input %s))
  (action
    (with-stderr-to
      %%{targets}
      (bash "./%%{pp} -no-color --impl %%{input} || true")
    )
  )
)

(alias
  (name runtest)
  (action (diff %s.expected %s.actual))
)
|}
    base
    filename
    base
    base

let prefix filename =
  try Some (String.sub filename 0 (String.length "test_error"))
  with Invalid_argument _ -> None

let is_error_test filename =
  let prefix = prefix filename in
  let extension = Filename.extension filename in
  match prefix, extension with
  | Some "test_error", ".ml" -> true
  | _ -> false

let () =
  Sys.readdir "."
  |> Array.to_list
  |> List.sort String.compare
  |> List.filter is_error_test
  |> List.iter output_stanzas
