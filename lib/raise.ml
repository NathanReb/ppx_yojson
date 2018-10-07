let unsupported_payload ~loc =
  Location.raise_errorf ~loc "ppx_yojson: unsupported payload"

let unsupported_record_field ~loc =
  Location.raise_errorf ~loc "ppx_yojson: unsupported record field"
