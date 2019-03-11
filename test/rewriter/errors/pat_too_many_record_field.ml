let too_many_record_field = function
  | [%yojson? {a = 1; b = 2; c = 3; d = 4; e = 5}] -> false
  | _ -> true
