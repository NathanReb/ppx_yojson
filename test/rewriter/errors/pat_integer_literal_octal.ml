let invalid_integer_literal = function
  | [%yojson? 0o777777777777777777777777777777777777777777777] -> false
  | _ -> true
