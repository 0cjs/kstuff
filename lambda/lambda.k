//  Based on various `lambda.k` files from under:
//  https://github.com/runtimeverification/pl-tutorial/tree/master/1_k/1_lambda

module LAMBDA-SYNTAX
    imports DOMAINS-SYNTAX

    //  If no sort `#Layout` is declared (which is the usual situation),
    //  the compiler will automatically import module DEFAULT-LAYOUT from
    //  kast.md, which gives C-style single- and multi-line comments, and
    //  otherwises uses whitespace to separate tokens. Defining your own
    //  gives you none of that, so you also need add whitespace token
    //  separation to it.
  //syntax #Layout ::= r"(;[^\\n\\r]*)"     // `;` to EOL is comment
  //                 | r"([\\ \\n\\r\\t])"  // Treat whitespace as token sep.

    // Unfortunately, the above fails due to a bug, it appears. So for the
    // moment we just use C-style comments in our target language.

    syntax Val ::= Id
                 | "λ" Id "." Exp
    syntax Exp ::= Val
                 | Exp Exp          [left]
                 | "(" Exp ")"      [bracket]
endmodule

module LAMBDA
    imports LAMBDA-SYNTAX
endmodule
