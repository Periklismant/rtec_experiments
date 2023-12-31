test:-
	update([happens(acceptQuote(3,1,book),1),happens(acceptQuote(1,4,book),2),happens(presentQuote(2,2,book),3),happens(acceptQuote(2,2,book),4),happens(acceptQuote(2,1,book),5),happens(presentQuote(2,4,book),6),happens(presentQuote(1,4,book),7),happens(presentQuote(4,1,book),8),happens(acceptQuote(2,4,book),9),happens(presentQuote(1,1,book),10),happens(presentQuote(2,3,book),11),happens(acceptQuote(4,4,book),12),happens(presentQuote(3,3,book),13),happens(presentQuote(2,2,book),14),happens(acceptQuote(1,4,book),15),happens(acceptQuote(4,3,book),16),happens(presentQuote(2,2,book),17),happens(presentQuote(4,3,book),18),happens(acceptQuote(3,2,book),19),happens(acceptQuote(1,1,book),20),happens(presentQuote(4,3,book),21),happens(presentQuote(2,2,book),22),happens(presentQuote(4,3,book),23),happens(presentQuote(2,2,book),24),happens(presentQuote(1,1,book),25),happens(presentQuote(1,4,book),26),happens(presentQuote(2,4,book),27),happens(presentQuote(2,3,book),28),happens(presentQuote(2,4,book),29),happens(presentQuote(1,1,book),30),happens(presentQuote(4,1,book),31),happens(acceptQuote(1,2,book),32),happens(presentQuote(2,2,book),33),happens(presentQuote(1,3,book),34),happens(presentQuote(1,1,book),35),happens(presentQuote(4,1,book),36),happens(acceptQuote(2,3,book),37),happens(acceptQuote(4,4,book),38),happens(acceptQuote(4,1,book),39),happens(presentQuote(3,4,book),40),happens(acceptQuote(1,2,book),41),happens(acceptQuote(1,4,book),42),happens(acceptQuote(2,3,book),43),happens(presentQuote(1,3,book),44),happens(presentQuote(2,2,book),45),happens(acceptQuote(1,2,book),46),happens(acceptQuote(1,2,book),47),happens(acceptQuote(4,4,book),48),happens(acceptQuote(2,2,book),49),happens(acceptQuote(2,2,book),50),happens(acceptQuote(1,3,book),51),happens(acceptQuote(1,1,book),52),happens(acceptQuote(1,1,book),53),happens(acceptQuote(4,3,book),54),happens(acceptQuote(4,4,book),55),happens(acceptQuote(1,1,book),56),happens(acceptQuote(4,3,book),57),happens(presentQuote(1,4,book),58),happens(acceptQuote(4,4,book),59),happens(presentQuote(2,2,book),60),happens(presentQuote(2,4,book),61),happens(presentQuote(2,3,book),62),happens(presentQuote(4,4,book),63),happens(presentQuote(1,3,book),64),happens(acceptQuote(3,3,book),65),happens(presentQuote(4,2,book),66),happens(presentQuote(1,4,book),67),happens(acceptQuote(2,4,book),68),happens(acceptQuote(1,2,book),69),happens(presentQuote(1,2,book),70),happens(presentQuote(2,4,book),71),happens(presentQuote(1,1,book),72),happens(presentQuote(3,1,book),73),happens(presentQuote(1,1,book),74),happens(presentQuote(1,4,book),75),happens(acceptQuote(1,2,book),76),happens(presentQuote(4,4,book),77),happens(presentQuote(1,3,book),78),happens(presentQuote(2,2,book),79),happens(presentQuote(2,1,book),80)]),
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
%-----------------------------------------------------------------------------%
% Re-definition of inequality signs to include infinite quantities.
lt(A,B):-gt(B,A).
le(A,B):-ge(B,A).

gt(inf,B):- B\==inf,!.
gt(_,inf):-!,fail.
gt(A,B):- A>B.

ge(A,A):-!.
ge(A,B):-gt(A,B).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Re-definition of setof predicate.
my_setof(A,B,C):-
	setof(A,B,C),!.
