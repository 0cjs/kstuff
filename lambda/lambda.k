//  Based on various `lambda.k` files from under:
//  https://github.com/runtimeverification/pl-tutorial/tree/master/1_k/1_lambda

module LAMBDA-SYNTAX
    imports DOMAINS-SYNTAX

    syntax Val ::= Id
                 | "lambda" Id "." Exp
    syntax Exp ::= Val
                 | Exp Exp          [left]
                 | "(" Exp ")"      [bracket]

endmodule

module LAMBDA
    imports LAMBDA-SYNTAX
endmodule
