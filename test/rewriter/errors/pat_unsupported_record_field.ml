let unsupported_record_field = function
  | [%yojson? {A.field = 0}] -> false
  | _ -> true
