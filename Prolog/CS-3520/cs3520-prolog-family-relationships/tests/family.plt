:- consult(family).

:- begin_tests(female).
test(female) :- female(shmi).
test(female) :- female(jobal).
test(female) :- female(padme).
test(female) :- female(mara).
test(female) :- female(leia).
test(female) :- female(jaina).
test(female, [fail]) :- female(ruweee).
test(female, [fail]) :- female(vader).
test(female, [fail]) :- female(luke).
test(female, [fail]) :- female(han).
test(female, [fail]) :- female(ben).
test(female, [fail]) :- female(jacen).
test(female, [fail]) :- female(anakin).
:- end_tests(female).

:- begin_tests(male).
test(male, [fail]) :- male(shmi).
test(male, [fail]) :- male(jobal).
test(male, [fail]) :- male(padme).
test(male, [fail]) :- male(mara).
test(male, [fail]) :- male(leia).
test(male, [fail]) :- male(jaina).
test(male) :- male(ruweee).
test(male) :- male(vader).
test(male) :- male(luke).
test(male) :- male(han).
test(male) :- male(ben).
test(male) :- male(jacen).
test(male) :- male(anakin).
:- end_tests(male).

:- begin_tests(mother).
test(mother) :- mother(jobal,padme).
test(mother) :- mother(padme,luke).
test(mother) :- mother(padme,leia).
test(mother) :- mother(mara,ben).
test(mother) :- mother(shmi,vader).
test(mother) :- mother(leia,jaina).
test(mother) :- mother(leia,jacen).
test(mother) :- mother(leia,anakin).
test(mother, [fail]) :- mother(ruweee,_).
test(mother, [fail]) :- mother(vader,_).
test(mother, [fail]) :- mother(luke,_).
test(mother, [fail]) :- mother(han,_).
test(mother, [fail]) :- mother(ben,_).
test(mother, [fail]) :- mother(jacen,_).
test(mother, [fail]) :- mother(anakin,_).
test(mother, [fail]) :- mother(jaina,_).
test(mother, [fail]) :- mother(padme,jobal).
test(mother, [fail]) :- mother(leia,padme).
test(mother, [fail]) :- mother(jaina,leia).
test(mother, [fail]) :- mother(shmi,padme).
test(mother, [fail]) :- mother(shmi,luke).
test(mother, [fail]) :- mother(shmi,han).
:- end_tests(mother).

:- begin_tests(father).
test(father) :- father(ruweee,padme).
test(father) :- father(vader,luke).
test(father) :- father(vader,leia).
test(father) :- father(luke,ben).
test(father) :- father(han,jaina).
test(father) :- father(han,jacen).
test(father) :- father(han,anakin).
test(father, [fail]) :- father(shmi,_).
test(father, [fail]) :- father(jobal,_).
test(father, [fail]) :- father(padme,_).
test(father, [fail]) :- father(mara,_).
test(father, [fail]) :- father(leia,_).
test(father, [fail]) :- father(jaina,_).
test(father, [fail]) :- father(anakin,_).
test(father, [fail]) :- father(jacen,_).
test(father, [fail]) :- father(ben,_).
test(father, [fail]) :- father(han,ben).
test(father, [fail]) :- father(han,leia).
test(father, [fail]) :- father(han,luke).
test(father, [fail]) :- father(luke,anakin).
test(father, [fail]) :- father(luke,vader).
test(father, [fail]) :- father(luke,shmi).
:- end_tests(father).

:- begin_tests(sister).
test(sister) :- sister(leia,luke).
test(sister) :- sister(jaina,jacen).
test(sister) :- sister(jaina,anakin).
test(sister, [fail]) :- sister(leia,leia).
test(sister, [fail]) :- sister(jaina,jaina).
test(sister, [fail]) :- sister(padme,padme).
test(sister, [fail]) :- sister(shmi,_).
test(sister, [fail]) :- sister(ruweee,_).
test(sister, [fail]) :- sister(jobal,_).
test(sister, [fail]) :- sister(anakin,_).
test(sister, [fail]) :- sister(padme,_).
test(sister, [fail]) :- sister(luke,_).
test(sister, [fail]) :- sister(han,_).
test(sister, [fail]) :- sister(jacen,_).
test(sister, [fail]) :- sister(ben,_).
:- end_tests(sister).

