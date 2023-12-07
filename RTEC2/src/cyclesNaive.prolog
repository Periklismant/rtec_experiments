%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Naive Implementation of cyclic fluent computation.
%% holdsAt predicates are always computed by means of Event Calculus rules.
holdsAtCyclicNaive(F=V, T):-
	%write('In naive holdsAtCyclic'), nl,
	%write(F=V), nl,
	%write(T), nl,
	initTime(InitTime),
	initPointBetweenNaive(F=V, InitTime, InitPoint, T),
	nextTimePoint(InitPoint, NextPoint),
	notBrokenOrReInitiatedNaive(F=V, NextPoint, T).
	%write('Rule matched!'), nl.
	
%holdsAtCyclicNaive(Index, status(Index)=null, 0).

initPointBetweenNaive(F=V, Ts, Ts, Te):-
	Ts<Te, initiallyCyclic(F=V), !.
%initPointBetweenNaive(_Index, F=V, Ts, Ts, Te):-
%	Ts<Te, initiatedAt(F=V, -1, -1, 0), !.

initPointBetweenNaive(F=V, Ts, T, Te) :-
	%write('In naive init between'), nl,
	nextTimePoint(Ts, NextTs),
	initiatedAt(F=V, NextTs, T, Te).

notBrokenOrReInitiatedNaive(_, Ts, Te) :- Ts>=Te, !.
notBrokenOrReInitiatedNaive(F=V, Ts, Te) :-
	%write('In naive not broken between'), nl,
	brokenOnceNaive(F=V, Ts, T, Te), !,	
	nextTimePoint(T, NextT),
	startedBetweenNaive(F=V, NextT, Init, Te),
	notBrokenOrReInitiatedNaive(F=V, Init, Te).
notBrokenOrReInitiatedNaive(_, _, _).	

% we are looking in the interval [Ts,Te)
brokenOnceNaive(F=V1, Ts, T, Te) :-
	%write('In naive broken once'), nl,
	simpleFluent(F=V2), \+V2=V1,
	startedBetweenNaive(F=V2, Ts, T, Te), !.
brokenOnceNaive(F=V, Ts, T, Te) :-
	%write('In naive broken once'), nl,
	terminatedAt(F=V, Ts, T, Te), !.

% we are looking in the interval [Ts,Te)
startedBetweenNaive( _, Ts, _, Te) :- Ts>=Te, !, false.
startedBetweenNaive(F=V, Ts, T, Te) :-
	%write('In naive startedbetween'), nl,	
	initiatedAt(F=V, Ts, T, Te).

%%%%% Naive cyclic treatment END %%%%%