open Ppxlib

let unsupported_payload ~loc =
  Location.error_extensionf ~loc "ppx_yojson: unsupported payload"

let unsupported_record_field ~loc =
  Location.error_extensionf ~loc "ppx_yojson: unsupported record field"

let too_many_fields_in_record_pattern ~loc =
  Location.error_extensionf ~loc
    "ppx_yojson: record patterns with more than 4 fields aren't supported. \
     Consider using ppx_deriving_yojson to handle more complex json objects."

let bad_expr_antiquotation_payload ~loc =
  Location.error_extensionf ~loc
    "ppx_yojson: bad antiquotation payload, should be a single expression"

let bad_pat_antiquotation_payload ~loc =
  Location.error_extensionf ~loc
    "ppx_yojson: bad antiquotation payload, should be a pattern"
