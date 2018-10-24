let unsupported_payload ~loc =
  Location.raise_errorf ~loc "ppx_yojson: unsupported payload"

let unsupported_record_field ~loc =
  Location.raise_errorf ~loc "ppx_yojson: unsupported record field"

let too_many_fields_in_record_pattern ~loc =
  Location.raise_errorf
    ~loc
    "ppx_yojson: record patterns with more than 4 fields aren't supported. \
     Consider using ppx_deriving_yojson to handle more complex json objects."
