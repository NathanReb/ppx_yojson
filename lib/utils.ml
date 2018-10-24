let remove ~idx l =
  let rec aux ~left ~right ~i =
    match right with
    | _::tl when i = idx -> List.rev_append left tl
    | hd::tl -> aux ~left:(hd::left) ~right:tl ~i:(i + 1)
    | [] -> l
  in
  aux ~left:[] ~right:l ~i:0

let rec permutations = function
  | [] -> [[]]
  | [elm] -> [[elm]]
  | l ->
    List.mapi
      (fun idx elm -> List.map (List.cons elm) (permutations @@ remove ~idx l))
      l
  |> List.flatten
