type json = Yojson.Safe.t

val null : json
val true_ : json
val false_ : json
val string : json
val int : json
val int_lit : json
val float : json
val empty_array : json
val array : json
val mixed_array : json
val record : json
val complex : json
val legacy_anti_quotation : json
val anti_quotation : json
val int_64 : json
val int_32 : json
val native_int : json
val patterns : json -> unit
val field_renaming : json
val field_renaming_with_attr : json
