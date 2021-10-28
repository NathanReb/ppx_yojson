
(rule
  (targets expr_anti_quotation_payload.actual)
  (deps (:pp bin/pp.exe) (:input expr_anti_quotation_payload.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_anti_quotation_payload.expected expr_anti_quotation_payload.actual)))

(rule
  (targets expr_integer_literal_binary.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_binary.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_binary.expected expr_integer_literal_binary.actual)))

(rule
  (targets expr_integer_literal_hex.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_hex.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_hex.expected expr_integer_literal_hex.actual)))

(rule
  (targets expr_integer_literal_octal.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_octal.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_octal.expected expr_integer_literal_octal.actual)))

(rule
  (targets expr_unsupported_payload.actual)
  (deps (:pp bin/pp.exe) (:input expr_unsupported_payload.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_unsupported_payload.expected expr_unsupported_payload.actual)))

(rule
  (targets expr_unsupported_record_field.actual)
  (deps (:pp bin/pp.exe) (:input expr_unsupported_record_field.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff expr_unsupported_record_field.expected expr_unsupported_record_field.actual)))

(rule
  (targets pat_anti_quotation_payload.actual)
  (deps (:pp bin/pp.exe) (:input pat_anti_quotation_payload.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_anti_quotation_payload.expected pat_anti_quotation_payload.actual)))

(rule
  (targets pat_integer_literal_binary.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_binary.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_binary.expected pat_integer_literal_binary.actual)))

(rule
  (targets pat_integer_literal_hex.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_hex.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_hex.expected pat_integer_literal_hex.actual)))

(rule
  (targets pat_integer_literal_octal.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_octal.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_octal.expected pat_integer_literal_octal.actual)))

(rule
  (targets pat_too_many_record_field.actual)
  (deps (:pp bin/pp.exe) (:input pat_too_many_record_field.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_too_many_record_field.expected pat_too_many_record_field.actual)))

(rule
  (targets pat_unsupported_payload.actual)
  (deps (:pp bin/pp.exe) (:input pat_unsupported_payload.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_unsupported_payload.expected pat_unsupported_payload.actual)))

(rule
  (targets pat_unsupported_record_field.actual)
  (deps (:pp bin/pp.exe) (:input pat_unsupported_record_field.ml))
  (action
    (with-accepted-exit-codes 1
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (run ./%{pp} -no-color --impl %{input}))))))

(rule
  (alias runtest)
  (action (diff pat_unsupported_record_field.expected pat_unsupported_record_field.actual)))
