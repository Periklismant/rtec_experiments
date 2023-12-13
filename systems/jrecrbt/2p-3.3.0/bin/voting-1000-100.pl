test(MVIs):-
	holds_at(status(mstatus(M),null),T).

terminates(propose(_,M),status(mstatus(M), null),T).

initiates(second(_,M),status(mstatus(M), voting),T):-
	holds_at(status(mstatus(M),proposed),T).

terminates(second(_,M),status(mstatus(M), proposed),T).

initiates(close_ballot(_,M),status(mstatus(M), voted),T):-
	holds_at(status(mstatus(M),voting),T).

terminates(close_ballot(_,M),status(mstatus(M), voting),T).

initiates(declare(_,M,_),status(mstatus(M), null),T):-
	holds_at(status(mstatus(M),voted),T).

terminates(declare(_,M,_),status(mstatus(M), voted),T).

initiates(declare(_,M,Outcome),status(outcome(M), Outcome),T):-
	holds_at(status(mstatus(M),voted),T).

terminates(propose(_,M),status(outcome(M),_),T).

initiates(declare(_,M,_),powPropose(M),T):-
	holds_at(status(mstatus(M),voted),T).

terminates(propose(_,M),powPropose(M),T).

initiates(propose(_,M),powSecond(M),T):-
	holds_at(status(mstatus(M),null),T).

terminates(second(_,M),powSecond(M),T).

initiates(second(_,M),powVote(M),T):-
	holds_at(status(mstatus(M),proposed),T).

terminates(close_ballot(_,M),powVote(M),T).

initiates(second(_,M),powCloseBallot(M),T):-
	holds_at(status(mstatus(M),proposed),T).

terminates(close_ballot(_,M),powCloseBallot(M),T).

initiates(close_ballot(_,M),powDeclare(M),T):-
	holds_at(status(mstatus(M),voting),T).

terminates(declare(_,M,_),powDeclare(M),T).

initially(status(mstatus(1), null)).
initially(status(mstatus(2), null)).
initially(status(mstatus(3), null)).
initially(status(mstatus(4), null)).
initially(status(mstatus(5), null)).
initially(status(mstatus(6), null)).
initially(status(mstatus(7), null)).
initially(status(mstatus(8), null)).
initially(status(mstatus(9), null)).
initially(status(mstatus(10), null)).
initially(powPropose(1)).
initially(powPropose(2)).
initially(powPropose(3)).
initially(powPropose(4)).
initially(powPropose(5)).
initially(powPropose(6)).
initially(powPropose(7)).
initially(powPropose(8)).
initially(powPropose(9)).
initially(powPropose(10)).:-unknown(_,fail).

lt(A,B):-gt(B,A).
le(A,B):-ge(B,A).

gt(inf,B):- B\==inf,!.
gt(_,inf):-!,fail.
gt(A,B):- A>B.

ge(A,A):-!.
ge(A,B):-gt(A,B).

holds_at(F, T):-
	holds_from(F, T, _).

holds_from(F, T, T1):-
	mholds_for(F, [T1, T2]),
	gt(T, T1),
	le(T, T2).

initiates(startf, F, T):-
	initially(F).

declip(F,T):-
	happens(E,T),
	initiates(E, F, T),
	\+ holds_at(F, T).

clip(F,T):-
	happens(E,T),
	terminates(E, F, T),
	holds_at(F, T).


start:-
	write("ENGINE STARTED"),nl,
	set_classpath([""]),
	java_object("TermRBTMap", [], kbMap),
	java_object("TermRBTMap", [], mviMap),
	register(kbMap),
	register(mviMap),
	update([happens(startf,-1)]).

update(ExtTrace):-
	%write("UPDATING EVENTS"),nl,
	java_object("TermRBTMap", [], traceMap),
	%register(traceMap),
	events_to_map(traceMap, ExtTrace),
	traceMap <- futureTrace(-2) returns Trace,
	text_term(Trace,T), nl,
	%unregister(traceMap),
	update_events(T).

events_to_map(M,[]).
events_to_map(M,[H|T]):-
	H = happens(_,T0),
	M <- putValue(T0,H),
	events_to_map(M,T).
	
