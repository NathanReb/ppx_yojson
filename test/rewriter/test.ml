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
