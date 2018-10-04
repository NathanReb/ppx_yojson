
# ppx_yojson

PPX extension for Yojson literals and patterns

[![Build Status](https://travis-ci.org/NathanReb/ppx_yojson.svg?branch=master)](https://travis-ci.org/NathanReb/ppx_yojson)

## Overview

`ppx_yojson` lets you write `Yojson` expressions and patterns using ocaml syntax to make your code
more concise and readable.

For example you can turn:
```ocaml
let json =
  `List
    [ `Assoc
        [ ("name", `String "Anne")
        ; ("grades", `List [`String "A"; `String "B-"; `String "B+"]
        ]
    ; `Assoc
        [ ("name", `String "Bernard")
        ; ("grades", `List [`String "B+"; `String "A"; `String "B-"]
        ]
    ]
```

into:
```ocaml
let json =
  [%yojson
    [ {name = "Anne"; grades = ["A"; "B-"; "B+"]}
    ; {name = "Anne"; grades = ["A"; "B-"; "B+"]}
    ]
  ]
```

### Expressions

The expression rewriter supports the following `Yojson` values:
- `Null`: `[%yojson None]`
- `Bool of bool`: `[%yojson true]`
- `Float of float`: `[%yojson 1.2e+10]`
- `Int of int`: `[%yojson 0xff]`. As long as the int literal in the payload fits in an `int`,
  the `0x`, `0o` and `0b` notations are accepted.
- `Intlit of string`: `[%yojson 100000000000000000000000000000000]`. For arbitrary long integers,
  `0x`, `0o` and `0b` notations are currently not supported and the rewriter will raise an error.
- `String of string`: `[%yojson "abc"]`
- `List of json list`: `[%yojson [1; 2; 3]]`. It supports mixed type list as well such as
  `["a"; 2]`.
- `Assoc of (string * json) list`: `[%yojson {a = 1; b = "b"}]`
- any valid combination of the above

The resulting expression are not constrained, meaning it works with `Yojson.Safe` or `Yojson.Basic`
regardless.

### Patterns

Currently unsupported, coming soon.
