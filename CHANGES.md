## unreleased

### Added

### Changed

- Insert errors in the AST rather than raising exceptions. This allows
  merlin to report all ppx_yojson errors at once. (#44, @NathanReb)

### Deprecated

### Fixed

### Removed

### Security

## 1.3.0

### Added

- Add support for `[@as "field_name"]` attribute to allow forbidden
  ocaml record field names, such as capitalized words, to be used as JSON
  objects field names (#40, @mefyl)

### Changed

- Ignore leading underscores in object field names allowing use
  of ocaml keywords such as `type` or `object` as JSON objects field names
  (#40, @mefyl)

## 1.2.0

### Added

- Support `%ezjsonm` extension to output Ezjsonm-compatible values.
  (#31, @mefyl)
- Add generic antiquotation syntax `[%aq ...]` (#32, @NathanReb)

## 1.1.0

### Added

- Make ppx_yojson fully compatible with 4.11 (#22, @NathanReb)

## 1.0.0

### Additions

- Add anti-quotations `[%y? pat]` in pattern extension (#18, @noRubidium)

## 0.2.0

*2018-12-04*

### Additions

- Add an extension to write Yojson patterns
- Add anti-quotations `[%y expr]` in expression extension
- Add support for `int32`, `int64` and `nativeint` payloads

### Fixes

- Improve error's loc for unsupported int literals in expression extension's payload

## 0.1.0

*2018-10-04*

Initial release
