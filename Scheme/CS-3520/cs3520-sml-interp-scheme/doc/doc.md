Interpreter for Scheme
======================

Extend the evaluator you wrote for lisp to work for scheme. The data
types for the abstract syntax tree are provided, as is a parser and
the code that drives the read-eval-print loop (REPL):

* `ast.sml`: data types for the abstract syntax tree
* `parse.sml`: the parser
* `scheme.sml`: the tokenizer and main read-eval-print loop
* `eval.sml`: you should write the evaluator here

The grammar for the language is provided here:

```
input           ->  expression
expression      ->  value
                 |  variable
                 |  ( if expression expression expression )
                 |  ( while expression expression )
                 |  ( set variable expression )
                 |  ( begin expression+ )
                 |  ( expression+ )
value           ->  integer | quoted-const | ( lambda arglist expression )
arglist         ->  ( variable* )
quoted-const    ->  'S-expression
S-expression    ->  integer | symbol | ( S-expression* )
symbol          ->  name
variable        ->  name
integer         ->  sequence of digits, possibly preceded by minus sign
name            ->  any sequence of characters not an integer, and not
                    containing a blank or any of the following characters:
                    ( ) ;.
```

A function cannot be one of the "keywords" define, if, while, begin,
or set, or any of the value-op's. Aside from this, names can use any
characters on the keyboard. Comments are introduced by the
character ';' and continue to the end of the line; this is why ';'
cannot occur within a name. A session is terminated by entering
"quit"; thus it is highly inadvisable to use this name for a
variable.


The details
-----------

There are a few changes from the lisp interpreter:

*   There is no longer a global list of functions, since functions
    are first-class values in scheme.

*   An environment is now a reference to a list of key/value pairs,
    which means that it is mutable. You can create a new environment
    using the provided `envNew` function, and you should use
    `envGet`, `envSet`, and `envContains` to manipulate an environment.

*   `rho` is now a list of environments. The head of the list is the
    local environment, and the last environment in the list is the
    global environment. This means that the global environment is no
    longer treated as a special case, except that `set` operations
    still create new values there for names that do not exist in any
    other environment.

*   Since environments are mutable, `eval` no longer returns an
    updated version of `rho`, instead returning only a value.

*   The grammar no longer treats primitive functions as a special
    case. Instead, these are instances of `UnaryPrimOp` and
    `BinaryPrimOp` that are predefined in the global environment,
    i.e., the global environment must start out with an entry for
    each of the following primitive operations, each either a
    `UnaryPrimOp` or a `BinaryPrimOp` instance:

    *   `+`, `-`, `*`, `/`, `<`, `>`, `=`, `cons`, `car`, `cdr`,
        `number?`, `symbol?`, `list?`, `null?`, `print`: same
        functionality as in lisp.

    *   `primop?`: returns the true value if its single argument is
        a primitive function, i.e, an instance of `UnaryPrimOp` or
        `BinaryPrimOp`.

    *   `closure?`: returns the true value if its single argument is
        a closure object, i.e., an instance of `Closure`.

    You should write functions for each of these primitive
    operations that match the type signatures expected by
    `UnaryPrimOp` and `BinaryPrimOp`, and then you should add
    an entry to the `globalEnv` environment for each one. In other
    words, primitive operations are just global variables that map
    to `UnaryPrimOp` and `BinaryPrimOp` instances.

*   Applicative expressions now have an expression for the operator
    field instead of a string. This must be evaluated before you can
    figure out if it is a user-defined function (a closure) or a
    primitive operation.

As before, `eval` always takes rho (a list of environments) and an
expression as its input, and always returns a value as its output
(or raises an error).  There are a few changes to be aware of:

*   A `LambdaExp` is an expression. When evaluated, it returns a
    `Closure`. The closure captures the lambda value (the code)
    and the context in which is was defined, i.e., the
    rho that is active when the lambda expression is
    evaluated.

*   rho now contains a list of environments, so when looking up a
    value (or setting one) you should start at the local environment
    (the head of the list), then follow the list of environments,
    getting or setting the first instance of the variable that you
    encounter. The global environment is no longer a special case,
    it is just the last entry in the linked list. If a variable does
    not already exist, a "set" operation should create it in the
    global environment.

*   To evaluate a primitive operation (remember that the
    `UnaryPrimOp` or `BinaryPrimOp` instance is the result of
    evaluating the operator expression), verify that the caller
    provided the expected number of arguments. Then evaluate them,
    and call the function with the evaluated arguments.

*   To evaluate a closure (the `Closure` instance is the result of
    evaluating the operator field), verify you have the correct number
    of arguments, evaluate them, create a new environment mapping
    formal parameters to arguments, and then evaluate the body of
    the lambda expression that the closure contains.

    Note: when you evaluate the body, the value of rho that you pass
    in should have the newly-created environment as its first entry,
    and the captured environment last as the remaining entries,
    i.e., the environment list that is embedded in the closure.

So a lambda expression is a kind of expression. When it is
evaluated, it produces a closure (a kind of value), which
captures the code and the environment that is present when the
lambda expression is evaluated, i.e., when the function is defined.
When a closure is invoked, the newly-created environment links to
this captured environment to resolve free variables (the ones not
defined as formal parameters in the lambda expression).
