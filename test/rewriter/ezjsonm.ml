[@@@warning "-32"]

type json = Ezjsonm.value

let null = [%ezjsonm None]
let true_ = [%ezjsonm true]
let false_ = [%ezjsonm false]
let string = [%ezjsonm "a"]
let int = [%ezjsonm 1]
let float = [%ezjsonm 1.2e+10]
let empty_array = [%ezjsonm []]
let array = [%ezjsonm [1; 2; 3]]
let mixed_array = [%ezjsonm [true; 1; "a"]]
let record = [%ezjsonm {a = true; b = 1; c = "a"}]
let complex =
  [%ezjsonm
    { description = "Some written thing"
    ; authors =
        [ {name = "Kurt Cobain"; age = 27}
        ; {name = "Jesus Christ"; age = 33}
        ]
    }
  ]
let anti_quotation = [%ezjsonm {a = [%y `String "a"]; b = 1}]
