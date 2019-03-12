## Tests

`ppx_yojson` uses two layers of tests. Adding tests along with your contribution is definitely
encouraged and appreciated!

### Unit tests

You can find unit tests for simple library functions in `test/lib`. They are written using OUnit.
There is one test file per tested library module and the entire test suite is defined and run in
`test_ppx_yojson_lib.ml`.

We should try testing stuff there as much as possible, especially small helper functions that don't
produce chunks of AST.

Each function has its own test suite under `test_<function_name>` and they are all grouped together
under a `suite` value at the test module's top level.

We try to mimic the module structure of the project in the tests. That means that if you want to add
tests for a function from a submodule B from a module A, it should sit under a `Test_a.B` module
which should have its own `suite`.

### Rewriter tests

These are the main tests for `ppx_yojson`. We use them to ensure the generated code is what we
expect it to be.

They are run by comparing the output of `ppx_yojson` as a standalone binary against `.expected`
files, both for successful and unsuccessful rewriting.

The successful cases are tested in `test/rewriter/test.ml`. You can update it with new test cases and
then run `dune runtest`. It will show the diff with the generated code for your new case, if you're
happy with the result you can update the expected results by running `dune promote`.

We also test rewriting errors to make sure they are properly triggered and located. There's one file
per error case tested in `test/rewriter/errors`. If you want to add a test case there you should:
1. run `touch test/rewriter/errors/expr_<test_case_name>.{ml,expected}` to add the new empty test
   cases. Use `expr_` or `pat_` as a prefix depending on which of the two extensions they correspond
   to.
2. run `dune runtest --auto-promote` to update the dune file with the rules for your new test case.
3. update the `.ml` file with the erronous use of `ppx_yojson`, you can use one of the other test
   cases as an example. If your error is already produced correctly, merlin should highlight it in
   your code.
4. run `dune runtest` to see what the error is.
5. if you're happy with the result, run `dune promote` to update the `.expected` file.
