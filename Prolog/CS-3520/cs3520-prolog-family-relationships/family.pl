/* Family tree data */
/* Do not modify */

parent(shmi,vader).
parent(ruweee,padme).
parent(jobal,padme).
parent(vader,luke).
parent(vader,leia).
parent(padme,luke).
parent(padme,leia).
parent(luke,ben).
parent(mara,ben).
parent(leia,jaina).
parent(leia,jacen).
parent(leia,anakin).
parent(han,jaina).
parent(han,jacen).
parent(han,anakin).

/* Write your code here */
male(ruweee).
male(vader).
male(luke).
male(han).
male(ben).
male(jacen).
male(anakin).
female(shmi).
female(jobal).
female(padme).
female(mara).
female(leia).
female(jaina).

mother(X, Y) :- female(X), parent(X, Y).
father(X, Y) :- male(X), parent(X, Y).
sibling(X, Y) :- parent(Z, Y), parent(Z, X), X \= Y.
sister(X, Y) :- female(X), sibling(X, Y).
firstCousin(X, Y) :- parent(A, X), parent(B, Y), sibling(A, B), X \= Y.
grandson(X, Y) :- male(X), parent(Z, X), parent(Y, Z).

descendent(X, Y) :- parent(Y, X).
descendent(X, Y) :- parent(Y, Z), descendent(X, Z).