my_setof(_,_,[]).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
%Takes the list of events without duplicates and orders them.
order_events(Trace,OTrace):-
	order_events(Trace,[],OTrace).
	
order_events([],OTrace,OTrace).
order_events([H|T],OPTrace,OTrace):-
	ordered_insert(OPTrace,H,OPTraceNew),
	order_events(T,OPTraceNew,OTrace).

ordered_insert([],H,[H]).
ordered_insert([happens(Ev1,T1)|Trace],happens(Ev,T),[happens(Ev,T),happens(Ev1,T1)|Trace]):-
	le(T,T1),!.
ordered_insert([H1|Trace],H,[H1|NewTrace]):-
	ordered_insert(Trace,H,NewTrace).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Generic E.C. predicates.
holds_at(F, T):-
	holds_from(F, T, _).
	
holds_from(F, T, T1):-
	mholds_for(F, [T1, T2]),
	gt(T, T1),
	le(T, T2).


initiates(start, F, T):-
	initially(F).
	
declip(F,T):-
	happens(E,T),
	initiates(E, F, T),
	\+ holds_at(F, T).

clip(F,T):-
	happens(E,T),
	terminates(E, F, T),
	holds_at(F, T).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Starts the REC engine, calculating fluents the initial state.
start:-
	update([happens(start,-1)]).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% REC engine backbone.
update(ExtTrace):-
	remove_duplicates(ExtTrace,NExtTrace),
	order_events(NExtTrace,OTrace),
	manage_concurrency(OTrace, Trace),
	update_events(Trace).

update_events([]).
update_events([H|T]):-
	update_events(H),
	update_events(T).	
	
update_events([happens(E,T)|Events]):-
	future_trace(T,FTraceRaw),
	order_events(FTraceRaw,FTraceO),
	manage_concurrency(FTraceO,FTrace),
	roll_back(T),
	calculate_effects([[happens(E,T)|Events]|FTrace]).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Given an input timepoint, returns a list of all events which happen after that.
future_trace(T,FTrace):-
	my_setof(H,happens_after(H,T),FTrace).

% Predicate used for the previous setof. Returns an event which appen after Tref.
happens_after(happens(E,T),Tref):-
	happens(E,T),
	gt(T,Tref).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Given a timepoint T:
% - it removes all the events that happen after
% - it removes all the MVIs that start to hold after
% - it opens all the fluents that are holding at T
roll_back(T):-
	truncate_trace(T),
	remove_future_MVIs(T),
	open_current_MVIs(T).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Given an input timepoint, obtains the future trace relative to those events 
% (i.e. all the events happened after T) and retracts them.
truncate_trace(T):-
	future_trace(T,FTrace),
	remove_events(FTrace).

remove_events([]).
remove_events([H|Trace]):-
	retract(H),
	remove_events(Trace).
%-----------------------------------------------------------------------------%	
	
%-----------------------------------------------------------------------------%
% Given a certain timepoint, removes all the MVI that start to hold
% afterwards.
remove_future_MVIs(T):-
	my_setof(MVI,future_MVI(MVI,T),MVIs),
	remove_MVIs(MVIs).

% Predicate used in the previous setof. Returns an MVI which starts to hold after
% the timepoint reference (Tref).
future_MVI(mholds_for(F,[Ts,Te]),Tref):-
	mholds_for(F,[Ts,Te]),
	gt(Ts,Tref).
%-----------------------------------------------------------------------------%

remove_MVIs([]).
remove_MVIs([MVI|MVIs]):-
	retract(MVI),
	remove_MVIs(MVIs).

%-----------------------------------------------------------------------------%
% Given a certain timepoint, opens all the MVIs that hold during that timepoint.
open_current_MVIs(T):-
	my_setof(MVI,current_MVI(MVI,T),MVIs),
	open_MVIs(MVIs).

