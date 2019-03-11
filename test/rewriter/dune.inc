
(rule
  (targets test_error_integer_literal.actual)
  (deps (:pp pp.exe) (:input test_error_integer_literal.ml))
  (action
    (with-stderr-to
      %{targets}
      (bash "./%{pp} -no-color --impl %{input} || true")
    )
  )
)

(alias
  (name runtest)
  (action (diff test_error_integer_literal.expected test_error_integer_literal.actual))
)
