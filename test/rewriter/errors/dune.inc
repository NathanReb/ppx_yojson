
(library
  (name expr_anti_quotation_payload)
  (modules expr_anti_quotation_payload)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_anti_quotation_payload.actual)
  (deps (:pp bin/pp.exe) (:input expr_anti_quotation_payload.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_anti_quotation_payload.expected expr_anti_quotation_payload.actual)))

(library
  (name expr_integer_literal_binary)
  (modules expr_integer_literal_binary)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_integer_literal_binary.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_binary.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_binary.expected expr_integer_literal_binary.actual)))

(library
  (name expr_integer_literal_hex)
  (modules expr_integer_literal_hex)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_integer_literal_hex.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_hex.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_hex.expected expr_integer_literal_hex.actual)))

(library
  (name expr_integer_literal_octal)
  (modules expr_integer_literal_octal)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_integer_literal_octal.actual)
  (deps (:pp bin/pp.exe) (:input expr_integer_literal_octal.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_integer_literal_octal.expected expr_integer_literal_octal.actual)))

(library
  (name expr_unsupported_payload)
  (modules expr_unsupported_payload)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_unsupported_payload.actual)
  (deps (:pp bin/pp.exe) (:input expr_unsupported_payload.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_unsupported_payload.expected expr_unsupported_payload.actual)))

(library
  (name expr_unsupported_record_field)
  (modules expr_unsupported_record_field)
  (preprocess (pps ppx_yojson)))

(rule
  (targets expr_unsupported_record_field.actual)
  (deps (:pp bin/pp.exe) (:input expr_unsupported_record_field.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff expr_unsupported_record_field.expected expr_unsupported_record_field.actual)))

(library
  (name pat_anti_quotation_payload)
  (modules pat_anti_quotation_payload)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_anti_quotation_payload.actual)
  (deps (:pp bin/pp.exe) (:input pat_anti_quotation_payload.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_anti_quotation_payload.expected pat_anti_quotation_payload.actual)))

(library
  (name pat_integer_literal_binary)
  (modules pat_integer_literal_binary)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_integer_literal_binary.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_binary.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_binary.expected pat_integer_literal_binary.actual)))

(library
  (name pat_integer_literal_hex)
  (modules pat_integer_literal_hex)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_integer_literal_hex.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_hex.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_hex.expected pat_integer_literal_hex.actual)))

(library
  (name pat_integer_literal_octal)
  (modules pat_integer_literal_octal)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_integer_literal_octal.actual)
  (deps (:pp bin/pp.exe) (:input pat_integer_literal_octal.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_integer_literal_octal.expected pat_integer_literal_octal.actual)))

(library
  (name pat_too_many_record_field)
  (modules pat_too_many_record_field)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_too_many_record_field.actual)
  (deps (:pp bin/pp.exe) (:input pat_too_many_record_field.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_too_many_record_field.expected pat_too_many_record_field.actual)))

(library
  (name pat_unsupported_payload)
  (modules pat_unsupported_payload)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_unsupported_payload.actual)
  (deps (:pp bin/pp.exe) (:input pat_unsupported_payload.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_unsupported_payload.expected pat_unsupported_payload.actual)))

(library
  (name pat_unsupported_record_field)
  (modules pat_unsupported_record_field)
  (preprocess (pps ppx_yojson)))

(rule
  (targets pat_unsupported_record_field.actual)
  (deps (:pp bin/pp.exe) (:input pat_unsupported_record_field.ml))
  (action
    (setenv "OCAML_ERROR_STYLE" "short"
      (setenv "OCAML_COLOR" "never"
        (with-stderr-to
          %{targets}
          (bash "./%{pp} -no-color --impl %{input} || true"))))))

(rule
  (alias runtest)
  (action (diff pat_unsupported_record_field.expected pat_unsupported_record_field.actual)))
