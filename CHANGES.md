## unreleased

### Added

- Support `%ezjsonm` extension to output Ezjsonm-compatible values.
  (#31, @mefyl)

### Changed

### Deprecated

### Removed

### Fixed

### Security

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
