
(rule
  (targets integer_literal.actual)
  (deps (:pp pp.exe) (:input integer_literal.ml))
  (action
    (with-stderr-to
      %{targets}
      (bash "./%{pp} -no-color --impl %{input} || true")
    )
  )
)

(alias
  (name runtest)
  (action (diff integer_literal.expected integer_literal.actual))
)
