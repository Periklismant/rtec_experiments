
processSimpleFluent(Index, F=V, InitTime, QueryTime) :-
	isThereASimpleFPList(Index, F=V, ExtendedPList), % we kept simpleFPList just for ExtendedPList
		%write('for FVP: '), write(F=V), write('ExtendedPList: '), write(ExtendedPList), nl,
	setTheSceneSimpleFluent(ExtendedPList, F=V, InitTime, StPoint), % then, we use ExtendedPList to 
		%write('StPoint: '), write(StPoint), nl,
	% compute the starting points within (Qi-WM,Qi] 

	computeStartingPoints(F=V, InitTime, QueryTime, InitList),
		

	% append the starting point of the interval, if any, starting
	% before or on Qi-WM and ending after Qi-WM   
	% to the starting points computed at this stage  
	addPoint(StPoint, InitList, CompleteInitList),
		%write('\tStarting Points: '), write(CompleteInitList), nl,

	% store the starting points of fluents that expire and cyclic fluents
	storeStartingPoints(Index, F=V, CompleteInitList),
	
	% compute new intervals
	holdsForSimpleFluent(F=V, NewIntervals, InitTime, QueryTime, CompleteInitList),
	
	% update simpleFPList
	computesimpleFPList(NewIntervals, InitTime, RestrictedPeriods, Extension),
	%write('\tRestrictedPeriods: '), write(RestrictedPeriods), nl,
	%write('\tExtension: '), write(Extension), nl,
	updatesimpleFPList(Index, F=V, RestrictedPeriods, Extension).
	

isThereASimpleFPList(Index, F=V, ExtendedPList) :-
	simpleFPList(Index, F=V, RestrictedList, Extension), !,
	
	retract(simpleFPList(Index, F=V, _ ,_)),
	
	amalgamatePeriods(Extension, RestrictedList, ExtendedPList).

% this predicate deals with the case where no intervals for F=V were computed at the previous query time
isThereASimpleFPList(_Index, _U, []).



/************************************************************************************************************* 
   This predicate is similar to setTheSceneSDFluent. The main difference is that instead of breaking
   the interval, if any, that starts before or on Qi-Memory and ends after Qi-Memory, we delete it (the 
   interval) and keep the starting point. cachedHoldsFor will create the fluent intervals given this 
   starting point and other starting and ending points within (Qi-WM,WM]. 
 *************************************************************************************************************/

% deals with the case in which InitTime=<0
setTheSceneSimpleFluent(_EPList, F=V, InitTime, StPoint) :-
	InitTime=<0,
	( 
		%initially(F=V), 
		initiatedAt(F=V, 0, _, 1),
		StPoint=[1] 
		;
		StPoint=[] 
	), !.

% there is no need to update starting points in this case
% if there were any starting points then the first argument would not have been empty
setTheSceneSimpleFluent([], _U, _InitTime, []) :- !.

% deals with the interval, if any, that starts before or on Qi-WM and ends after Qi-WM
setTheSceneSimpleFluent(EPList, _U, InitTime, StPoint) :-
	% look for an interval starting before or on Qi-WM and ending after Qi-WM %% (or at Qi-WM I think)
	%% changed this...
	%InitTimePlus1 is InitTime+1,
	member((Start,End), EPList), 
	gt(End, InitTime),%gt(End,InitTimePlus1),
	StartMinus1 is Start-1,
	(
		StartMinus1=<InitTime, StPoint=[Start]
		;
		StPoint=[]
	), !.    

% all intervals end before Qi-WM 
setTheSceneSimpleFluent(_EPList, _U, _InitTime, []).


/****** compute starting points ******/

computeStartingPoints(F=V, InitTime, QueryTime, InitList) :-
	initList(F=V, InitTime, QueryTime, InitList).

% find the initiating time-points within (Qi-WM,Qi]

initList(F=V, InitTime, QueryTime, InitList) :-
	EndTime is QueryTime+1,
	setof(T, initPoint(F=V, InitTime, EndTime, T), InitList), !.

% if there is no initiating point

initList(_, _, _, []).
 
