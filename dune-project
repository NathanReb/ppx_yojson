(lang dune 1.10)

(generate_opam_files true)

(name ppx_yojson)
(source (github NathanReb/ppx_yojson))
(license BSD-2)
(authors "Nathan Rebours <nathan.p.rebours@gmail.com>")
(maintainers "Nathan Rebours <nathan.p.rebours@gmail.com>")

(package
 (name ppx_yojson)
 (synopsis "PPX extension for Yojson literals and patterns")
 (depends
  (dune (>= 1.10))
  (ocaml (>= 4.04.2))
  (ounit (and :with-test (>= 2.0.0)))
  (ppxlib (>= 0.3.0))
  (ppx_deriving :with-test)
  (yojson (and :with-test (>= 1.6.0)))))