:- begin_tests(grandson).
test(grandson) :- grandson(luke,shmi).
test(grandson) :- grandson(luke,ruweee).
test(grandson) :- grandson(luke,jobal).
test(grandson) :- grandson(ben,vader).
test(grandson) :- grandson(ben,padme).
test(grandson) :- grandson(jacen,vader).
test(grandson) :- grandson(jacen,padme).
test(grandson) :- grandson(anakin,vader).
test(grandson) :- grandson(anakin,padme).
test(grandson, [fail]) :- grandson(mara,_).
test(grandson, [fail]) :- grandson(jaina,_).
test(grandson, [fail]) :- grandson(leia,_).
test(grandson, [fail]) :- grandson(han,_).
test(grandson, [fail]) :- grandson(padme,_).
test(grandson, [fail]) :- grandson(vader,_).
test(grandson, [fail]) :- grandson(shmi,_).
test(grandson, [fail]) :- grandson(ruweee,_).
test(grandson, [fail]) :- grandson(jobal,_).
test(grandson, [fail]) :- grandson(luke,ben).
test(grandson, [fail]) :- grandson(luke,padme).
test(grandson, [fail]) :- grandson(luke,vader).
test(grandson, [fail]) :- grandson(luke,han).
test(grandson, [fail]) :- grandson(luke,leia).
test(grandson, [fail]) :- grandson(luke,luke).
test(grandson, [fail]) :- grandson(luke,mara).
:- end_tests(grandson).

:- begin_tests(firstCousin).
test(firstCousin) :- firstCousin(ben,jaina).
test(firstCousin) :- firstCousin(jaina,ben).
test(firstCousin) :- firstCousin(ben,jacen).
test(firstCousin) :- firstCousin(jacen,ben).
test(firstCousin) :- firstCousin(ben,anakin).
test(firstCousin) :- firstCousin(anakin,ben).
test(firstCousin, [fail]) :- firstCousin(shmi,_).
test(firstCousin, [fail]) :- firstCousin(ruweee,_).
test(firstCousin, [fail]) :- firstCousin(jobal,_).
test(firstCousin, [fail]) :- firstCousin(vader,_).
test(firstCousin, [fail]) :- firstCousin(padme,_).
test(firstCousin, [fail]) :- firstCousin(mara,_).
test(firstCousin, [fail]) :- firstCousin(luke,_).
test(firstCousin, [fail]) :- firstCousin(leia,_).
test(firstCousin, [fail]) :- firstCousin(han,_).
test(firstCousin, [fail]) :- firstCousin(ben,ben).
test(firstCousin, [fail]) :- firstCousin(ben,luke).
test(firstCousin, [fail]) :- firstCousin(ben,mara).
test(firstCousin, [fail]) :- firstCousin(ben,leia).
test(firstCousin, [fail]) :- firstCousin(ben,han).
test(firstCousin, [fail]) :- firstCousin(ben,vader).
test(firstCousin, [fail]) :- firstCousin(ben,padme).
test(firstCousin, [fail]) :- firstCousin(ben,padme).
test(firstCousin, [fail]) :- firstCousin(ben,shmi).
test(firstCousin, [fail]) :- firstCousin(ben,ruweee).
:- end_tests(firstCousin).

:- begin_tests(descendent).
test(descendent) :- descendent(vader,shmi).
test(descendent) :- descendent(luke,shmi).
test(descendent) :- descendent(leia,shmi).
test(descendent) :- descendent(ben,shmi).
test(descendent) :- descendent(jaina,shmi).
test(descendent) :- descendent(jacen,shmi).
test(descendent) :- descendent(anakin,shmi).
test(descendent) :- descendent(luke,vader).
test(descendent) :- descendent(leia,vader).
test(descendent) :- descendent(ben,vader).
test(descendent) :- descendent(jaina,vader).
test(descendent) :- descendent(jacen,vader).
test(descendent) :- descendent(anakin,vader).
test(descendent) :- descendent(leia,vader).
test(descendent) :- descendent(leia,padme).
test(descendent) :- descendent(leia,ruweee).
test(descendent) :- descendent(leia,jobal).
test(descendent, [fail]) :- descendent(shmi,_).
test(descendent, [fail]) :- descendent(padme,shmi).
test(descendent, [fail]) :- descendent(leia,han).
test(descendent, [fail]) :- descendent(luke,mara).
test(descendent, [fail]) :- descendent(luke,luke).
test(descendent, [fail]) :- descendent(luke,ben).
test(descendent, [fail]) :- descendent(ruweee,_).
test(descendent, [fail]) :- descendent(jobal,_).
test(descendent, [fail]) :- descendent(_,ben).
test(descendent, [fail]) :- descendent(_,jaina).
test(descendent, [fail]) :- descendent(_,jacen).
test(descendent, [fail]) :- descendent(_,anakin).
:- end_tests(descendent).
