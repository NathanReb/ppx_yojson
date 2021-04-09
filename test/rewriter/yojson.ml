type json = Yojson.Safe.t

let null = [%yojson None]
let true_ = [%yojson true]
let false_ = [%yojson false]
let string = [%yojson "a"]
let int = [%yojson 1]
let int_lit = [%yojson 4611686018427387904]
let float = [%yojson 1.2e+10]
let empty_array = [%yojson []]
let array = [%yojson [1; 2; 3]]
let mixed_array = [%yojson [true; 1; "a"]]
let record = [%yojson {a = true; b = 1; c = "a"}]
let complex =
  [%yojson
    { description = "Some written thing"
    ; authors =
        [ {name = "Kurt Cobain"; age = 27}
        ; {name = "Jesus Christ"; age = 33}
        ]
    }
  ]
let anti_quotation = [%yojson {a = [%y `String "a"]; b = 1}]
let int_64 = [%yojson 1L]
let int_32 = [%yojson 1l]
let native_int = [%yojson 1n]

let patterns = function [@warning "-11"]
  | [%yojson? None] as _null -> ()
  | [%yojson? true] as _true -> ()
  | [%yojson? false] as _false -> ()
  | [%yojson? "a"] as _string -> ()
  | [%yojson? 1] as _int -> ()
  | [%yojson? 4611686018427387904] as _int_lit -> ()
  | [%yojson? 1.2e+10] as _float -> ()
  | [%yojson? 1 | 2] as _or_pattern -> ()
  | [%yojson? 1 as _s] as _alias -> ()
  | [%yojson? [1; 2; 3]] as _array -> ()
  | [%yojson? [true; 1; "a"]] as _mixed_array -> ()
  | [%yojson? {a = true; b = 1; c = "a"}] as _object -> ()
  | [%yojson?
      { description = "Some written thing"
      ; authors =
          [ {name = _kurt; age = 27}
          ; {name = "Jesus Christ"; age = _}
          ]
      }
    ] as _complex
    ->
    ()
  | [%yojson? 1L] as _int_64 -> ()
  | [%yojson? 1l] as _int_32 -> ()
  | [%yojson? 1n] as _native_int -> ()
  | [%yojson? _s] as _var -> ()
  | [%yojson? { a = [%y? `Int _i]}] as _var -> ()
  | [%yojson? _] as _any -> ()