mvis_to_map(M,[]).
mvis_to_map(M,[H|T]):-
	H = mholds_for(F,[Ts,Te]),
	M <- putValue(Ts,H),
	mvis_to_map(M,T).

update_events([]).
update_events([H|T]):-
	update_events(H),
	update_events(T).

%avoid event duplication
update_events([happens(E,T)|Events]):-
	happens(E,T),!,
	update_events([Events]).

update_events([happens(E,T)|Events]):-
	\+ happens(E,T),
	kbMap <- futureTrace(T) returns FTrace,
	text_term(FTrace,FT), nl,
	roll_back(T,FT),
	calculate_effects([[happens(E,T)|Events]|FT]).

roll_back(T,FT):-
	remove_events(FT),
	remove_future_MVIs(T),
	open_current_MVIs(T).


% bisogna ritrarre soltanto eventi che si sono già asseriti, altrimenti questa clausola fallisce
% inoltre H deve essere un singolo evento, non una lista di eventi, infatti nella vecchia rec.pl
% future_trace ritorna una lista di tutti gli eventi che accadono dopo un certo timepoint,
% non una lista di liste
remove_events([]).
remove_events([H|T]):-
	remove_events(H),
	remove_events(T).

remove_events([H|Trace]):-
	retract(H),
	remove_events(Trace).

future_MVI(mholds_for(F,[Ts,Te]),Tref):-
	mholds_for(F,[Ts,Te]),
	gt(Ts,Tref).

%swap this with an indexer call
remove_future_MVIs(T):-
        %remove from the indexer all mvis which start past T 
	my_setof(MVI,future_MVI(MVI,T),MVIs),
	remove_MVIs(MVIs).

remove_MVIs([]).
remove_MVIs([MVI|MVIs]):-
	retract(MVI),
	remove_MVIs(MVIs).

current_MVI(mholds_for(F,[Ts,Te]),Tref):-
	mholds_for(F,[Ts,Te]),
	gt(Tref,Ts),
	le(Tref,Te).

%swap this with an indexer call
open_current_MVIs(T):-
        %open all the mvis in the indexer that are holding at T
	my_setof(MVI,current_MVI(MVI,T),MVIs),
	open_MVIs(MVIs).

open_MVIs([]).
open_MVIs([mholds_for(F,[Ts,Te])|MVIs]):-
	retract(mholds_for(F,[Ts,Te])),
	assert(mholds_for(F,[Ts,inf])),
	open_MVIs(MVIs).



calculate_effects([]).
calculate_effects([H|T]):-
	calculate_effects_events(H),
	calculate_effects(T).

calculate_effects_events([happens(E,T)|Events]):-
	assert_all([happens(E,T)|Events]),
	events_to_map(kbMap,[happens(E,T)|Events]),
	%keep this setof
	my_setof(F, clip(F,T),S),
	close_mvis(S,T),
	%keep this setof
	my_setof(F, declip(F,T),S2),
	open_mvis(S2,T).

my_setof(A,B,C):-
	setof(A,B,C),!.
my_setof(_,_,[]).

close_mvis([],_).
close_mvis([F|Fs],T):-
	close_mvi(F,T),
	close_mvis(Fs,T).

close_mvi(F,T):-
	holds_from(F,T,T1),
	%update the mvi in the index
	retract(mholds_for(F,[T1,inf])),
	assert(mholds_for(F,[T1,T])).

open_mvis([],_).
open_mvis([F|Fs],T):-
	open_mvi(F,T),
	open_mvis(Fs,T).

open_mvi(F,T):-
        %insert mvi to the index
	assert(mholds_for(F,[T,inf])).


status(MVIs):-
        %query the index
	findall(mholds_for(F,[T1,T2]),mholds_for(F,[T1,T2]),MVIs).

reset:-
	retractall(happens(_,_)),
	retractall(mholds_for(_,_)),
	unregister(kbMap),
	unregister(mviMap),
	write("ENGINE RESET").

assert_all([]).
assert_all([H|T]):-
	assert(H),
	assert_all(T).




write_ct:-
	class('java.lang.System') <- currentTimeInMillis returns M,
	write(current_time(M)).