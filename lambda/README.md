K PL Tutorial
=============

This work is based on the [K PL Tutorial][kplt]. It does not use their
Makefiles etc. because those are heavily include-based, and here we
want to make it more clear exactly what commands we're running and why.

Language 1: Lambda
------------------

### Lesson 1

Building:
- The tutorial's test Makefiles Use `kompile --gen-glr-bison-parser` for
  this. Don't know why a GLR parser is preferred over LALR(1) for these
  grammars, but the tutorial READMEs don't specify this, so we don't
  either.
- Wants clang for LLVM compilation; for the moment just go with `--backend
  kore`. Not sure what that produces, but it builds.
- However, `krun` fails with `Backend kore not supported.` Ok, need to
  switch to a container with all the appropriate stuff installed for
  LLVM to work.

Initial Syntax:
- `module … endmodule` for module definitions
  - ??? Any diff between a "syntax" and "semantics" module? Looks like via
    the imports they all just get combined into one, anyway.
  - `foo.k` needs `mdoule FOO` or `kompile --main-module` option for
    another name.
  - Seem to be certain assumptions around names, e.g. for `--main-module
    FOO`, defaults to `--syntax-module FOO-SYNTAX`.
- Syntax Defnitions:
  - `syntax … ::= … [| …]` to create BNF-like syntax rules.
  - `imports DOMAINS-SYNTAX` seems to be minimum required to get it to
    build at all, lest bison fail with "start symbol top does not derive
    any sentence," which makes sense.
  - `"` around terminals
  - `|` to add additional rules to a non-terminal production only
- Syntax atttributes in `[ … ]` at end of line:
  - `[left]`: left associative: `a b c` parses as `(a b) c`
  - `[bracket]`: do not generate nodes in AST for parens (so we don't need
    to explicitly ignore them).
- Prelude: `include/kframework/builtin/domains.md` (literate K)
  - Offers `DOMAINS-SYNTAX` and `DOMAINS` modules, with some types that are
    occasionally helpful: bool, int, string, list, etc. Some further ones
    (`FLOAT`, `ARRAY`, etc.) are separate.
  - Domains syntax: `SORT-K`, `ID-SYNTAX`, `UNSIGNED-INT-SYNTAX`,
    `BOOL-SYNTAX`, `STRING-SYNTAX`.
  - Domains: `INT`, `BOOL`, `STRING`, `BASIC-K`, `LIST`, `K-IO`, `MAP`,
    `SET`, `ID`, `K-EQUAL`.

Identity program:
- Tutorial `identity.lambda` is my `id.l`, same contents: `lambda x . x`.
- `krun` produces different output:
  - Tutorial: `<k> lambda x . x </k>`
  - Mine: `<k> lambda x . x ~> .K </k>`
  - The `<k>…</k>` is an automatically-created configuration of one cell
    because definition did not supply a configuration.
- `kast` prints the AST; ugly as hell:
    ```
    `lambda_.__LAMBDA-SYNTAX_Val_Id_Exp`(#token("x","Id"),#token("x","Id"))
    ```

Issues with changes I want:
- Tried `"λ" Id "." Exp`, which kompiles ok, but krun complains
  `1:0:1:0:syntax error: unexpected Î`.
- Changing it to `"L" Id "." Exp` gives:
  `id.l:1:4:1:4:syntax error, unexpected ., expecting end of file`
- Even changing it to "lambd" breaks as "L" above.
- Also did clean build just to make sure.
- Defining as `"Lambda"` and making it parse `lambda` dumps core.
- ??? What is so special about `"lambda"`?
- Apparently my clean build wasn't clean enough; `rm -rf lambda-kompiled`
  a second time fixed it all, including UTF-8.

Comments:
- I need comments in my programs, so I need to add them to the parser.
- Not clear how to do this; [[so 62665093]] says "declare built-in sort
  `#Layout` to be the concatenation via pipes of a set of regular
  expression terminals (i.e., `r"//[^\\n]*"`). Any tokens which lex as one
  of these tokens are simply discarded by the lexer and the parser does not
  even see them."
- Have an example in my code, but fails due to double definition of
  `#Lambda` sort; bug in K?


<!-------------------------------------------------------------------->
[kplt]: https://github.com/runtimeverification/pl-tutorial/tree/master/1_k
[so 62665093]: https://stackoverflow.com/a/62665093/107294
