Missionaries and cannibals
==========================

Recall the man, wolf, goat, cabbage (MWGC) problem that was
demonstrated in lecture. For review, here is the solution that was
presented:

``` prolog
change(e,w).
change(w,e).

move([X,X,Goat,Cabbage],wolf,[Y,Y,Goat,Cabbage]) :-
    change(X,Y).
move([X,Wolf,X,Cabbage],goat,[Y,Wolf,Y,Cabbage]) :-
    change(X,Y).
move([X,Wolf,Goat,X],cabbage,[Y,Wolf,Goat,Y]) :-
    change(X,Y).
move([X,Wolf,Goat,C],nothing,[Y,Wolf,Goat,C]) :-
    change(X,Y).

oneEq(X,X,_).
oneEq(X,_,X).

safe([Man,Wolf,Goat,Cabbage]) :-
    oneEq(Man,Goat,Wolf),
    oneEq(Man,Goat,Cabbage).

solution([e,e,e,e],[]).
solution(Config,[Move|Rest]) :-
    move(Config,Move,NextConfig),
    safe(NextConfig),
    solution(NextConfig,Rest).

length(X,7), solution([w,w,w,w], X).
```

A similar problem is the missionaries and cannibals problem as
stated here:

> Suppose there are three missionaries and three cannibals who need to
> cross to the far side of a river using a single boat that can carry
> one or two people at a time. Both groups will cooperate and can
> paddle back and forth freely, but old habits will lead the cannibals
> to eat the missionaries if the missionaries are ever outnumbered on
> either side of the river.
>
> The problem is to find a way to get all of the missionaries and all
> of the cannibals safely across the river.

Write a prolog program to find suitable solutions.


Representing state
------------------

Represent the state of the world as a list with three elements. The
first is the number of missionaries on the near shore, the next is
the number of cannibals on the near shore, and the last is the
boat's current location, either “near” or “far”. For example:

*   [3,3,near] is the starting state
*   [0,0,far] is the goal state
*   [2,2,far] would be the result after a single move if one
    missionary and one cannibal both crossed to the other side.

To help with managing states, define `change` facts similar to those
in the MWGC problem, but switch between near and far. You may also
wish to define other helper facts/rules as you solve this problem.


Checking for valid states
-------------------------

Write a `valid/1` rule that succeeds if it is given a state that is
valid. To be valid, the boat must be in a valid location, and there
must be a valid number of missionaries and cannibals on each shore.
Note that being valid does not mean that a state is safe—a valid
state could lead to missionaries being eaten. Your rule should
ensure that only states that are possible are represented. In
particular, there should not be too many (more than three) or too
few (fewer than zero) missionaries or cannibals on either shore.


Checking for safe states
------------------------

Write a `safe/1` rule that succeeds if it is given a safe state. You
may assume that it is only given valid states, so `safe` must check
to ensure that no missionaries are in danger of being eaten. This
can be expressed fairly succinctly, but you may need to give this
problem some thought to figure out the simplest way to describe a
safe state.


Moves
-----

Write a `move/3` rule that succeeds when given a state, a move, and
another state, where the second state is the result that would be
obtained by moving some number of people. The possible moves are:

* `onemissionary`
* `twomissionaries`
* `onecannibal`
* `twocannibals`
* `oneofeach`

Where each describes the number and type of people that change sides
in a given move. Note that `move` should NOT check for validity or
safety—it merely ensures that the math is correct for a given move.
For example:

* `move([3,3,near],oneofeach,[2,2,far]).`
* `move([0,1,near],twocannibals,[0,-1,far]).`

Are correct instances of move. You should write only a single clause
for each of the five move types.


Finding the solution
--------------------

The rule to find the solution is similar to that in the MWGC
problem, but you must ensure validity and safety separately. Recall
that `solution/2` succeeds when given a state and a list of moves,
where following the list of moves in order from the initial state
leads to the goal state, and every state along the way is both valid
and safe.

The shortest complete solution to this problem is 11 moves long. If
you are working outside of CodeGrinder, I suggest defining a rule
like this one to make testing easier:

``` prolog
solve(X) :-
    length(X,11),
    solution([3,3,near],X).
```
