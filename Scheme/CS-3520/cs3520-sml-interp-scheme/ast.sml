local
    val reservedWords = [
        "define", "if", "while", "begin", "set", "lambda"
    ]
    val unaryBuiltIns = [
        "car", "cdr", "number?", "symbol?", "list?", "null?", "print"
    ]
    val binaryBuiltIns = [
        "+", "-", "*", "/", "=", "<", ">", "cons"
    ]
in
    fun isReservedWord s = List.exists (fn elt => s = elt) reservedWords
    fun isUnaryBuiltIn s = List.exists (fn elt => s = elt) unaryBuiltIns
    fun isBinaryBuiltIn s = List.exists (fn elt => s = elt) binaryBuiltIns
    fun isBuiltIn s = isUnaryBuiltIn s orelse isBinaryBuiltIn s
end

datatype value =
    NilSxp
  | NumSxp of int
  | SymSxp of string
  | ListSxp of value * value
  | UnaryPrimOp of string * (value -> value)
  | BinaryPrimOp of string * (value * value -> value)
  | Closure of (string list * expression) * ((string * value) list ref list)

and expression =
    ValExp of value
  | LambdaExp of string list * expression
  | VarExp of string
  | IfExp of expression * expression * expression
  | WhileExp of expression * expression
  | SetExp of string * expression
  | BeginExp of expression list
  | ApExp of expression * (expression list)

fun intToString n =
    if n < 0 then "-"^(Int.toString (~n)) else (Int.toString n)

fun listToString f lst =
    let fun g [] s      = s
          | g [x] s     = s ^ f x
          | g (x::xs) s = g xs (s ^ f x ^ ", ")
    in "[" ^ g lst "" ^ "]" end

fun valueToRepr NilSxp = "NilSxp"

  | valueToRepr (NumSxp n) = "NumSxp " ^ Int.toString n

  | valueToRepr (SymSxp s) = "SymSxp \"" ^ s ^ "\""

  | valueToRepr (ListSxp (car, cdr)) =
        "ListSxp (" ^ valueToRepr car ^ ", " ^ valueToRepr cdr ^ ")"

  | valueToRepr (UnaryPrimOp (name, _)) =
        "UnaryPrimOp (\"" ^ name ^ "\", <function>)"

  | valueToRepr (BinaryPrimOp (name, _)) =
        "BinaryPrimOp (\"" ^ name ^ "\", <function>)"

  | valueToRepr (Closure (_, _)) =
        "Closure (<lambda>, <environment>)"

fun valueToString NilSxp = "()"

  | valueToString (NumSxp n) = intToString n

  | valueToString (SymSxp s) = s

  | valueToString (lst as ListSxp pair) =
        let fun f prefix (ListSxp (car, cdr)) =
                    f ((if prefix = "" then "" else prefix^" ") ^ valueToString car) cdr
              | f prefix NilSxp = prefix
              | f _ _ = "MALFORMED LIST"
        in "(" ^ f "" lst ^ ")" end

  | valueToString (UnaryPrimOp (name, _)) = name

  | valueToString (BinaryPrimOp (name, _)) = name

  | valueToString (Closure (_, _)) = "<closure>"


fun expressionToRepr (ValExp v) = "ValExp (" ^ valueToString v ^ ")"

  | expressionToRepr (LambdaExp (formals, body)) =
        "LambdaExp (" ^
        "[" ^ foldr (fn (par, a) => if a = "" then par else par^", "^a) "" formals ^ "]" ^
        ", " ^ expressionToRepr body ^ ")"

  | expressionToRepr (VarExp s) = "VarExp \"" ^ s ^ "\""

  | expressionToRepr (IfExp (cond, thenPart, elsePart)) =
        "IfExp (" ^
        expressionToRepr cond ^ ", " ^
        expressionToRepr thenPart ^ ", " ^
        expressionToRepr elsePart ^ ")"

  | expressionToRepr (WhileExp (cond, body)) =
        "WhileExp (" ^
        expressionToRepr cond ^ ", " ^
        expressionToRepr body ^ ")"

  | expressionToRepr (SetExp (name, exp)) =
        "SetExp (\"" ^ name ^ "\", " ^
        expressionToRepr exp ^ ")"

  | expressionToRepr (BeginExp lst) =
        "Begin " ^ listToString expressionToRepr lst

  | expressionToRepr (ApExp (function, arguments)) =
        "ApExp (" ^ expressionToRepr function ^ ", " ^ listToString expressionToRepr arguments ^ ")"
