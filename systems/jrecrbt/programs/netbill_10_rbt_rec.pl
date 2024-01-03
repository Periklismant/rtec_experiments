test:-
	update([happens(presentQuote(4,4,book),1),happens(presentQuote(4,3,book),2),happens(acceptQuote(2,1,book),3),happens(presentQuote(3,2,book),4),happens(acceptQuote(4,4,book),5),happens(acceptQuote(1,2,book),6),happens(acceptQuote(1,3,book),7),happens(acceptQuote(4,3,book),8),happens(presentQuote(3,1,book),9),happens(presentQuote(2,1,book),10),happens(acceptQuote(3,2,book),11),happens(presentQuote(3,3,book),12),happens(presentQuote(3,1,book),13),happens(presentQuote(4,1,book),14),happens(presentQuote(2,1,book),15),happens(presentQuote(2,1,book),16),happens(presentQuote(3,4,book),17),happens(presentQuote(4,2,book),18),happens(presentQuote(1,2,book),19),happens(acceptQuote(4,3,book),20),happens(presentQuote(3,3,book),21),happens(presentQuote(4,2,book),22),happens(acceptQuote(4,2,book),23),happens(presentQuote(1,2,book),24),happens(presentQuote(3,2,book),25),happens(acceptQuote(4,2,book),26),happens(presentQuote(2,4,book),27),happens(presentQuote(4,3,book),28),happens(acceptQuote(3,4,book),29),happens(presentQuote(2,4,book),30),happens(presentQuote(3,2,book),31),happens(presentQuote(2,2,book),32),happens(presentQuote(4,2,book),33),happens(presentQuote(4,2,book),34),happens(acceptQuote(1,4,book),35),happens(presentQuote(1,3,book),36),happens(presentQuote(4,4,book),37),happens(presentQuote(1,1,book),38),happens(acceptQuote(1,3,book),39),happens(acceptQuote(3,4,book),40),happens(presentQuote(3,3,book),41),happens(presentQuote(4,4,book),42),happens(acceptQuote(3,1,book),43),happens(presentQuote(1,4,book),44),happens(acceptQuote(4,2,book),45),happens(acceptQuote(1,4,book),46),happens(presentQuote(2,2,book),47),happens(acceptQuote(2,2,book),48),happens(presentQuote(3,2,book),49),happens(acceptQuote(4,3,book),50),happens(presentQuote(3,2,book),51),happens(acceptQuote(3,4,book),52),happens(acceptQuote(4,4,book),53),happens(presentQuote(3,4,book),54),happens(presentQuote(4,1,book),55),happens(acceptQuote(3,1,book),56),happens(acceptQuote(4,3,book),57),happens(acceptQuote(3,2,book),58),happens(presentQuote(3,2,book),59),happens(acceptQuote(3,1,book),60),happens(acceptQuote(2,3,book),61),happens(presentQuote(1,1,book),62),happens(acceptQuote(3,2,book),63),happens(acceptQuote(1,3,book),64),happens(acceptQuote(3,3,book),65),happens(presentQuote(2,1,book),66),happens(presentQuote(4,2,book),67),happens(acceptQuote(2,1,book),68),happens(presentQuote(4,3,book),69),happens(acceptQuote(1,2,book),70),happens(acceptQuote(2,2,book),71),happens(acceptQuote(2,4,book),72),happens(acceptQuote(1,2,book),73),happens(acceptQuote(4,3,book),74),happens(acceptQuote(4,3,book),75),happens(acceptQuote(4,3,book),76),happens(acceptQuote(3,2,book),77),happens(presentQuote(4,2,book),78),happens(presentQuote(2,1,book),79),happens(presentQuote(3,1,book),80)]),
	status.

merchant(3).
merchant(4).
merchant(2).
merchant(1).
consumer(3).
consumer(4).
consumer(2).
consumer(1).
goods(book).

initiates(presentQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).

terminates(acceptQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).
:-unknown(_,fail).

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
	%java_object("TermRBTMap", [], traceMap),
	register(kbMap),
	register(mviMap),
	%register(traceMap),
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


%status(MVIs):-
%        %query the index
%	findall(mholds_for(F,[T1,T2]),(mholds_for(F,[T1,T2]), write(F), write("["), write(T1), write(","), write(T2), write("]"), nl), MVIs).

status:-
        %query the index
	findall(mholds_for(F,[T1,T2]),(mholds_for(F,[T1,T2])), _MVIs). %, retractall(happens(_,_)). % write(MVIs).

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