/*
%% New:
initPoint(F=V, InitTime, EndTime, NextTs):-
	cyclic(F=V), !, 
	%indexOf(Index, F=V),
	%initiatedAtCyclic(Index, F=V, InitTime, Ts, EndTime),
	initiatedAt(F=V, InitTime, Ts, EndTime),
	nextTimePoint(Ts, NextTs),
	write('initPoint for FVP:'), write(F=V), write(' found at T='), write(Ts), nl.
	%addCyclicPoint(Index, F=V, NextTs, t), 
	%simpleFluent(F=V2), \+V2=V, 
	%indexOf(Index2, F=V2), 
	%addCyclicPoint(Index2, F=V2, NextTs, f).   
*/

%% New: 
initPoint(F=V, InitTime, EndTime, S):-
	indexOf(Index, F=V),
	(startingPoints(Index, F=V, SPoints),
	member(S, SPoints), S>=InitTime, S<EndTime
	; 
	initiatedAtCyclic(Index, F=V, InitTime, Ts, EndTime),
	%initiatedAt(F=V, InitTime, Ts, EndTime),
	nextTimePoint(Ts, S)).

%initPoint(F=V, InitTime, EndTime, NextTs) :-
%	initiatedAt(F=V, InitTime, Ts, EndTime),
%		write('initPoint for FVP:'), write(F=V), write(' found at T='), write(Ts), nl,
%	nextTimePoint(Ts, NextTs).

/****** compute ending points ******/

computeEndingPoints(F=V, InitTime, QueryTime, TerminList) :-
	terminList(F=V, InitTime, QueryTime, TerminList).


% find the terminating time-points within (Qi-WM,Qi]

terminList(F=V, InitTime, QueryTime, TerminList) :-
	EndTime is QueryTime+1,
	setof(T, termPoint(F=V, InitTime, EndTime, T), TerminList), !.

% if there is no terminating point

terminList(_, _, _, []).

%% New:
termPoint(F=V, InitTime, EndTime, E) :-
	indexOf(Index, F=V),
	(endingPoints(Index, F=V, EPoints), \+EPoints=[],
	 member(E, EPoints), E>=InitTime, E<EndTime
	 ;
	 terminatedAtCyclic(Index, F=V, InitTime, Ts, EndTime),
	 nextTimePoint(Ts, E)
	 ;
	 simpleFluent(F=V2), \+V=V2,
	 indexOf(Index2, F=V2), 
	 initiatedAtCyclic(Index2, F=V2, InitTime, Ts, EndTime),
	 nextTimePoint(Ts, E)).

%termPoint(F=V, InitTime, EndTime, NextTs) :-
%	broken(F=V, InitTime, Ts, EndTime),
%	nextTimePoint(Ts, NextTs).


% 'Classic' Event Calculus

/*
broken(F=V, Ts, Tf, T):-
	cyclic(F=V),
	indexOf(Index, F=V), 
	terminatedAtCyclic(Index, F=V, Ts, Tf, T).

broken(F=V1, Ts, Tstar, T) :-
	cyclic(F=V1), !, 
	simpleFluent(F=V2), \+V2=V1,
	indexOf(Index, F=V2),
	initiatedAtCyclic(Index, F=V2, Ts, Tstar, T).
*/
broken(U, Ts, Tf, T) :-
	terminatedAt(U, Ts, Tf, T).
  
broken(F=V1, Ts, Tstar, T) :-
	simpleFluent(F=V2), \+V2=V1,
	initiatedAt(F=V2, Ts, Tstar, T).

% strong_initiates.
strong_initiates :- fail.    %% weak initiates 


/****** auxiliary predicate ******/

addPoint([], L, L) :- !.
addPoint([P], L, [P|L]).

/****** store the starting points of maxDuration fluents ******/

storeStartingPoints(_, _, []) :- !.
storeStartingPoints(Index, F=V, SPoints) :-
	maxDuration(F=V, _, _),
	retract(startingPoints(Index, F=V, _)), !,
	assert(startingPoints(Index, F=V, SPoints)).
storeStartingPoints(Index, F=V, SPoints) :-
	maxDuration(F=V, _, _), !,
	assert(startingPoints(Index, F=V, SPoints)).
storeStartingPoints(Index, F=V, SPoints) :-
	cyclic(F=V),
	retract(startingPoints(Index, F=V, _)), !,
	assert(startingPoints(Index, F=V, SPoints)).
storeStartingPoints(Index, F=V, SPoints) :-
	cyclic(F=V), !,
	assert(startingPoints(Index, F=V, SPoints)).
storeStartingPoints(_, _, _).



/****** compute new intervals given the computed starting and ending points ******/

holdsForSimpleFluent(_U, [], _InitTime, _QueryTime, []) :- !.

