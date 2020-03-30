third([_, _, A | _], A).

del3([A, B, _ | C], [A, B | C]).

isDuped([]).
isDuped([X,X|Y]) :- isDuped(Y).

oddSize([_]).
oddSize([_|X]) :- evenSize(X).

evenSize([]).
evenSize([_|X]) :- oddSize(X).
