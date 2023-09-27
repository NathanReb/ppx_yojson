We want to ensure ppx_yojson properly reports error.

We create a simple library using `ppx_yojson`

  $ cat >dune-project <<EOF
  > (lang dune 2.7)
  > EOF

  $ cat >dune <<EOF
  > (library
  >  (name test)
  >  (preprocess (pps ppx_yojson)))
  > EOF

We inject a misuse of `ppx_yojson` in `test.ml`. Here we ensure it properly
reports when the antiquotation payload is incorrect:

  $ cat >test.ml <<EOF
  > let bad_anti_quote_payload = [%yojson [%y? _]]
  > EOF

We then try to build our library

  $ dune build @check
  File "test.ml", line 1, characters 38-45:
  1 | let bad_anti_quote_payload = [%yojson [%y? _]]
                                            ^^^^^^^
  Error: ppx_yojson: bad antiquotation payload, should be a single expression
  [1]

We test it with the pattern extension as well

  $ cat >test.ml <<EOF
  > let [%yojson? [%y \`Int _a]] = invalid_anti_quotation_pattern
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 14-26:
  1 | let [%yojson? [%y `Int _a]] = invalid_anti_quotation_pattern
                    ^^^^^^^^^^^^
  Error: ppx_yojson: bad antiquotation payload, should be a pattern
  [1]

Integer literals should either fits within an ocaml int or be in decimal form.
That means that binary, octal and hexadecimal literals exceeding the 63 bit range
should trigger errors:

  $ cat >test.ml <<EOF
  > let invalid_hex_literal = [%yojson 0xffffffffffffffffffffff]
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 35-59:
  1 | let invalid_hex_literal = [%yojson 0xffffffffffffffffffffff]
                                         ^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: invalid interger literal. Integer literal should fit
         within an OCaml int or be written in decimal form.
  [1]

---------------------------------------

  $ cat >test.ml <<EOF
  > let [%yojson? 0xffffffffffffffffffffff] = invalid_hex_literal
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 14-38:
  1 | let [%yojson? 0xffffffffffffffffffffff] = invalid_hex_literal
                    ^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: unsupported payload
  [1]

---------------------------------------

  $ cat >test.ml <<EOF
  > let invalid_octal_literal = [%yojson 0o7777777777777777777777777777777777777777]
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 37-79:
  1 | let invalid_octal_literal = [%yojson 0o7777777777777777777777777777777777777777]
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: invalid interger literal. Integer literal should fit
         within an OCaml int or be written in decimal form.
  [1]

--------------------------------------

  $ cat >test.ml <<EOF
  > let [%yojson? 0o7777777777777777777777777777777777777777] = invalid_octal_literal
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 14-56:
  1 | let [%yojson? 0o7777777777777777777777777777777777777777] = invalid_octal_literal
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: unsupported payload
  [1]

--------------------------------------

  $ cat >test.ml <<EOF
  > let invalid_bin_literal = [%yojson 0b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111]
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 35-146:
  1 | let invalid_bin_literal = [%yojson 0b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111]
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: invalid interger literal. Integer literal should fit
         within an OCaml int or be written in decimal form.
  [1]

--------------------------------------

  $ cat >test.ml <<EOF
  > let [%yojson?
  > 0b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111] = invalid_bin_literal
  > EOF

  $ dune build @check
  File "test.ml", line 2, characters 0-111:
  2 | 0b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111] = invalid_bin_literal
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: unsupported payload
  [1]

--------------------------------------

Some OCaml values have no straightforward JSON translation, such as variants.
Trying to use these within a ppx_yojson payload should trigger an error.

  $ cat >test.ml <<EOF
  > let unsupported_payload = [%yojson Ok ()]
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 35-40:
  1 | let unsupported_payload = [%yojson Ok ()]
                                         ^^^^^
  Error: ppx_yojson: unsupported payload
  [1]

--------------------------------------

  $ cat >test.ml <<EOF
  > let [%yojson? Ok ()] = unsupported_payload
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 14-19:
  1 | let [%yojson? Ok ()] = unsupported_payload
                    ^^^^^
  Error: ppx_yojson: unsupported payload
  [1]

Qualified record fields are unsupported and should trigger errors.

  $ cat >test.ml <<EOF
  > let unsupported_record_field = [%yojson {A.field = 0}]
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 41-48:
  1 | let unsupported_record_field = [%yojson {A.field = 0}]
                                               ^^^^^^^
  Error: ppx_yojson: unsupported record field
  [1]

--------------------------------------

  $ cat >test.ml <<EOF
  > let [%yojson? {A.field = 0}] = unsupported_record_field
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 15-22:
  1 | let [%yojson? {A.field = 0}] = unsupported_record_field
                     ^^^^^^^
  Error: ppx_yojson: unsupported record field
  [1]

Record with more than 5 fields in the pattern extension should trigger an
error as they expand to big of an or-pattern.

  $ cat >test.ml <<EOF
  > let [%yojson? {a = 1; b = 2; c = 3; d = 4; e = 5}] = too_many_record_fields
  > EOF

  $ dune build @check
  File "test.ml", line 1, characters 14-49:
  1 | let [%yojson? {a = 1; b = 2; c = 3; d = 4; e = 5}] = too_many_record_fields
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: ppx_yojson: record patterns with more than 4 fields aren't supported.
         Consider using ppx_deriving_yojson to handle more complex json
         objects.
  [1]
