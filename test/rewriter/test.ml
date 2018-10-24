open Yojson.Safe

let null : json = [%yojson None]
let true_ : json = [%yojson true]
let false_ : json = [%yojson false]
let string : json = [%yojson "a"]
let int : json = [%yojson 1]
let int_lit : json = [%yojson 4611686018427387904]
let float : json = [%yojson 1.2e+10]
let empty_array : json = [%yojson []]
let array : json = [%yojson [1; 2; 3]]
let mixed_array : json = [%yojson [true; 1; "a"]]
let record : json = [%yojson {a = true; b = 1; c = "a"}]
let complex : json =
  [%yojson
    { description = "Some written thing"
    ; authors =
        [ {name = "Kurt Cobain"; age = 27}
        ; {name = "Jesus Christ"; age = 33}
        ]
    }
  ]

let patterns : json -> unit = function [@warning "-11"]
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
  | [%yojson? _s] as _var -> ()
  | [%yojson? _] as _any -> ()
