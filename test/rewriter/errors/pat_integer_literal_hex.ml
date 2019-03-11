let invalid_integer_literal = function
  | [%yojson? 0xffffffffffffffffffffffffffffffffffffffffff] -> false
  | _ -> true
