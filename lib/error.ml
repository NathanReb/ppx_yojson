open Ppxlib

let errorf ~loc message =
  Location.error_extensionf ~loc "ppx_yojson: %s" message

let unsupported_payload ~loc = errorf ~loc "unsupported payload"
let unsupported_record_field ~loc = errorf ~loc "unsupported record field"

let too_many_fields_in_record_pattern ~loc =
  errorf ~loc
    "record patterns with more than 4 fields aren't supported. Consider using \
     ppx_deriving_yojson to handle more complex json objects."

let bad_expr_antiquotation_payload ~loc =
  errorf ~loc "bad antiquotation payload, should be a single expression"

let bad_pat_antiquotation_payload ~loc =
  errorf ~loc "bad antiquotation payload, should be a pattern"

let invalid_integer_literal_yojson ~loc =
  errorf ~loc
    "invalid interger literal. Integer literal should fit within an OCaml int \
     or be written in decimal form."

let invalid_integer_literal_ezjsonm ~loc =
  errorf ~loc
    "invalid interger literal. Integer literal should fit within an OCaml int."
