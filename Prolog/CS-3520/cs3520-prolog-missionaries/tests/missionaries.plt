:- consult(missionaries).

:- begin_tests(change).
test(change) :- change(near,far).
test(change) :- change(far,near).
test(change, [fail]) :- change(near,near).
test(change, [fail]) :- change(far,far).
:- end_tests(change).

:- begin_tests(valid).
test(valid) :- valid([0,0,near]).
test(valid) :- valid([0,0,far]).
test(valid) :- valid([1,1,near]).
test(valid) :- valid([1,1,far]).
test(valid) :- valid([2,2,near]).
test(valid) :- valid([2,2,far]).
test(valid) :- valid([3,3,near]).
test(valid) :- valid([3,3,far]).
test(valid) :- valid([0,1,_]).
test(valid) :- valid([1,2,_]).
test(valid) :- valid([2,3,_]).
test(valid) :- valid([3,1,_]).
test(valid, [fail]) :- valid([-1,0,_]).
test(valid, [fail]) :- valid([0,-1,_]).
test(valid, [fail]) :- valid([4,0,_]).
test(valid, [fail]) :- valid([0,4,_]).
test(valid, [fail]) :- valid([1,2]).
test(valid, [fail]) :- valid([1,2,_,_|_]).
:- end_tests(valid).

:- begin_tests(safe).
test(safe) :- safe([0,0,_]).
test(safe) :- safe([0,1,_]).
test(safe) :- safe([0,2,_]).
test(safe) :- safe([0,3,_]).
test(safe) :- safe([3,0,_]).
test(safe) :- safe([3,1,_]).
test(safe) :- safe([3,2,_]).
test(safe) :- safe([3,3,_]).
test(safe) :- safe([1,1,_]).
test(safe) :- safe([2,2,_]).
test(safe, [fail]) :- safe([1,0,_]).
test(safe, [fail]) :- safe([1,2,_]).
test(safe, [fail]) :- safe([1,3,_]).
test(safe, [fail]) :- safe([2,0,_]).
test(safe, [fail]) :- safe([2,1,_]).
test(safe, [fail]) :- safe([2,3,_]).
:- end_tests(safe).

:- begin_tests(move).
test(move) :- move([3,C,near],onemissionary,[2,C,far]).
test(move) :- move([2,C,near],onemissionary,[1,C,far]).
test(move) :- move([1,C,near],onemissionary,[0,C,far]).
test(move) :- move([2,C,far],onemissionary,[3,C,near]).
test(move) :- move([1,C,far],onemissionary,[2,C,near]).
test(move) :- move([0,C,far],onemissionary,[1,C,near]).
test(move) :- move([3,C,near],twomissionaries,[1,C,far]).
test(move) :- move([2,C,near],twomissionaries,[0,C,far]).
test(move) :- move([1,C,far],twomissionaries,[3,C,near]).
test(move) :- move([0,C,far],twomissionaries,[2,C,near]).
test(move) :- move([M,3,near],onecannibal,[M,2,far]).
test(move) :- move([M,2,near],onecannibal,[M,1,far]).
test(move) :- move([M,1,near],onecannibal,[M,0,far]).
test(move) :- move([M,2,far],onecannibal,[M,3,near]).
test(move) :- move([M,1,far],onecannibal,[M,2,near]).
test(move) :- move([M,0,far],onecannibal,[M,1,near]).
test(move) :- move([M,3,near],twocannibals,[M,1,far]).
test(move) :- move([M,2,near],twocannibals,[M,0,far]).
test(move) :- move([M,1,far],twocannibals,[M,3,near]).
test(move) :- move([M,0,far],twocannibals,[M,2,near]).
test(move) :- move([3,2,near],oneofeach,[2,1,far]).
test(move) :- move([1,2,near],oneofeach,[0,1,far]).
test(move) :- move([1,3,near],oneofeach,[0,2,far]).
test(move) :- move([0,2,far],oneofeach,[1,3,near]).
test(move) :- move([1,2,far],oneofeach,[2,3,near]).
test(move) :- move([1,1,far],oneofeach,[2,2,near]).
test(move, [fail]) :- move([_,_,S],onemissionary,[_,_,S]).
test(move, [fail]) :- move([_,_,S],twomissionaries,[_,_,S]).
test(move, [fail]) :- move([_,_,S],onecannibal,[_,_,S]).
test(move, [fail]) :- move([_,_,S],twocannibals,[_,_,S]).
test(move, [fail]) :- move([_,_,S],oneofeach,[_,_,S]).
test(move, [fail]) :- move([2,_,near],onemissionary,[3,_,far]).
test(move, [fail]) :- move([_,2,near],onemissionary,[_,1,far]).
test(move, [fail]) :- move([_,2,near],onemissionary,[_,3,far]).
test(move, [fail]) :- move([3,_,far],twomissionaries,[1,_,near]).
test(move, [fail]) :- move([3,_,near],twomissionaries,[2,_,far]).
test(move, [fail]) :- move([_,2,near],onecannibal,[_,3,far]).
test(move, [fail]) :- move([2,_,near],onecannibal,[1,_,far]).
test(move, [fail]) :- move([2,_,near],onecannibal,[3,_,far]).
test(move, [fail]) :- move([_,3,far],twocannibals,[_,1,near]).
test(move, [fail]) :- move([_,3,near],twocannibals,[_,2,far]).
test(move, [fail]) :- move([3,1,_],oneofeach,[3,2,_]).
test(move, [fail]) :- move([3,1,_],oneofeach,[2,1,_]).
test(move, [fail]) :- move([2,2,_],oneofeach,[1,3,_]).
test(move, [fail]) :- move([2,2,_],oneofeach,[3,1,_]).
:- end_tests(move).

:- begin_tests(solution).
test(solution) :- solution([0,0,far], []).
test(solution) :- solution([0,1,near], [onecannibal]).
test(solution) :- solution([1,1,near], [oneofeach]).
test(solution) :- solution([2,2,near], [twomissionaries, onecannibal, twocannibals, onemissionary, oneofeach]).
test(solution) :- solution([2,2,near], [twomissionaries, onecannibal, twocannibals, onecannibal, twocannibals]).
test(solution) :- solution([3,3,near], [_,_,_,_,_,_,_,_,_,_,_]).
test(solution) :- solution([3,1,far], [onecannibal, twocannibals, onecannibal, twomissionaries, oneofeach, twomissionaries, onecannibal, twocannibals, onemissionary, oneofeach]).
test(solution, [fail]) :- solution([3,3,near], [_,_,_,_,_,_,_,_,_]).
test(solution, [fail]) :- solution([3,3,near], [_,_,_,_,_,_,_,_,_,_,_,_]).
test(solution, [fail]) :- solution([2,2,near], [twomissionaries, onecannibal, onecannibal, _, _]).
test(solution, [fail]) :- solution([2,2,near], [twomissionaries, onecannibal, twocannibals, _]).
:- end_tests(solution).
