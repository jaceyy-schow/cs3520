:- consult(lists).

:- begin_tests(third).
test(third) :- third([1,2,3,4,5],3).
test(third) :- third([2,3,4,5],4).
test(third) :- third([a,b,c,d],c).
test(third) :- third([a,b,c],c).
test(third) :- third([a,b,c|d],c).
test(third, [fail]) :- third([1,2,3,4],2).
test(third, [fail]) :- third([1,2,3,4],4).
test(third, [fail]) :- third([a,b,c,d],b).
test(third, [fail]) :- third([a,b,c,d],d).
test(third, [fail]) :- third([a,b],a).
test(third, [fail]) :- third(notalist,a).
:- end_tests(third).

:- begin_tests(del3).
test(del3) :- del3([1,2,3,4],[1,2,4]).
test(del3) :- del3([1,2,3],[1,2]).
test(del3) :- del3([a,b,c,d],[a,b,d]).
test(del3) :- del3([a,b,c],[a,b]).
test(del3) :- del3([a,b,c|d],[a,b|d]).
test(del3, [fail]) :- del3([1,2,3,4],[1,3,4]).
test(del3, [fail]) :- del3([1,2,3,4],[1,2,3]).
test(del3, [fail]) :- del3([a,b,c,d],[a,c,d]).
test(del3, [fail]) :- del3([a,b,c,d],[a,b,c]).
test(del3, [fail]) :- del3([a,b],[a,b]).
test(del3, [fail]) :- del3([a,b,c|d],[a,b]).
test(del3, [fail]) :- del3(notalist,_).
:- end_tests(del3).

:- begin_tests(isDuped).
test(isDuped) :- isDuped([]).
test(isDuped) :- isDuped([1,1]).
test(isDuped) :- isDuped([1,_]).
test(isDuped) :- isDuped([_,_]).
test(isDuped) :- isDuped([a,a]).
test(isDuped) :- isDuped([a,a,b,b]).
test(isDuped) :- isDuped([a,a,b,b,c,c]).
test(isDuped) :- isDuped([a,a,b,b,c,c,1,1]).
test(isDuped, [fail]) :- isDuped([1]).
test(isDuped, [fail]) :- isDuped([1,2]).
test(isDuped, [fail]) :- isDuped([a]).
test(isDuped, [fail]) :- isDuped([_]).
test(isDuped, [fail]) :- isDuped([a,b]).
test(isDuped, [fail]) :- isDuped([a|a]).
test(isDuped, [fail]) :- isDuped([a,a,b,b,c,c,d]).
test(isDuped, [fail]) :- isDuped([a,a,b,b,c,c,d,e]).
:- end_tests(isDuped).

:- begin_tests(evenSize).
test(evenSize) :- evenSize([]).
test(evenSize) :- evenSize([1,1]).
test(evenSize) :- evenSize([a,a]).
test(evenSize) :- evenSize([a,b]).
test(evenSize) :- evenSize([1,2]).
test(evenSize) :- evenSize([a,b,c,d]).
test(evenSize) :- evenSize([1,2,3,4]).
test(evenSize) :- evenSize([a,a,a,a,a,a]).
test(evenSize) :- evenSize([b,a,d,c,a,b,q,r]).
test(evenSize) :- evenSize([9,8,7,6,5,4,3,2,1,a]).
test(evenSize, [fail]) :- evenSize([1]).
test(evenSize, [fail]) :- evenSize([_]).
test(evenSize, [fail]) :- evenSize([a,b,c]).
test(evenSize, [fail]) :- evenSize([a,b,c,d,e]).
test(evenSize, [fail]) :- evenSize([a,b,c,d,e,f,g]).
test(evenSize, [fail]) :- evenSize([a|b]).
test(evenSize, [fail]) :- evenSize(notalist).
:- end_tests(evenSize).
