exception RuntimeError of string

(* note: you should populate globalEnv with all of the primitive operations *)
(* but you should never reference it directly anywhere else *)
val globalEnv: (string * value) list ref = ref []

(* get an entry from a single environement *)
fun envGet env name =
    let fun f [] = NONE
          | f ((key, value) :: tail) =
                if key = name
                    then SOME value
                    else f tail
    in f (!env) end

(* update/create an entry in a single environement *)
fun envSet env key value =
    let fun f [] = [(key, value)]
          | f ((elt as (k, v)) :: tail) =
                if key = k
                    then (key, value) :: tail
                    else elt :: f tail
    in env := f (!env) end

(* check if a single environement contains a key *)
fun envContains env name =
    case envGet env name of SOME _ => true | NONE => false

(* create a new, empty environement *)
fun envNew () = ref []

(* your code goes here *)
(* note: in addition to implementing eval, you must also implement all *)
(* of the primitive operations and add them to the global environment *)
(* as UnaryPrimOp and BinaryPrimOp values *)
fun eval( rho, ValExp( exp ) ) = ( exp )

    | eval( rho, VarExp( str ) ) =
        ( case rho of
            x::[ ] => ( case envGet x str of SOME var => var
                | NONE => raise RuntimeError( "Variable Not Found" ) )
            | x::xs => ( case envGet x str of SOME var => var 
                | NONE => eval( xs, VarExp( str ) ) ) )

    | eval( rho::rhos, SetExp( str, exp ) ) = 
        ( case eval( rho::rhos, exp ) of
            ( str1 ) => let fun callAgain( environment::[ ] ) = 
                ( envSet environment str str1; str1 )
                | callAgain( environment::environments ) =
                    ( case envContains environment str of
                       true => ( envSet environment str str1; str1 ) 
                    | false => ( callAgain( environments ) ) )
                    | callAgain _ = raise RuntimeError( "Variable Not Set" )
            in
                callAgain( rho::rhos )
            end )

    | eval( rho, IfExp( condition, thens, elses ) ) =
        ( let val exp1 = eval( rho, condition ) in 
            ( case exp1 of 
                NilSxp => eval( rho, elses )
                | _ => eval( rho, thens ) ) end )

    | eval( rho, WhileExp( cond1, cond2 ) ) = 
        ( case eval( rho, cond1 ) of 
          ( NilSxp ) => ( NilSxp )
        | ( _ ) => eval( rho, WhileExp( cond1, cond2 ) ) )


    | eval ( rho, BeginExp([ x ] ) ) = eval( rho, x )
        | eval ( rho, BeginExp( x::xs ) ) =
            ( case eval ( rho, x ) of
            ( _ ) => eval ( rho, BeginExp( xs ) ) )

    | eval( rho, LambdaExp( exp ) ) = Closure( exp, rho )

    | eval( rho, ApExp( str, exp ) ) =
     let val value = eval( rho, str ) in 
      ( case value of 
        UnaryPrimOp( name, expr ) => 
        ( case exp of [ parameter ] => 
            let val val1 = eval( rho, parameter ) in 
                expr( val1 ) 
            end 
        )

      | BinaryPrimOp( str, ex ) => 
        ( case exp of 
          [ left, right ] => let val val1 = eval( rho, left ) in 
                let val val2 = eval( rho, right ) in
                    ex( val1, val2 )
                end
            end
        )

      | ( Closure( ( params, body ), closeYourRho ) ) => 
      let val newEnvironment = envNew( )
        in if length exp = 0
          then eval( newEnvironment::closeYourRho, body ) 
          else ( case map( fn a => ( case eval( rho, a ) of 
            ( v ) => v ) ) exp of 
            ( vals ) => let fun iterate( [ x ], [ y ] ) = envSet newEnvironment x y 
              | iterate( x::xs, y::ys ) = ( envSet newEnvironment x y; iterate( xs, ys ) ) 
              | iterate( [ ], [ ] ) = raise RuntimeError( "Invalid expression for iteration" ) 
            in ( iterate( params, vals ); eval( newEnvironment::closeYourRho, body ) )
            end )
        end

        )

    end

    local

    fun prim_add( NumSxp( left ), NumSxp( right ) ) = NumSxp( left + right )

    fun prim_sub( NumSxp( left ), NumSxp( right ) ) = NumSxp( left - right )

    fun prim_mult( NumSxp( left ), NumSxp( right ) ) = NumSxp( left * right )

    fun prim_div( NumSxp( left ), NumSxp( right ) ) = NumSxp( left div right )

    fun prim_less( NumSxp( left ), NumSxp( right ) ) = if ( left < right ) then SymSxp( "T" ) else NilSxp

    fun prim_great( NumSxp( left ), NumSxp( right ) ) = if ( left > right ) then SymSxp( "T" ) else NilSxp

    fun prim_equal( NumSxp( left ), NumSxp( right ) ) = if ( left = right ) then SymSxp( "T" ) else NilSxp
        | prim_equal (SymSxp left, SymSxp right) = (if (left = right) then SymSxp("T") else NilSxp)
        | prim_equal (NilSxp, NilSxp) = SymSxp("T")
        | prim_equal _ = NilSxp
 

    fun prim_cons( left, right ) = ListSxp( left, right )

    fun prim_car( ListSxp( left, right ) ) = left

    fun prim_cdr( ListSxp( left, right ) ) = right

    fun prim_number( NumSxp( _ ) ) = 
        SymSxp( "T" )
        | prim_number( _ ) = NilSxp
        

    fun prim_symbol( var ) = 
        ( case var of 
            SymSxp( var ) => SymSxp( "T" )
            | _ => NilSxp )

    fun prim_list( var ) =
        ( case var of 
            ListSxp( var ) => SymSxp( "T" )
            | _ => NilSxp )

    fun prim_null( var ) = 
        ( case var  of 
            NilSxp => SymSxp( "T" )
            | _ => NilSxp )

    fun prim_print( var ) = 
        ( case var of 
            variable => ( print( valueToString variable ^ "\n" ); variable ) )

    fun prim_primop( param ) = if isBuiltIn ( valueToString param ) then SymSxp( "T" ) else NilSxp 
      | prim_primop( _ ) = NilSxp

    fun prim_close( Closure( _ ) ) = SymSxp( "T" ) 
        | prim_close( _ ) = NilSxp 


    in 

    val globalEnv = ref 

        [
            ( "+", BinaryPrimOp( "+", prim_add ) ),

            ( "-", BinaryPrimOp("-", prim_sub ) ),

            ( "*", BinaryPrimOp( "*", prim_mult ) ),

            ( "/", BinaryPrimOp( "/", prim_div ) ),

            ( "<", BinaryPrimOp( "<", prim_less ) ),

            ( ">", BinaryPrimOp( ">", prim_great ) ),

            ( "=", BinaryPrimOp( "=", prim_equal ) ),

            ( "cons", BinaryPrimOp( "cons", prim_cons ) ),

            ( "print", UnaryPrimOp( "print", prim_print ) ),

            ( "car", UnaryPrimOp( "car", prim_car ) ),

            ( "cdr", UnaryPrimOp( "cdr",  prim_cdr ) ),

            ( "null?", UnaryPrimOp( "null?", prim_null ) ),

            ( "number?", UnaryPrimOp( "number?", prim_number ) ),

            ( "symbol?", UnaryPrimOp( "symbol?", prim_symbol ) ),

            ( "list?", UnaryPrimOp( "list?",  prim_list ) ),

            ( "primop?", UnaryPrimOp( "primop?", prim_primop ) ),

            ( "closure?", UnaryPrimOp( "closure?", prim_close ) )

        ]
    end