(* do not change any of this *)
exception RuntimeError of string

local
    val globals: (string * int) list ref = ref []
    val functions: (string * (string list) * expression) list ref = ref []
in
    fun globalGet key =
        let fun f [] = NONE
              | f ((k,v)::tail) = if k = key then SOME v else f tail
        in f (!globals) end

    fun globalSet key value =
        let fun f [] = [(key, value)]
              | f ((k,v)::tail) = if k = key then (k,value)::tail else (k,v)::f tail
        in globals := f (!globals) end

    fun functionGet name =
        let fun f [] = NONE
              | f ((def as (k,_,_))::tail) = if k = name then SOME def else f tail
        in f (!functions) end

    fun functionSet (def as (name, _, _)) =
        let fun f [] = [def]
              | f ((elt as (k,_,_))::tail) = if k = name then def::tail else elt::f tail
        in functions := f (!functions) end

    fun rhoGet [] _ = NONE
      | rhoGet ((key, value)::tail) name =
            if key = name then SOME value else rhoGet tail name

    fun rhoSet [] key value = [(key, value)]
      | rhoSet ((elt as (k, v)) :: tail) key value =
            if key = k then (key, value) :: tail else elt :: rhoSet tail key value

    fun rhoContains rho name =
        case rhoGet rho name of SOME _ => true | NONE => false
end

fun nth(xs, i) =
  if i < 0 
  then raise Subscript
  else
    case xs of
      [] => raise Subscript
      | (x::xs') => if i=0 then x else nth(xs',i-1)


(* pattern matching testing *)
(* "=", "<", ">" *)
(* divide by zero exception? *)
(* your code goes here *)

fun eval (rho, exp) = 
    case exp of
      ValExp(i) => (rho, i)
    | VarExp(key) => 
        (case rhoGet rho key of
            SOME v => (rho, v)
            | NONE => ( case globalGet key of 
                SOME v => (rho,v)
                | NONE => raise (Fail "String Not Found ")
                      )
        ) 
    (* (if (> y 0) 5 10) *)
    (* IfExp (BinaryBuiltinExp (">", VarExp "y", ValExp 0), ValExp 5, ValExp 10) *)
    | IfExp(condition, exp1, exp2) =>
        ( case eval (rho, condition) of 
            (rho,0) => eval (rho,exp2)
            | (rho, _) => eval (rho, exp1)
            | _ => raise (Fail "ifExp condition not found")
        )
        (* (while (> y 0)
          (begin (set x (+ x x)) (set y (- y 1)))) *)
        (* WhileExp (BinaryBuiltinExp (">", VarExp "y", ValExp 0), Begin [SetExp ("x", BinaryBuiltinExp ("+", VarExp "x", VarExp "x")), SetExp ("y", BinaryBuiltinExp ("-", VarExp "y", ValExp 1))]) *)
    | WhileExp (condition, exp1) =>
        ( case eval (rho, condition) of 
            (rho,0) => (rho,0)
            |(rho,1) => (case eval (rho,exp1) of 
                (rho,b)=> eval (rho, WhileExp (condition, exp1))
                | _ => raise (Fail "WhileExp exp not found")
                        )
            | _ => raise (Fail "WhileExp condition not found")
        ) 

    | SetExp(key, exp1) =>
        (case eval (rho, exp1) of
            (rho,v)=> (case rhoContains rho key of
                true => ( (rhoSet rho key v), v ) (* not sure if correct *)
                | false => (globalSet key v; (rho,v))
                | _ => raise (Fail "SetExp value not found") 
                      )
            | _ => raise (Fail "SetExp Exp not found")
        )

    | BeginExp (xs) =>
    (case xs of
    [] => (rho, 0)
    | [var] => eval(rho, var)
    | var::vars => (let val (myVar, _) = eval(rho, var) in
        eval (myVar, BeginExp(vars)) end ) )
 

    | BinaryBuiltinExp(operator, val1, val2) =>
        (case eval (rho, val1) of 
            (rho,L) => (case eval (rho, val2) of
                (rho,R) => (case operator of
                    "+" => (rho, L + R) 
                    | "-" => (rho, L - R)
                    | "*" => (rho, L * R) 
                    | "/" => (rho, L div R)
                    | "=" => if L = R then (rho,1) else (rho,0)
                    | ">" => if L > R then (rho,1) else (rho,0)
                    | "<" => if L < R then (rho,1) else (rho,0)
                    | _ => raise (Fail "BinaryBuiltInExp Operator not found")
                           )
                         | _ => raise (Fail "BinaryBuiltInExp Right not found")
                        )
        | _ => raise (Fail "BinaryBuiltInExp Left not found")
        )

    | UnaryBuiltinExp(str, exp) =>
        (case eval (rho, exp) of
            (rho,v) => (case str of 
                "print" => let 
                        val toPrint = v
                        in
                        (print ((Int.toString v) ^ "\n" ));
                        eval (rho,exp)
                        end
                | _ => raise Fail ("UnarayExp String not found")
                        ) 
        )
    (* ApExp ("setx", [VarExp "x", ValExp 1]) *)
    | ApExp( s, args ) =>
        ( case functionGet s of
         SOME ( fs, fel, exp ) =>
          ( if ( ( length args ) = ( length fel ) )
              then let fun envGen( newRho, x::xs, y::ys ) =
                            let val ( _, myInt ) = eval( rho, y ) in
                                envGen( ( rhoSet newRho x myInt ), xs, ys )
                            end
                            | envGen( newRho, _, _ ) = newRho in
                                let val newRho =
                                    envGen( [], fel, args ) in
                                    (let val (_, result) = eval (newRho, exp) in
                                    (rho,result)
                                    end)
                                end
                    end
              else raise RuntimeError( "Number of parameters do not match required." ) )
        | NONE => raise RuntimeError( "Undefined function: " ^ s ) )
  | _  => raise Fail ("could not pattern match")