(lang dune 2.7)

(generate_opam_files true)

(name ppx_yojson)

(source
 (github NathanReb/ppx_yojson))

(license BSD-2-Clause)

(authors "Nathan Rebours <nathan.p.rebours@gmail.com>")

(maintainers "Nathan Rebours <nathan.p.rebours@gmail.com>")

(package
 (name ppx_yojson)
 (synopsis "PPX extension for Yojson literals and patterns")
 (depends
  (ocaml (>= 4.08))
  (alcotest :with-test)
  (ppxlib
   (>= 0.18.0))
  (ezjsonm :with-test)
  (yojson
   (and
    :with-test
    (>= 1.6.0)))))
