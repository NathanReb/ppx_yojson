let unsupported_payload = function
  | [%yojson? Ok ()] -> false
  | _ -> true
