# ppx_yojson

PPX extension for Yojson literals and patterns

Based on an original idea by [@emillon](https://github.com/emillon).

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
    ; {name = "Bernard"; grades = ["B+"; "A"; "B-"]}
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
- Any valid combination of the above

The resulting expression are not constrained, meaning it works with `Yojson.Safe` or `Yojson.Basic`
regardless.

### Patterns

Note that the pattern extension expects a pattern payload and must thus be invoked as
`[%yojson? pattern]`.

The pattern rewriter supports the following:
- `Null`, `Bool of bool`, `Float of float`, `Int of int`, `Intlit of string`, `String of string`,
  `List of json list` with the same syntax as for expressions and will be
  rewritten to a pattern matching that json value.
- `Assoc of (string * json) list` with the same syntax as for expressions but with a few
  restrictions. The record pattern in the payload must be closed (ie no `; _}`) and have less than
  4 fields. See details below.
- Var patterns: they are just rewritten as var patterns meaning they will bind to a
  `Yojson.Safe.json` or whatever `Yojson` type you're using that's compatible with the above.
- The wildcard pattern: it gets rewritten as, well, a wildcard pattern
- Any valid combination of the above

#### Record patterns

Json objects fields order doesn't matter so you'd expect the `{a = 1; b = true}` pattern to match
regardless of the parsed json being `{"a": 1, "b": true}` or `{"b": true, "a": 1}`.

Since json objects are represented as lists, the order of the fields in the rewritten pattern does
matter.

To allow you to write such patterns concisely and without having to care for the order of the
fields, the record pattern is expanded to an or-pattern that matches every permutation of the
`(string * json) list`. This is the reason of the limitations mentioned in the above list.
Also note that there is no limitation on nesting such patterns but you probably want to avoid doing
that too much.

This is provided mostly for convenience. If you want efficient code and/or to handle complex json
objects I recommend that you use `ppx_deriving_yojson` instead.

To clarify, the following code:
```ocaml
let f = function
  | [%yojson? {a = 1; b = true}] -> (1, true)
```

is expanded into:
```ocaml
let f = function
  | ( `Assoc [("a", `Int 1); ("b", `Bool true)]
    | `Assoc [("b", `Bool true); ("a", `Int 1)]
    ) -> (1, true)
```
