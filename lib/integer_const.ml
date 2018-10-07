let is_special_encoding c s =
  s.[0] = '0' && (s.[1] = c || s.[1] = Char.uppercase_ascii c)

let is_binary s = is_special_encoding 'b' s
let is_octal s = is_special_encoding 'o' s
let is_hexadecimal s = is_special_encoding 'x' s
