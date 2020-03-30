exception RuntimeError of string

local
    val globals: (string * sxp) list ref = ref []
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

(* your code goes here *)

fun sxp_add (NumSxp left, NumSxp right) = NumSxp (left + right)
  | sxp_add _ = raise RuntimeError ("parameter error");

fun sxp_subtract (NumSxp left, NumSxp right) = NumSxp (left - right)
  | sxp_subtract _ = raise RuntimeError ("parameter error"); 

fun sxp_divide (NumSxp left, NumSxp right) = NumSxp (left div right)
  | sxp_divide _ = raise RuntimeError ("parameter error");

fun sxp_multiply (NumSxp left, NumSxp right) = NumSxp (left * right)
  | sxp_multiply _ = raise RuntimeError ("parameter error");      

fun sxp_greater (NumSxp left, NumSxp right) = if left > right then SymSxp "T" else NilSxp

fun sxp_less (NumSxp left, NumSxp right) = if left < right then SymSxp "T" else NilSxp 

fun sxp_equal (left , right) = case left of 
              l => case right of 
                          r => if l = r then SymSxp "T" else NilSxp

fun sxp_car (l) = case l of 
                ListSxp(sxp1 , sxp2 ) => sxp1
                | _ => raise RuntimeError ("list is empty error"); 

fun sxp_cdr (l) = case l of 
                ListSxp(sxp1 , sxp2 ) => sxp2
                | _ => raise RuntimeError ("list is empty error"); 
  


 fun sxp_number (l) = case l of 
                NumSxp(num) => SymSxp "T" 
                | _ => NilSxp

 fun sxp_symbol (l) = case l of 
                SymSxp(num) => SymSxp "T" 
                | _ => NilSxp

 fun sxp_list (l) = case l of 
                ListSxp(num) => SymSxp "T" 
                | _ => NilSxp

fun sxp_null (l) = case l of 
                NilSxp => SymSxp "T" 
                | _ => NilSxp



fun eval (rho, exp) =
  case exp of
  ValExp(i)=> (rho,i)
  | VarExp(key) => 
      (case rhoGet rho key of
          SOME v => (rho, v)
          | NONE => ( case globalGet key of 
              SOME v => (rho,v)
              | NONE => raise (Fail "String Not Found ")
                    )
      )

  | IfExp(condition, exp1, exp2) =>
      ( case eval (rho, condition) of 
          (rho,NilSxp) => eval (rho,exp2)
          | (rho, _) => eval (rho, exp1)
          | _ => raise (Fail "ifExp condition not found")
      )
  | WhileExp (condition, exp1) =>
     (case eval ( rho, condition ) of 
        (rho, NilSxp) => (rho, NilSxp)
     | (rho, _) => (let val (newRho, _) = eval (rho, exp1) in
                    eval (newRho, WhileExp(condition, exp1))
                    end))
  | SetExp(key, exp1) =>
      (case eval (rho, exp1) of
          (rho,v)=> (case rhoContains rho key of
              true => ( (rhoSet rho key v), v )
              | false => (globalSet key v; (rho,v))
              | _ => raise (Fail "SetExp value not found") 
                    )
          | _ => raise (Fail "SetExp Exp not found")
      )

  | BeginExp (xs) =>
    (case xs of
    [] => (rho, NilSxp)
    | [var] => eval(rho, var)
    | var::vars => (let val (myVar, _) = eval(rho, var) in
        eval (myVar, BeginExp(vars)) end ) )
 

  | BinaryBuiltinExp(operator, val1, val2) =>
      (case eval (rho, val1) of 
          (rho,L) => (case eval (rho, val2) of
              (rho,R) => (case operator of
                  "+" => (rho, sxp_add(L , R))
                  | "-" => (rho, sxp_subtract (L , R))
                  | "*" => (rho, sxp_multiply (L , R)) 
                  | "/" => (rho, sxp_divide (L , R))
                  | ">" => (rho, sxp_greater(L , R))
                  | "<" => (rho, sxp_less(L , R))
                  | "cons" => (rho, ListSxp (L , R) )
                  | "=" => (rho, sxp_equal(L , R))
                         )
                       | _ => raise (Fail "BinaryBuiltInExp Right not found")
                      )
      | _ => raise (Fail "BinaryBuiltInExp Left not found")
      )
  | UnaryBuiltinExp(str, exp) =>
    (case eval (rho, exp) of
        (rho, v) => (case str of 
            "car" => (rho, sxp_car(v))
            |"cdr" => (rho, sxp_cdr(v))
            |"number?" => (rho, sxp_number(v))
            |"symbol?" => (rho, sxp_symbol(v))
            |"list?" => (rho, sxp_list(v))
            |"null?" => (rho, sxp_null(v))
            |"print" => (print(sxpToString(v)^"\n"); (rho, v))
                    )
            | _ => raise (Fail "Unary Built in List not found")
     )

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