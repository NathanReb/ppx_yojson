let invalid_anti_quotation_pattern = function
  | [%yojson? [%y `Int _a]] -> false
  | _ -> true
