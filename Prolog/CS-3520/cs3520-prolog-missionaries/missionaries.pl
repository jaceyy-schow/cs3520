change( near, far ).
change( far, near ).

valid( [ M, C, X ] ) :-
M >= 0, C >= 0, M =< 3, C =< 3.

safe( [ M, C, _ ] ) :-
M = 0; M = 3; M = C.


move( [ M, C, X ], onemissionary, [ M2, C, Y ] ) :-
    X = near, change( X, Y ), M2 is M - 1;
    X = far, change( X, Y ), M2 is M + 1.
move( [ M, C, X ], onecannibal, [ M, C2, Y ] ) :-
    X = near, change( X, Y ), C2 is C - 1;
    X = far, change( X, Y ), C2 is C + 1.
move( [ M, C, X ], twomissionaries, [ M2, C, Y ] ) :-
    X = near, change( X, Y ), M2 is M - 2;
    X = far, change( X, Y ), M2 is M + 2.
move( [ M, C, X ], twocannibals, [ M, C2, Y ] ) :-
    X = near, change( X, Y ), C2 is C - 2;
    X = far, change( X, Y ), C2 is C + 2.
move( [ M, C, X ], oneofeach, [ M2, C2, Y ] ) :-
    X = near, change( X, Y ), M2 is M - 1, C2 is C - 1;
    X = far, change( X, Y ), M2 is M + 1, C2 is C + 1.


solution( [ 0, 0, far ], [ ] ).

solution( Config, [ Moves | Finish ] ) :-
move( Config, Moves, CheckNext ),
valid( CheckNext ),
safe( CheckNext ),
solution( CheckNext, Finish ).