% Predicate used in the previous setof. Returns an MVI which holds at the
% reference timepoint (Tstart<Tref=<Tend).
current_MVI(mholds_for(F,[Ts,Te]),Tref):-
	mholds_for(F,[Ts,Te]),
	gt(Tref,Ts),
	le(Tref,Te).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Takes a list of MVIs, retracts them, and asserts new ones.
% The new MVIs have the same starting timepoints, but the ending timepoints are
% replaced with "inf". This is the meaning opening an MVI.
open_MVIs([]).
open_MVIs([mholds_for(F,[Ts,Te])|MVIs]):-
	retract(mholds_for(F,[Ts,Te])),
	assert(mholds_for(F,[Ts,inf])),
	open_MVIs(MVIs).
%-----------------------------------------------------------------------------%			

%-----------------------------------------------------------------------------%
%Applies the calculate_effects_events predicate to every element of the event list
calculate_effects([]).
calculate_effects([H|T]):-
	calculate_effects_events(H),
	calculate_effects(T).

% This is the core mechanism of REC. Each event E in the list, which happens at T:
% -is asserted back into the database
% -is evaluated to find fluents clipped by that event (at T)
% 	-the clipped fluents are closed
% -is evaluated to find fluents de-clipped by that event (at T)
% 	-the de-clipped fluents are opened
calculate_effects_events([happens(E,T)|Events]):-
	assert_all([happens(E,T)|Events]),
	my_setof(F, clip(F,T),S),
	close_mvis(S,T),
	my_setof(F, declip(F,T),S2),
	open_mvis(S2,T).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Takes a list of MVIs and closes them with respect to timepoint T.
% The meaning of closing an MVI that holds at T, is to retract it 
% (if it's open -> ending time = inf) and to assert a new MVI with
% ending time replaced with T.
close_mvis([],_).
close_mvis([F|Fs],T):-
	close_mvi(F,T),
	close_mvis(Fs,T).
	
close_mvi(F,T):-
	holds_from(F,T,T1),
	retract(mholds_for(F,[T1,inf])),
	assert(mholds_for(F,[T1,T])).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Takes a list of MVIs and opens them. 
% The meaning of opening a fluent's MVI is to retract the previous MVI and to 
% assert a new MVI with the ending time set to "inf"
open_mvis([],_).
open_mvis([F|Fs],T):-
	open_mvi(F,T),
	open_mvis(Fs,T).

open_mvi(F,T):-
	assert(mholds_for(F,[T,inf])).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Returns the MVIs for all the active fluents.
status(MVIs):-
	findall((F,[T1,T2]),mholds_for(F,[T1,T2]),MVIs).

status:-
	findall((F,[T1,T2]),mholds_for(F,[T1,T2]),MVIs), write(MVIs).

% Cleans the memory (trace and mvis)
reset:-
	retractall(happens(_,_)),
	retractall(mholds_for(_,_)).
%-----------------------------------------------------------------------------%
		
%-----------------------------------------------------------------------------%	
%Takes the ordered events list and returns a lists of lists.
%Every sublist is a list of events that happen in the same timepoint.
manage_concurrency([],[]).
manage_concurrency(L,[H|T]):-
	separate(L,H,TL),
	manage_concurrency(TL,T).
	
separate([happens(E,T)|Tail],HF,TF):-
	separate(Tail,[happens(E,T)],HF,TF).

separate([happens(E2,T)|Tail],[happens(E,T)|Tail2],HF,TF):-
		!,
		separate(Tail,[happens(E2,T),happens(E,T)|Tail2],HF,TF).
	
separate(L,HF,HF,L).
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
%Takes a list of happens predicates (raw trace) and removes duplicate events.
remove_duplicates([],[]).
remove_duplicates([happens(E,T)|Tail],L):-
	happens(E,T),!,
	remove_duplicates(Tail,L).
remove_duplicates([H|T],[H|T2]):-
	remove_duplicates(T,T2).
%-----------------------------------------------------------------------------%			

assert_all([]).
assert_all([H|T]):-
	assert(H),
	assert_all(T).
