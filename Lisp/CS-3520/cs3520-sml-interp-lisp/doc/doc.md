Interpreter for Lisp
====================

Extend the evaluator you wrote for the simple language to work for
lisp. The data types for the abstract syntax tree are provided, as
is a parser and the code that drives the read-eval-print loop
(REPL):

* `ast.sml`: data types for the abstract syntax tree
* `parse.sml`: the parser
* `lisp.sml`: the tokenizer and main read-eval-print loop
* `eval.sml`: you should write the evaluator here

The grammar for the language is provided here:

```
input           ->  expression | fundef
fundef          ->  ( define function arglist expression )
arglist         ->  ( variable* )
expression      ->  value
                 |  variable
                 |  ( if expression expression expression )
                 |  ( while expression expression )
                 |  ( set variable expression )
                 |  ( begin expression+ )
                 |  ( optr expression* )
optr            ->  function | value-op
value           ->  integer | quoted-const
value-op        ->  + | - | * | / | = | < | > | cons | car | cdr
                 |  number? | symbol? | list? | null? | print
quoted-const    ->  'S-expression
S-expression    ->  integer | symbol | ( S-expression* )
symbol          ->  name
function        ->  name
variable        ->  name
integer         ->  sequence of digits, possibly preceded by minus sign
name            ->  any sequence of characters not an integer, and not
                    containing a blank or any of the following characters:
                    ( ) ;.
```

A function cannot be one of the “keywords” define, if, while, begin,
or set, or any of the value-op's. Aside from this, names can use any
characters on the keyboard. Comments are introduced by the
character ';' and continue to the end of the line; this is why ';'
cannot occur within a name. A session is terminated by entering
“quit”; thus it is highly inadvisable to use this name for a
variable.


The details
-----------

The `eval` function accepts an expression (an instance of the
`expression` type) as input and returns an s-expression (an instance
of the `sxp` type). Below is a sketch of the major differences in
how each kind of expression should be evaluated compared to the
simple language:

*   `ValExp`: if the input is a value, simply return the value (the
    s-expression stored inside the `ValExp` instance).

*   `IfExp` and `WhileExp`: note that `NilSxp` is the only false
    value; everything else should be treated as true. `WhileExp`
    should return `NilSxp` when it returns.

*   `BinaryBuiltinExp` and `UnaryBuiltinExp` primitive operations:

    *   `+`, `-`, `*`, `/`:
        , `<`, and `>`: evaluate the arguments and
        make sure both results are `NumSxp` instances. Apply the
        appropriate operation on the numbers, wrap the result in a
        `NumSxp`, and return it.

    *   `<`, and `>`: evaluate the arguments and make sure both
        results are `NumSxp` instances. Apply the appropriate
        operation on the numbers, return `SymSxp "T"` for true or
        `NilSxp` for false.

    *   `=`: evaluate both arguments and compare the results. The
        results are equal if: (1) they are both numbers and they are
        the same number, (2) they are both symbols and they are the same
        symbol, or (3) they are both nil values. All other cases should
        return false (the `NilSxp` value). Return `SymSxp "T"` for true.

    *   `cons`: evaluate both arguments. If the second argument is
        anything other than a list or a nil value, signal an error.
        Otherwise, build a list value from them and return it.

    *   `car`, `cdr`: evaluate the arguments and insist that the
        result is a list.  Return the appropriate part.

    *   `number?`, `symbol?`, `list?`, and `null?`: evaluate the
        argument and return either true (the symbol `T`) or false
        (the `NilSxp` value) based on the type of the result.

    *   `print`: , evaluate the argument, convert the result to a
        string using the `sxpToString` function in `ast.sml`, and
        print it.  Return the value.

*   User-defined functions: same as before.