holdsForSimpleFluent(U, PeriodList, InitTime, QueryTime, InitList) :-
	% compute the ending points within (Qi-WM,Qi]
		%getCPUtime(T1endingPoints),
	computeEndingPoints(U, InitTime, QueryTime, TerminList),
		%write('\tStarting Points: '), write(InitList), nl,
		%indexOf(Index, U),
		%startingPoints(Index, U, SPoints),
		%write('\tStored Starting Points: '), write(SPoints), nl,
		%write('\tTermination Points: '), write(TerminList), nl,
		%getCPUtime(T2endingPoints),
		%updateTimeTemp(ending_point_time, T1endingPoints, T2endingPoints),
		%length(TerminList, EndingPointsNo),
		%updateVariableTemp(ending_point_number, EndingPointsNo),
	makeIntervalsFromSEPoints(InitList, TerminList, PeriodList).
		%write('\tPeriodsList: '), write(PeriodList), nl.
		%getCPUtime(T2makeIntervals),
		%updateTimeTemp(make_intervals_time, T2endingPoints, T2makeIntervals),
		%length(PeriodList, IntervalsNo),
		%updateVariableTemp(interval_number, IntervalsNo).
      

% the predicate below works under the assumption that the lists of 
% initiating and terminating points are temporally sorted

% makeIntervalsFromSEPoints(+ListofStartingPoints, +ListofEndingPoints, -MaximalIntervals) 

% base cases: single initiation point
makeIntervalsFromSEPoints([Ts], EPoints, Period) :-
	member(Tf, EPoints), 
	Ts=<Tf, 
	(
		Ts=Tf, !, 
		Period=[]
		;	
		%Ts<Tf
		!, Period=[(Ts,Tf)]
	).
makeIntervalsFromSEPoints([Ts], _EPoints, [(Ts,inf)]) :- !.   

% recursion: at least two initiation points
makeIntervalsFromSEPoints([T|MoreTs], [T|MoreTf], Periods) :-
	!, makeIntervalsFromSEPoints(MoreTs, MoreTf, Periods).

makeIntervalsFromSEPoints([Ts|MoreTs], [Tf|MoreTf], Periods) :-
	Tf<Ts, !, 
	makeIntervalsFromSEPoints([Ts|MoreTs], MoreTf, Periods).

makeIntervalsFromSEPoints([Ts,T|MoreTs], [T|MoreTf], [(Ts,T)|MorePeriods]) :-
	%Ts<Tf,  
	%Tf=Tnext, 
	!, makeIntervalsFromSEPoints([T|MoreTs], [T|MoreTf], MorePeriods).

makeIntervalsFromSEPoints([Ts,Tnext|MoreTs], [Tf|MoreTf], [(Ts,Tf)|MorePeriods]) :-
	%Ts<Tf,  
	Tf<Tnext, !,
	makeIntervalsFromSEPoints([Tnext|MoreTs], MoreTf, MorePeriods).

makeIntervalsFromSEPoints([Ts,Tnext|MoreTs], [Tf|MoreTf], [(Ts,Tf)|MorePeriods]) :-
	%Ts<Tnext<Tf,  
	!, makeIntervalsFromSEPoints([Tnext|MoreTs], [Tf|MoreTf], [(Tnext,Tf)|MorePeriods]).

makeIntervalsFromSEPoints([Ts,_Tnext|_MoreTs], _EPoints, [(Ts,inf)]).


/****** computesimpleFPList  ******/


computesimpleFPList([], _InitTime, [], []) :- !.

computesimpleFPList([(Start,End)|Tail], InitTime, [(Start,End)|Tail], []) :-
	Start>InitTime, !.

computesimpleFPList([(Start,End)|Tail], InitTime, [(NewInitTime,End)|Tail], [(Start,NewInitTime)]) :-
	nextTimePoint(InitTime, NewInitTime), 
	\+ NewInitTime = End, !.

computesimpleFPList([Head|Tail], _InitTime, Tail, [Head]).


/****** updateSimpleFPList  ******/

updatesimpleFPList(_Index, _U, [], []) :- !.

updatesimpleFPList(Index, F=V, NewPeriods, BrokenPeriod) :- 
	%fetchKey(F=V, Key),
	%recordz(Key, simpleFPList(F=V, NewPeriods, BrokenPeriod), _).
	assert(simpleFPList(Index, F=V, NewPeriods, BrokenPeriod)).






