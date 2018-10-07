let int_of_string_opt s =
  try
    Some (int_of_string s)
  with Failure _ ->
    None
