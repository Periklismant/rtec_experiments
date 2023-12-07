
% ========================
/*
EVENT RECOGNITION LOOP

--- initialiseRecognition(+InputFlag, +PreProcessingFlag, +TemporalDistance). 
InputFlag=ordered means that input facts are temporally sorted. 
InputFlag=any_other_value means that input facts are not temporally sorted. 
PreProcessingFlag=preprocessing means that there is a need for preprocessing by means of an application-dependent preProcessing/1. See the experiments on the CAVIAR dataset for an example of preprocessing.
PreProcessingFlag=any_other_value means that there is no need for preprocessing.
TemporalDistance is an integer denoting the distance between two consecutive time-points. Eg, in CAVIAR the temporal distance is 40.  

Assert input facts at your leisure, even in a non-chronological manner. Then perform event recognition:
--- eventRecognition(+Qi, +WM).
where Qi is the current query time, and WM is the 'working memory'.

A NOTE ON THE LISTS THAT ARE USED IN THE CODE

-simpleFPList/sdFPList(Index, F=V, RestrictedList, Extension) where RestrictedList is the list of periods of the simple (statically determined) fluent within (Qi-WM, Qi] and Extension is the period before Qi-WM. Extension must be amalgamated with RestrictedList in order to produce the correct result of event recognition at Qi. F=V is an output entity.
-iePList(Index, F=V, RestrictedList, Extension) like above, except that F=V is an input entity.
-evTList: the time-points of output entity/event within (Qi-WM, Qi].

---RTEC PREDICATES---

The predicates below are available to the user:

-happensAt(E, T) represents the time-points T in which an event E occurs.
-happensAt(start(F=V), T) represents a special event which takes place at the starting points of the maximal intervals of F=V. Similarly for happensAt(end(F=V), T). 
-initially(F=V) expresses that F=V at time 0.
-initiatedAt(F=V, _, T, _) states that at time T a period of time for which F=V is initiated. 
-terminatedAt(F=V, _, T, _) states that at time T a period of time for which F=V is terminated. 
-holdsFor(F=V, L) represents that the list of maximal intervals L during which F=V holds continuously.
-holdsAt(F=V, T) states that F=V holds at time-point T. 

The predicates above are compiled into the following:

-happensAtIE(E, T) represents the time-points T in which an input entity/event E occurs.
-happensAtProcessedIE(start(U), T) represents the time-points in which a special event 'start' occurs. The special event takes place at the starting points of the input entity/statically determined fluent U. The intervals of U are cached.  Similarly for happensAtProcessedIE(end(U), T).
-happensAtProcessedSimpleFluent(start(U), T) represents the time-points in which a special event 'start' occurs. The special event takes place at the starting points of the simple fluent U. The intervals of U are cached. Similarly for happensAtProcessedSimpleFluent(end(U), T).
-happensAtProcessedSDFluent(start(U), T) represents the time-points in which a special event 'start' occurs. The special event takes place at the starting points of the output entity/statically determined fluent U. The intervals of U are cached. Similarly for happensAtProcessedSDFluent(end(U), T).
-happensAtProcessed(E, T) represents the cached time-points T in which an output entity/event E occurs. E is not a start() or end() event.
-happensAtEv(E, T) represents the definition of an output entity/event.
-happensAt(E, T) is used for user interaction.

-holdsForIESI(U, I) represents an interval I in which an input entity/statically determined fluent U occurs. Note that the second argument of this predicate is a single interval, as opposed to a list of intervals; underlying sensor data processing systems report single intervals as opposed to lists of intervals.
-holdsForProcessedIE(Index, IE, L) retrieves the cached list of intervals of an input entity/statically determined fluent.
-holdsForProcessedSimpleFluent(Index, F=V, L) retrieves the cached list of intervals of a simple fluent.
-holdsForProcessedSDFluent(Index, F=V, L) retrieves the cached list of intervals of an output entity/statically determined fluent.
-holdsForSDFluent(F=V, L) represents the definition of a durative output entity/statically determined fluent.
-holdsFor(F=V, L) is used for user interaction.

-holdsAtProcessedIE(Index, F=V, T) checks whether a processed input entity/statically determined fluent holds at a given time-point.
-holdsAtProcessedSDFluent(Index, F=V, T) checks whether a cached output entity/statically determined fluent holds at a given time-point.
-holdsAtProcessedSimpleFluent(Index, F=V, T) checks whether a cached simple fluent holds at a given time-point.
-holdsAtSDFluent(Index, F=V, T) checks whether a statically determined fluent holds at a given time-point. This predicate is used when the intervals F=V are not cached.
-holdsAt(F=V, T) is used for user interaction.

NOTE: statically determined fluents are defined only in terms of interval manipulation constructs, ie they are not defined by means of holdsAt.
NOTE: The second argument in holdsAtX query should be ground.

DECLARATIONS:

-event(E) states that E is an event.
-simpleFluent(F=V) states that F=V is a simple fluent.
-sDFluent(F=V) states that F=V is a statically determined fluent.

-inputEntity(U) represents the input entities (events and/or statically determined fluents).
-outputEntity(U) represents the composite entities (events, simple fluents and/or statically determined fluents).

-collectIntervals(F=V) states that the list of intervals of input entity/statically determined fluent F=V will be produced by the RTEC input module by collecting the reported individual intervals
-buildIntervals(F=V) states that the list of intervals of input entity/statically determined fluent F=V will be produced by the RTEC input module by gathering the reported time-points
 
-temporalDistance(TD) denotes the temporal distance between consecutive time-points. In some applications, such as video surveillance, there is a fixed temporal distance between time-points (video frames). In other applications this is not the case and therefore temporalDistance/1 should be undefined.

-cachingOrder(Index, U) denotes the order of entity (event or fluent) processing. The first argument is the index of the entity.
*/

% ========================

:- set_prolog_flag(toplevel_print_options, [max_depth(400)]).
:- use_module(library(lists)).
:- use_module(library(ordsets)).
%:- use_module(library(dbusage)). %% Only for YAP

% Load predicates for creating extensive log files
:-['utilities/makeLogs.prolog'].
% Load predicates for managing predicates in internal (recorded) database
:-['utilities/idb-utils.prolog'].

% Count Entries per Key in idb
% findall((K,E), (current_key(A, K), key_statistics(K, E, _), E>0,  write(E), nl) , L), length(L, Llen).
% findall(E, (current_key(A, K), key_statistics(K, E, _)) , L), length(L, Llen), sumlist(L, Lsum), Avg is Lsum/Llen.

% Find all index/instances of simpleFPlist/etc.
% findall(Index, simpleFPList(Index, per(present_quote(_,_))=false, _, _), IndexList), list_to_ord_set(IndexList, IndexSet), length(IndexSet, IndexNo).
% findall((M,C), simpleFPList(_Index, per(present_quote(M,C))=false, _, _), FVList),  length(FVList, FVNo).
% findall(Index, (simpleFPList(Index, per(present_quote(_,_))=false, _, _), role_of(Index, consumer)), IndexList), list_to_ord_set(IndexList, IndexSet), length(IndexSet, IndexNo).
% findall((M,C,Intervals), simpleFPList(_, per(present_quote(M,C))=false, Intervals, _), IntervalsList).

:- ['compiler.prolog'].
:- ['inputModule.prolog'].
:- ['processSimpleFluents.prolog'].
:- ['processSDFluents.prolog'].
:- ['processEvents.prolog'].
:- ['utilities/interval-manipulation.prolog'].
:- ['utilities/amalgamate-periods.prolog'].
:- ['utilities/makeLogs.prolog'].
% Load the dynamic grounding module
:- ['dynamic grounding/dynamicGrounding.prolog'].

/***** dynamic predicates *****/

% The predicates below are asserted/retracted
:- dynamic temporalDistance/1, input/1, noDynamicGrounding/0, preProcessing/1, initTime/1, iePList/4, 
		   simpleFPList/4, sdFPList/4, evTList/3, happensAtIE/2, holdsForIESI/2, holdsAtIE/2, processedCyclic/2, 
		   initiallyCyclic/1, storedCyclicPoints/3, startingPoints/3, endingPoints/3, processedRangeInit/3, processedRangeTerm/3.

% The predicates below may or may not appear in the declarations of an application;
% thus they must be declared dynamic
:- dynamic collectIntervals/1, collectIntervals2/2, buildFromPoints/1, buildFromPoints2/2, cyclic/1, 
		   maxDuration/3, maxDurationUE/3, internalEntity/1, sDFluent/1, inputEntity/1, event/1.

/***** multifile predicates *****/

:- multifile 
% holdsFor/2 and happensAt/2 are defined in this file and may also be defined in an event description
holdsFor/2, happensAt/2,
% these predicates may appear in the data files of an application
updateSDE/2, updateSDE/3, updateSDE/4,
% these predicates are used in processSimpleFluent.prolog
initially/1, initiatedAt/4, terminatedAt/4,
% happensAtEV/2 may be defined in an event description with output events.
happensAtEv/2.
/***** discontiguous predicates *****/

:- discontiguous
% these predicates are defined in this file 
happensAtProcessedIE/3, happensAtProcessedSDFluent/3, happensAtProcessedSimpleFluent/3, deadlines1/3,
% these predicates may be part of the declarations of an event description 
inputEntity/1, internalEntity/1, outputEntity/1, index/2, event/1, simpleFluent/1, sDFluent/1, grounding/1, dgrounded/2,
% these predicates may be part of an event description 
holdsFor/2, holdsForSDFluent/2, initially/1, initiatedAt/2, terminatedAt/2, initiates/3, terminates/3, initiatedAt/4, terminatedAt/4, happensAt/2, maxDuration/3, maxDurationUE/3,
% this predicate may appear in the data files of an application
updateSDE/4. 

/********************************** INITIALISE GLOBAL VARIABLES ***********************************/

 %:- initGlobals. % Uncomment for unit tests. This is present in continuousQueries.

/********************************** INITIALISE RECOGNITION ***********************************/

initialiseRecognition(InputFlag, DynamicGroundingFlag, PreProcessingFlag, TemporalDistance) :-
	assert(temporalDistance(TemporalDistance)), 
	% Assert threshold for forget and dynamic grounding mechanisms here 
	% to avoid carrying these values forever 
	assert(eventsPerTimepointThreshold(-1)), 
	assert(groundTermOverlapThreshold(-1)), 
	(InputFlag=ordered, assert(input(InputFlag)) ; assert(input(unordered))),
	% if we need dynamic grounding then dynamicGrounding/1 is already defined
	% so there is no need to assert anything here
	(DynamicGroundingFlag=dynamicgrounding ; assert(noDynamicGrounding)),	
	% if we need preprocessing then preProcessing/1 is already defined
	% so there is no need to assert anything here
	(PreProcessingFlag=preprocessing ; assert(preProcessing(_))), !.


initialiseRecognition(InputFlag, DynamicGroundingFlag, PreProcessingFlag, ForgetThreshold, DynamicGroundingThreshold, TemporalDistance) :-
	assert(temporalDistance(TemporalDistance)), 
	% Assert threshold for forget and dynamic grounding mechanisms here 
	% to avoid carrying these values forever 
	assert(eventsPerTimepointThreshold(ForgetThreshold)), 
	assert(groundTermOverlapThreshold(DynamicGroundingThreshold)),
	(InputFlag=ordered, assert(input(InputFlag)) ; assert(input(unordered))),
	% if we need dynamic grounding then dynamicGrounding/1 is already defined
	% so there is no need to assert anything here
	(DynamicGroundingFlag=dynamicgrounding ; assert(noDynamicGrounding)),	
	% if we need preprocessing then preProcessing/1 is already defined
	% so there is no need to assert anything here
	(PreProcessingFlag=preprocessing ; assert(preProcessing(_))), !.

/************************************* EVENT RECOGNITION *************************************/


eventRecognition(QueryTime, WM) :-
	InitTime is QueryTime-WM,
		write('InitTime: '), write(InitTime), nl,
	assert(initTime(InitTime)),
    % delete input entities that have taken place before or on Qi-WM
 		getCPUtime(Time1forget),
	forget(InitTime),
		getCPUtime(Time2forget),
		updateTime(forget_time,Time1forget,Time2forget),
		write('Forget OK!'), nl,
	% calculate the items for which we will perform reasoning
		%getCPUtime(Time1DG),
	dynamicGrounding(InitTime, QueryTime),
		write('DG OK!'), nl,
		%getCPUtime(Time2DG),
		%updateTime(dg_time,Time1DG,Time2DG),
	%%% 
	%nl, write('Statistics after forget and dynamic grounding'), nl, printStatistics, 
	% Garbage Collect Retracted Clauses
	%garbage_collect_clauses, %% only supported in SWIPL
	% compute the intervals of input entities/statically determined fluents
	inputProcessing(InitTime, QueryTime),
		write('inputProcessing OK!'), nl,
	preProcessing(QueryTime),
		write('preProcessing OK!'), nl,
	%% Change: startingPoints retraction used to be after prepareCyclic.
	findall((Index,F=V,SPoints), (startingPoints(Index,F=V,SPoints),retract(startingPoints(Index,F=V,SPoints))), _),
		write('startingPoints OK!'), nl,
	% CYCLES #1 CHANGE
	prepareCyclic,
		write('prepareCyclic OK!'), nl,
	% CYCLES & DEADLINES CHANGE
	% DEADLINES #1 CHANGE
		%getCPUtime(Time1dead1),
	findall((F=V,Duration), (maxDuration(F=V,_,Duration), deadlines1(F=V,Duration,InitTime)), _),
		write('deadlines1 OK!'), nl,
		%getCPUtime(Time2dead1),
		%updateTime(deadlines_time,Time1dead1,Time2dead1),
	% the order in which entities are processed makes a difference
	% start from lower-level entities and then move to higher-level entities
	% in this way the higher-level entities will use the CACHED lower-level entities
	% the order in which we process entities is set by cachingOrder/1 
	% which is specified in the domain-dependent file 
	% cachingOrder2/2 is produced in the compilation stage 
	% by combining cachingOrder/1, indexOf/2 and grounding/1
		getCPUtime(Time1proc),
	%preprocessCycles,
		%write('preprocessCycles OK!'), nl,
	%computeCycleIncremental(InitTime, QueryTime),
		%write('computeCycleIncremental OK!'), nl,
	findall(OE, (cachingOrder2(Index,OE), processEntity(Index,OE,InitTime,QueryTime)), _),
	%findall(FVPList, (cycle(FVPList), processCycle(FVPList, InitTime, QueryTime)), _),
		getCPUtime(Time2proc),
		updateTime(process_time,Time1proc,Time2proc),
		commitVariables(processEntityFlag),
		write('processEntity OK!'), nl,

	%makeIntervalsCycle,

	% DEADLINES #2 CHANGE
		%getCPUtime(Time1dead2),
	findall((F=V,Duration), (maxDuration(F=V,_,Duration), deadlines2(F=V,Duration,InitTime)), _),
		write('deadlines2 OK!'), nl,
		%getCPUtime(Time2dead2),
		%updateTime(deadlines_time,Time1dead2,Time2dead2),
	%nl, write('Statistics after recognition'), nl, printStatistics, 
	%findall(F=V, simpleFPList(_Index, F=V, _, _), FVList), 
	%length(FVList, FVNum),
	%write('Number of simpleFPList in database is: '), write(FVNum), nl,
	%findall((Index, F=V), (indexOf(Index, F=V), retract(processedRangeInit(Index, F=V, _)), retract(processedRangeTerm(Index, F=V, _)), retract(startingPoints(Index, F=V, _)), retract(endingPoints(Index, F=V, _))), _),
	retract(initTime(InitTime)).

processEntity(Index, OE, InitTime, QueryTime) :-
	(
		% compute the intervals of output entities/statically determined fluents
		sDFluent(OE), 
			getCPUtime(Time1sdFluent),
		processSDFluent(Index, OE, InitTime),
			getCPUtime(Time2sdFluent),
			updateTimeTemp(process_sdfluent_time, Time1sdFluent, Time2sdFluent)
		;
		% compute the intervals of simple fluents 
		% (simple fluents are by definition output entities) 
		simpleFluent(OE), 
			OE = (F=_),
			functor(F, FName, _),
			atom_concat(FName, time, OEVariableName),
			atom_concat(FName, instances, OEVarInstName),
			%write(OEVariableName), nl, 
		%write(OE), nl,
			getCPUtime(Time1simpleFluent),
		processSimpleFluent(Index, OE, InitTime, QueryTime),
			getCPUtime(Time2simpleFluent),
			updateTimeTemp(process_simple_fluent_time, Time1simpleFluent, Time2simpleFluent),
			%write(OE), nl,
			(simpleFPList(Index, OE, NewPeriods, BrokenPeriod), 
			%write(NewPeriods), nl,
			%write(BrokenPeriod), nl,
			amalgamatePeriods(BrokenPeriod, NewPeriods, Intervals), length(Intervals, LenIntervals); LenIntervals=0),
			%write(LenIntervals), nl,
			updateVariableTemp(processed_simple_fluents, 1),
			updateTimeTemp(OEVariableName, Time1simpleFluent, Time2simpleFluent),
			updateVariableTemp(OEVarInstName, LenIntervals),
		% CYCLES #2 CHANGE (no need to assert if not cyclic)
		assertCyclic(Index, OE)
		;
		% compute the time-points of output entities/events
		event(OE), 
			getCPUtime(Time1outputevent),
		processEvent(Index, OE),
			getCPUtime(Time2outputevent),
			updateTimeTemp(process_output_event_time, Time1outputevent, Time2outputevent)
	), !.

/******************* deadlines treatment *********************/

% Process deadline attempts computed at the previous query time

% the rule below deals with fluents whose expiration may be extended
% ie maxDurationUE
% keep the happensAt(attempt(F=V),T) computed at the previous query time
% iff (a) holdsAt(F=V,nextTimePoint(Qi-WM)), (b) T>Qi-WM, and (c) T-Duration=<Qi-WM
deadlines1(F=V, Duration, InitTime) :-
	maxDurationUE(F=V, _, Duration), !,
	indexOf(Index, F=V), 
	retract( evTList(Index, attempt(F=V), ListofDeadlineAttempts) ),
	%fetchKey(F=V, Key),
	%recorded(Key, evTList(attempt(F=V), ListofDeadlineAttempts), RevTList), !, 
	%erase(RevTList),
	% (a) holdsAt(F=V,nextTimePoint(Qi-WM))
	simpleFPList(Index, F=V, I1, I2),
	%recorded(Key, simpleFPList(F=V, I1, I2), _), 
	amalgamatePeriods(I2, I1, I),
	nextTimePoint(InitTime, NextInitTime),
	tinIntervals(NextInitTime, I),
	% find the deadline attempt that satisfies conditions (b) and (c) mentioned above
	% this predicate is defined below
	findDeadlineAttempt(ListofDeadlineAttempts, Attempt, InitTime, Duration), 
	%recordz(Key, evTList(attempt(F=V), Attempt), _).
	assert( evTList(Index, attempt(F=V), Attempt) ).
	
% === find the deadline attempt that satisfies conditions (b) and (c) mentioned above	 ===
findDeadlineAttempt([], [], _, _) :- !.	

findDeadlineAttempt([Attempt], [Attempt], InitTime, Duration) :-
	% (b) the deadline attempt time is after Qi-WM
	Attempt>InitTime,
	% (c) the initiating conditions of the deadline attempt
	% are before or on Qi-WM	
	EarlyT is Attempt-Duration, EarlyT=<InitTime, !.

findDeadlineAttempt([_], [], _, _) :- !.	
	
findDeadlineAttempt([A1,A2|_Tail], [A1], InitTime, Duration) :-
	% (b) the deadline attempt time is after Qi-WM
	A1>InitTime,
	% (c) the initiating conditions of the deadline attempt
	% are before or on Qi-WM	
	EarlyT1 is A1-Duration, EarlyT1=<InitTime,
	EarlyT2 is A2-Duration, EarlyT2>InitTime, !.
	
findDeadlineAttempt([_A1,A2|Tail], Attempt, InitTime, Duration) :-
	findDeadlineAttempt([A2|Tail], Attempt, InitTime, Duration).
% === find the deadline attempt that satisfies conditions (b) and (c) mentioned above	 ===


% the rule below deals with fluents whose expiration may NOT be extended
% keep the happensAt(attempt(F=V),T) computed at the previous query time
% iff (a) holdsAt(F=V,nextTimePoint(Qi-WM)), (b) T>Qi-WM, (c) T-Duration=<Qi-WM and
% (d) T-Duration=S where S is the start of the interval starting 
% before or on Qi-WM and ending after for which F=V 
deadlines1(F=V, Duration, InitTime) :-
	indexOf(Index, F=V),
	%fetchKey(F=V, Key), 
	%recorded(Key, evTList(attempt(F=V), ListofDeadlineAttempts), RevTList), !,
	%erase(RevTList),
	retract( evTList(Index, attempt(F=V), ListofDeadlineAttempts) ),	
	% (a) holdsAt(F=V,nextTimePoint(Qi-WM))
	simpleFPList(Index, F=V, I1, I2),
	%recorded(Key, simpleFPList(F=V, I1, I2), _), 
	amalgamatePeriods(I2, I1, I),
	nextTimePoint(InitTime, NextInitTime),
	% we do not use tinIntervals as above because we also want S  
	member((S,E),I), gt(E,NextInitTime), !, S=<NextInitTime,
	member(Attempt, ListofDeadlineAttempts),
	% (b) the deadline attempt time is after Qi-WM
	Attempt>InitTime,
	EarlyT is Attempt-Duration, 
	% (c) the initiating conditions of the deadline attempt
	% are before or on Qi-WM	
	EarlyT=<InitTime,
	% (d) Attempt-Duration=S where S is the start of the interval  
	% starting before or on Qi-WM and ending after for which F=V 
	prevTimePoint(S,PrevS), EarlyT=PrevS, 
	% ListofDeadlineAttempts is sorted
	!,
	%recordz(Key, evTList(attempt(F=V), [Attempt]), _).
	assert( evTList(Index, attempt(F=V), [Attempt]) ).

% deadlines2/1 computes and stores the deadline attempts

% the two rules below deal with fluents whose expiration may be extended

% the rule below deals with the case where there are
% dealine attempts from the previous query time
deadlines2(F=V, Duration, InitTime) :-
	maxDurationUE(F=V, _, Duration),
	indexOf(Index, F=V),
	%fetchKey(F=V, Key), 
	%recorded(Key, evTList(attempt(F=V), List), RevTList), !,
	%erase(RevTList),
	retract( evTList(Index, attempt(F=V), List) ), !,
	startingPoints(Index, F=V, SPoints),
	findall(T, 
		(member(S,SPoints), prevTimePoint(S,PrevS), PrevS>InitTime, T is PrevS+Duration), 
	NewList),
	append(List, NewList, AppendedList),
	% the predicate below is defined in processEvents.prolog
	updateevTList(Index, attempt(F=V), AppendedList).
% the rule below deals with the case where there are NO
% dealine attempts from the previous query time
deadlines2(F=V, Duration, InitTime) :-
	maxDurationUE(F=V, _, Duration), !,
	indexOf(Index, F=V),
	startingPoints(Index, F=V, SPoints),
	findall(T, 
		(member(S,SPoints), prevTimePoint(S,PrevS), PrevS>InitTime, T is PrevS+Duration), 
	NewList),
	% the predicate below is defined in processEvents.prolog
	updateevTList(Index, attempt(F=V), NewList).

% the two rules below deal with fluents whose expiration may NOT be extended

% the rule below deals with the case where there are
% dealine attempts from the previous query time
deadlines2(F=V, Duration, InitTime) :-
	indexOf(Index, F=V),
	%fetchKey(F=V, Key), 
	%recorded(Key, evTList(attempt(F=V), List), RevTList), !,
	%erase(RevTList),
	retract( evTList(Index, attempt(F=V), List) ), !,
	simpleFPList(Index, F=V, I1, I2),
	%write('In deadlines2 for FVP:'), write(F=V), nl,
	%recorded(Key, simpleFPList(F=V, I1, I2), _),
	amalgamatePeriods(I2, I1, I),
	%write('Periods I:'), write(I), nl,
	findall(T, 
		(member((S,_),I), prevTimePoint(S,PrevS), PrevS>InitTime, T is PrevS+Duration), 
	NewList),
	append(List, NewList, AppendedList),
	% the predicate below is defined in processEvents.prolog
	updateevTList(Index, attempt(F=V), AppendedList).
% the rule below deals with the case where there are NO
% dealine attempts from the previous query time
deadlines2(F=V, Duration, InitTime) :-
	indexOf(Index, F=V),
	simpleFPList(Index, F=V, I1, I2),
	%write('In deadlines2 for FVP:'), write(F=V), nl,
	%write('Periods I:'), write(I), nl,
	%fetchKey(F=V, Key), 
	%recorded(Key, simpleFPList(F=V, I1, I2), _), 
	amalgamatePeriods(I2, I1, I),
	findall(T, 
		(member((S,_),I), prevTimePoint(S,PrevS), PrevS>InitTime, T is PrevS+Duration), 
	NewList),
	% the predicate below is defined in processEvents.prolog
	updateevTList(Index, attempt(F=V), NewList).


/******************* cycles treatment *********************/

prepareCyclic :-
	% check if there are cycles in the event description
	cyclic(_), !,
	findall((Index,F=V,L), (storedCyclicPoints(Index,F=V,L), retract(storedCyclicPoints(Index,F=V,L))), _),
	findall((Index,F=V), (processedCyclic(Index,F=V), retract(processedCyclic(Index,F=V))), _),
	findall(F=V, (initiallyCyclic(F=V), retract(initiallyCyclic(F=V))), _),
	assertInitiallyCyclic.
prepareCyclic.

assertInitiallyCyclic :-
	initTime(InitTime),
	InitTime>0, !, 
	%nextTimePoint(InitTime, NextInitTime),
	findall(F=V, 
	  (
	    cyclic(F=V),
	    indexOf(Index, F=V),
		simpleFPList(Index, F=V, I1, I2),
		%fetchKey(F=V, Key),
		%recorded(Key, simpleFPList(F=V, I1, I2), _),
	    amalgamatePeriods(I2, I1, I),
	    tinIntervals(InitTime, I),
	    assert(initiallyCyclic(F=V)), 
	     % New code 
	  	indexOf(Index, F=V), 
	  	addStartingPointAllVals(Index, F=V, InitTime),
	  	addCyclicPointAllFVPs(Index, F=V, InitTime, t)
	  	%addCyclicPointAllFVPs(Index, F=V, NextInitTime, t)
	  	%(simpleFluent(F=V2), \+V2=V, 
	  	%	indexOf(Index2, F=V2), 
	  	%	addCyclicPoint(Index2, F=V2, InitTime, f),
	  	%	addCyclicPoint(Index2, F=V2, NextInitTime, f)
	  	%;
	  	% true)
	  	),
	  	% New code end), 
	  _).
assertInitiallyCyclic :-
	 % InitTime=<0
	 findall(F=V, 
	  (
	    cyclic(F=V),
	    grounding(F=V),
	    %initially(F=V),
	    initiatedAt(F=V, 0, 0, 1),
	    %initially(F=V),
	    assert(initiallyCyclic(F=V)),
	    % New code 
	  	indexOf(Index, F=V), 
	  	addStartingPointAllVals(Index, F=V, 0),
	  	addCyclicPointAllFVPs(Index, F=V, 0, t)
	  	%addCyclicPointAllFVPs(Index, F=V, 1, t)
	  	%(simpleFluent(F=V2), \+V2=V, 
	  	%	indexOf(Index2, F=V2), 
	  	%	addCyclicPoint(Index2, F=V2, 0, f),
	  	%	addCyclicPoint(Index2, F=V2, 1, f)
	  	%;
	  	% true)
	  	),
	  	% New code end
	  _).
	  
assertCyclic(Index, F=V) :- 
	  cyclic(F=V), !,
	  assert(processedCyclic(Index, F=V)).
assertCyclic(_, _).

%========

% T is ground when evaluating holdsAt
% if the intervals of the cyclic fluent have been already computed then look no further
holdsAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V), !,
	holdsAtProcessedSimpleFluent(Index, F=V, T).

% check whether we already know whether holdsAt(F=V, T)
holdsAtCyclic(Index, F=V, T) :-
	% storedSFPoints stores some, but not necessarily all points of a cyclic fluent
	% therefore, the cut in this rule has to go the end 
	storedCyclicPoints(Index, F=V, StoredPoints),
	%write('\t\tT='), write(T), write(', '),
	%write(F=V), write(' Stored: '), write(StoredPoints), nl,
	lastPointBeforeOrOnT(T, StoredPoints, (Point,Val)), !, 
	%write('Last Point Before or on '), write(T), write(' is '), write((Point, Val)), nl,
	findFluentVal(Index, F=V, T, (Point,Val)).

% the rule below are classic EC simple fluent computation
holdsAtCyclic(Index, F=V, T) :-
	initTime(InitTime), 
		%write('Checking initPointBetween..'),nl,
	initPointBetween(Index, F=V, InitTime, InitPoint, T),
		%write('Passed for Time-point: '), write(InitPoint), nl,
	nextTimePoint(InitPoint, NextPoint),
	addCyclicPointAllFVPs(Index, F=V, NextPoint, t),
		%write('Checking notBrokenOrReInitiated... '), nl,
	notBrokenOrReInitiated(Index, F=V, NextPoint, T),
		%write('Passed... '), nl,
	% since we computed a time-point for the cyclic fluent we store it 
	% in order to avoid recomputing it in the future
	addCyclicPointAllFVPs(Index, F=V, T, t), !.

% store that we failed to prove holdsAt(F=V, T)
holdsAtCyclic(Index, F=V, T) :-
	addCyclicPointAllFVPs(Index, F=V, T, f), !, false.

%========
/*
holdsAtCyclicLimits(Index, F=V, T1, T, T2):-
 	holdsAtCyclicLimits0(Index, F=V, T1, T2, TList), 
 	member(T, TList).

holdsAtCyclicLimits0(_Index, _U, T1, T2, []):-
	T1>T2.

holdsAtCyclicLimits0(Index, F=V, T1, T2, [T1|TList]):-
	holdsAtCyclic(Index, F=V, T1), !,
	nextTimePoint(T1, T1next),
	holdsAtCyclicLimits0(Index, F=V, T1next, T2, TList).

holdsAtCyclicLimits0(Index, F=V, T1, T2, TList):-
	nextTimePoint(T1, T1next),
	holdsAtCyclicLimits0(Index, F=V, T1next, T2, TList).

computeHoldsIncremental(Index, F=V, (T1, Val), T2, TermList):-
	nextTimePoint(T1, T1next),
	computeHoldsIncremental(Index, F=V, (T1next, Val), T2, TermList).
*/
/*
% T is ground when evaluating holdsAt
% if the intervals of the cyclic fluent have been already computed then look no further
holdsAtCyclicLimits(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	holdsAtProcessedSimpleFluent(Index, F=V, T), T>=T1, T2>T.

% check whether we already know whether holdsAt(F=V, T)
holdsAtCyclicLimits(Index, F=V, T1, T, T2) :-
	% storedSFPoints stores some, but not necessarily all points of a cyclic fluent
	% therefore, the cut in this rule has to go the end 
	storedCyclicPoints(Index, F=V, StoredPoints),
	largestStoredPoint(StoredPoints, (LSPoint, _)),
	LSPoint>=T2, !,
	member((T, t), StoredPoints), T>=T1, T<T2. 
	%lastPointBeforeOrOnT(T, StoredPoints, (Point,Val)), !, 
	%%write('Last Point Before or on '), write(T), write(' is '), write((Point, Val)), nl,
	%findFluentVal(Index, F=V, T, (Point,Val)).

% check whether we already know whether holdsAt(F=V, T)
holdsAtCyclicLimits(Index, F=V, T1, T, T2) :-
	% storedSFPoints stores some, but not necessarily all points of a cyclic fluent
	% therefore, the cut in this rule has to go the end 
	storedCyclicPoints(Index, F=V, StoredPoints),
	largestStoredPoint(StoredPoints, (LSPoint, Val)),
	LSPoint>T1, LSPoint<T2, !,
	(member((T, t), StoredPoints), T>=T1, T<T2 ; computeHoldsIncremental(Index, F=V, (LSPoint, Val), T2, HoldsList), member(T, HoldsList)).

holdsAtCyclicLimits(Index, F=V, T1, T, T2):-
	storedCyclicPoints(Index, F=V, StoredPoints),
	%write('\t\tstoredCyclicPoints: '), write(StoredPoints), nl,
	%write('T1='), write(T1), write(' T2='), write(T2), nl,
	largestStoredPoint(StoredPoints, (LSPoint, _Val)),
	%write('LSPoint='), write(LSPoint), nl,
	LSPoint=<T1, !,
	%write('\t\tLSPoint=<T1'), nl,
	computeHoldsIncremental(Index, F=V, T1, T2, HoldsList),
	%write('\t\tInitList='), write(InitList), nl,
	member(T, HoldsList).

holdsAtCyclicLimits(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	\+ storedCyclicPoints(Index, F=V, _StoredPoints), 
	%write('No stored points!'), nl,
	computeHoldsIncremental(Index, F=V, T1, T2, HoldsList),
	member(T, HoldsList).

computeHoldsIncremental(Index, F=V, (T1, t), T2, [T1|Tail]):-
	%write('\t\t\t EndPoints: '), write(T1), write(' '), write(T2), nl,
	nextTimePoint(T1, T1next),
	terminatedAt(F=V, T1, T1, T1next), !,
	%write('\t\t\tinitiation point: '), write(T1), nl,
	%nextTimePoint(T, Tnext),
	addCyclicPoint(Index, F=V, T1next, f),
	computeHoldsIncremental(Index, F=V, (T1next, f), T2, Tail).

computeHoldsIncremental(Index, F=V, (T1, t), T2, [T1|Tail]):-
	%write('\t\t\t EndPoints: '), write(T1), write(' '), write(T2), nl,
	nextTimePoint(T1, T1next),
	initiatedAt(F=V2, T1, T1, T1next), !,
	%nextTimePoint(T, Tnext),
	indexOf(Index2, F=V2),
	addCyclicPoint(Index2, F=V2, T1next, t),
	%write('\t\t\tcached starting point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl,
	simpleFluent(F=V3), \+V3=V2,
	indexOf(Index3, F=V3),
	addCyclicPoint(Index3, F=V3, T1next, f), 
	computeHoldsIncremental(Index, F=V, (T1next, f), T2, Tail).

computeHoldsIncremental(Index, F=V, (T1, f), T2, [T1|Tail]):-
	%write('\t\t\t EndPoints: '), write(T1), write(' '), write(T2), nl,
	nextTimePoint(T1, T1next),
	initiatedAt(F=V2, T1, T1, T1next), !,
	%write('\t\t\tcached starting point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl,
	addCyclicPoint(Index, F=V, T1next, t),
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addCyclicPoint(Index2, F=V2, T1next, f), 
	computeHoldsIncremental(Index, F=V, (T1next, t), T2, Tail).

computeHoldsIncremental(Index, F=V, (T1, Val), T2, TermList):-
	nextTimePoint(T1, T1next),
	computeHoldsIncremental(Index, F=V, (T1next, Val), T2, TermList).
*/
%========
/*
startCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((T,_E), Tail), T>=T1, T<T2.

startCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((T,_E), [H|Tail]), T>=T1, T<T2.

startCyclic(Index, F=V, T1, T, T2) :-
	storedCyclicPoints(Index, F=V, StoredPoints),
	%write('\t\t\tstoredCyclicPoints: '), write(StoredPoints), nl,
	intervalsFromStoredPoints(StoredPoints, -1, Intervals),
	%write('\t\t\tresp. Intervals: '), write(Intervals), nl,
	member((T, _E), Intervals), T>=T1, T<T2, !.

startCyclic(Index, F=V, T1, T, T2):-
	prevTimePoint(T, Tprev),
	initiatedAt(F=V, T1, Tprev, T2),
	addCyclicPoint(Index, F=V, T, t).
	%write('\t\t\tcached cyclic point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl.
*/
%========
/*
initiatedAtCyclic(Index, F=V, T):-
	write('initiatedAtCyclic3'),nl,	
	write(T), nl,
	\+ holdsAtCyclic(Index, F=V, T),
	nextTimePoint(T, Tnext),
	holdsAtCyclic(Index, F=V, Tnext).

initiatedAtCyclic(_, _, Ts, _, Te):-
	write('initiatedAtCyclic'), Ts>Te, write('done'), nl, fail, !.

initiatedAtCyclic(Index, F=V, Ts, Ts, _Te):-
	write('initiatedAtCyclic'),nl,
	initiatedAtCyclic(Index, F=V, Ts), !.

initiatedAtCyclic(Index, F=V, Ts, T, Te):-
	write('initiallyCyclic'), nl,
	nextTimePoint(Ts, TsNext), 
	write(Ts), write(' '), write(TsNext), nl,
	initiatedAtCyclic(Index, F=V, TsNext, T, Te).
*/
/*
initiatedAtPrev(Index, F=V, T1, T, T2):-
	prevTimePoint(T1, T1prev), 
	prevTimePoint(T2, T2prev),
	initiatedAtCyclic(Index, F=V, T1prev, T, T2prev).
*/

initiatedAtPrev(Index, F=V, T1, T, T2) :-
	Duration=1,
	EarlierT2 is T2-Duration, 
	initTime(InitTime), 
	EarlierT2>InitTime,
	T1MinusDuration is T1-Duration, 
	
	% EarlierT1 = max(InitTime+1, T1MinusDuration)
	calcEarlyBoundary(InitTime, T1MinusDuration, EarlierT1),

	% sanity check:
	EarlierT2>EarlierT1,
        % the disjunction below computes the initiation point of F=V
	(
            % for cyclic fluents we cannot restrict attention to stored starting points
            % we have to also evaluate initiatedAt 
            cyclic(F=V),
            %write('\tinitiatedAtCyclic('), write(F=V), write(') between '), write(EarlierT1), write(' and '), write(EarlierT2), write(' ? '), nl,
            initiatedAtCyclic(Index, F=V, EarlierT1, EarlierT, EarlierT2)
            %initiatedAt(F=V, EarlierT1, EarlierT, EarlierT2)
            %write('\tinitiatedAtCyclic('), write(F=V), write(') at '), write(EarlierT), nl
 
            % it proved insufficient to store the above starting point
            ;
            \+ cyclic(F=V),
            % instead of evaluating initiatedAt, look for cached starting points 
            startingPoints(Index, F=V, SPoints), 
            member(EarlierTNext, SPoints), 
            prevTimePoint(EarlierTNext, EarlierT) 
	),
	% make sure that the initiating point in within the correct range
	EarlierT1=<EarlierT, EarlierT<EarlierT2,		
	%nextTimePoint(EarlierT, NextEarlierT),
	T is EarlierT+Duration.
	%deadlineConditions(Index, F=V, NextEarlierT, T).

/*
%% only if the time-point under consideration has been processed.
initiatedAtPrev(Index, F=V, T1, S, T2):- %%% we return the time-point after the initiation point here.
	processedRangeInit(Index, F=V, ProcessedRange),	
	relative_complement_all([(T1,T2)], [ProcessedRange], []), !,
	%write('Relative Complement Empty!'), nl,
	startingPoints(Index, F=V, SPoints),
	%write('Starting Points Cached!'), nl,
	member(S, SPoints), S>=T1, S<T2.

initiatedAtPrev(Index, F=V, T1, S, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), 
	%write('UnprocessedIntervals: '), write(UnprocessedIntervals), nl,
	startingPoints(Index, F=V, SPoints), !,
	(member(S, SPoints), S>=T1, S<T2 ; checkInitiatedAtAll(F=V, UnprocessedIntervals, InitList), member(T, InitList), nextTimePoint(T, S), S>=T1, S<T2).

initiatedAtPrev(Index, F=V, T1, S, T2):-
	\+ processedRangeInit(Index, F=V, _), !,
	checkInitiatedAt(F=V, T1, T2, InitList), member(T, InitList), nextTimePoint(T, S), S>=T1, S<T2.
*/
initiatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic1'), nl,
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((S,_E), Tail),	
	prevTimePoint(S, T). %, T>=T1, T<T2.

initiatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V), !,
		%write('\t\t\t\tprocessedCyclic2'), nl,
	simpleFPList(Index, F=V, [H|Tail], []),
		%write('\t\t\t\tList: '), write([H|Tail]), nl,
	member((S,_E), [H|Tail]), 
		%\+E=inf,
	prevTimePoint(S, T). %, T>=T1, T<T2.

initiatedAtCyclic(Index, F=V, T) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeInit(Index, F=V, ProcessedRange),
		%write('\t\t\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
	%largestStoredPoint(SPoints, LSPoint),
	%T=<Thigh, T>=Tlow, !,
	tinIntervals(T, ProcessedRange), !,
	startingPoints(Index, F=V, SPoints),
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(S, SPoints),
	prevTimePoint(S, T). %, T>=T1, T<T2.

initiatedAtCyclic(_Index, F=V, T):-
	%write('checking termination at '), write(T), nl, 
	%computeInitiationsIncremental(F=V, T, T, InitList), 
	nextTimePoint(T, Tnext),
	checkInitiatedAt(F=V, T, Tnext, InitList), member(T, InitList).
	%write('TermList: '), write(TermList), nl,
	%member(T, InitList).

/*
initiatedAtCached(F=V, T1, T, T2):-
	indexOf(Index, F=V),
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((S,_E), Tail), 
	prevTimePoint(S, T), T>=T1, T<T2.

initiatedAtCached(F=V, T1, T, T2):-
	indexOf(Index, F=V),
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((S,_E), [H|Tail]), 
	prevTimePoint(S, T), T>=T1, T<T2.

initiatedAtCached(F=V, T1, T, T2):-
	indexOf(Index, F=V),
	startingPoints(Index, F=V, SPoints),
	member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2. 

initiatedAtCached(F=V, T1, T, T2):-
	indexOf(Index, F=V), 
	initiatedAt(F=V, T1, T, T2),
	addStartingPointAllVals(Index, F=V, T).
*/

initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((S,_E), Tail), 
	prevTimePoint(S, T), T>=T1, T<T2.

initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((S,_E), [H|Tail]), 
	prevTimePoint(S, T), T>=T1, T<T2.

initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], []), !,
	%write('Relative Complement Empty!'), nl,
	startingPoints(Index, F=V, SPoints),
	%write('Starting Points Cached!'), nl,
	member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2.
	%checkInitiatedAt(F=V, T1, T2, InitList), member(T, InitList), T>=T1, T<T2. 

/*
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeInit(Index, F=V, [_Tlow, Thigh]),
	T1>Thigh, !, 
	checkInitiatedAt(F=V, T1, T, T2), T>=T1, T<T2. 
*/

initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), 
	%write('UnprocessedIntervals: '), write(UnprocessedIntervals), nl,
	startingPoints(Index, F=V, SPoints), !,
	(member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2 ; checkInitiatedAtAll(F=V, UnprocessedIntervals, InitList), member(T, InitList), T>=T1, T<T2).

initiatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), !,
	%write('UnprocessedIntervals: '), write(UnprocessedIntervals), nl,
	\+ startingPoints(Index, F=V, _SPoints),
	checkInitiatedAtAll(F=V, UnprocessedIntervals, InitList), member(T, InitList), T>=T1, T<T2.
	%computeInitiationsIncremental(F=V, T1, T2, InitList),
	%member(T, InitList).

initiatedAtCyclic(Index, F=V, T1, T, T2):-
	\+ processedRangeInit(Index, F=V, _), !,
	checkInitiatedAt(F=V, T1, T2, InitList), member(T, InitList), T>=T1, T<T2. 

/*
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	startingPoints(Index, F=V, SPoints),
	processedRange(Index, F=V, [Tlow, Thigh]),
		%write('\t\tstartingPoints of '), write(F=V), write(': '), write(SPoints), nl,
		%write('\t\tT1='), write(T1), write(' T2='), write(T2), nl,
	%largestStoredPoint(SPoints, LSPoint),
	%largestStoredPoint(StoredPoints, (LSPoint, _)),
		%write('\t\tLSPoint='), write(LSPoint), nl,
	%LSPoint>=T2, !,
	T1>=Tlow,
	T2=<Thigh, !,
	%LastProcessedPoint>=T2, !,
		%write('\t\tLSPoint>=T2'), nl,
	member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2. 
	%findAllStoredInitPointsBetweenDesc(StoredPoints, T1, T2, InitList),
	%findall(Tinit, (member((S, t), StoredPoints), prevTimePoint(S, Tinit), Tinit>=T1, Tinit<T2), InitList),
	%write('\t\tInitList = '), write(InitList), nl,
	%member(T, InitList).

initiatedAtCyclic(Index, F=V, T1, T, T2):-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	startingPoints(Index, F=V, SPoints, LastProcessedPoint),
		%write('\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
		%write('\t\tT1='), write(T1), write(' T2='), write(T2), nl,
	%largestStoredPoint(StoredPoints, (LSPoint, _)),
	%largestStoredPoint(SPoints, LSPoint),
		%write('\t\tLSPoint='), write(LSPoint), nl,
	LastProcessedPoint>T1, LastProcessedPoint<T2, !,
	%write('\t\tLSPoint>T1 && LSPoint<T2'), nl,
	%findAllStoredInitPointsBetweenDesc(StoredPoints, T1, T2, InitList0),
	%(member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2 ; computeInitiationsIncremental(F=V, LSPoint, T2, InitList), member(T, InitList), T>=T1, T<T2).
	(member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2 ; checkInitiatedAt(F=V, LastProcessedPoint, T, T2)).
	%findall(Tinit, (member((S, t), StoredPoints), prevTimePoint(S, Tinit), Tinit>=T1, Tinit<T2), InitList0),
	%write('\t\tCalling computeInitiationsIncremental '), write(F=V), nl,

initiatedAtCyclic(Index, F=V, T1, T, T2):-
	startingPoints(Index, F=V, _SPoints, LastProcessedPoint),
		%write('\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
		%write('\t\tT1='), write(T1), write(' T2='), write(T2), nl,
	%largestStoredPoint(SPoints, LSPoint),
		%write('\t\tLSPoint='), write(LSPoint), nl,
	LastProcessedPoint=<T1, !,
	%write('\t\tLSPoint=<T1'), nl,
	checkInitiatedAt(F=V, LastProcessedPoint, T, T2), T>=T1, T<T2. 
	%computeInitiationsIncremental(F=V, T1, T2, InitList), 
	%write('\t\tInitList='), write(InitList), nl,
	%member(T, InitList).

initiatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	%\+ storedCyclicPoints(Index, F=V, _StoredPoints), 
	\+ startingPoints(Index, F=V, _SPoints, _LPPoint),
	initTime(InitTime),
	%write('No stored points!'), nl,
	checkInitiatedAt(F=V, InitTime, T, T2), T>=T1, T<T2.
	%computeInitiationsIncremental(F=V, T1, T2, InitList),
	%member(T, InitList).
*/

checkInitiatedAt(F=V, T1, T, T2):-
	initiatedAt(F=V, T1, T, T2), T>=T1, T<T2,
	indexOf(Index, F=V),
	addStartingPointAllVals(Index, F=V, T, T),
	nextTimePoint(T, Tnext),
	addCyclicPointAllFVPs(Index, F=V, Tnext, t),
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addCyclicPointAllFVPs(Index2, F=V2, Tnext, f), 
	addEndingPoint(Index2, F=V2, T).

checkInitiatedAt(F=V, T1, T, T2):-
	\+ initiatedAt(F=V, T1, T, T2), T>=T1, T<T2,
	indexOf(Index, F=V),
	addLastProcessedPointSP(Index, F=V, T), fail.
	/*
	nextTimePoint(T, Tnext),
	addCyclicPointAllFVPs(Index, F=V, Tnext, t),
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addCyclicPointAllFVPs(Index2, F=V2, Tnext, f), 
	addEndingPoint(Index2, F=V2, T). */

checkInitiatedAtAll(F=V, Ranges, FlatInits):-
	%write('Ranges: '), write(Ranges), nl,
	checkInitiatedAtAll0(F=V, Ranges, Inits),
	%write('Inits: '), write(Inits), nl,
	flatten(Inits, FlatInits).
	%write('FlatInits: '), write(FlatInits), nl.

checkInitiatedAtAll0(_, [], []).

checkInitiatedAtAll0(F=V, [(T1, T2)|RestRanges], [Inits|RestInits]):-
	%write('checking initiations between '), write(T1), write(' and '), write(T2), nl,
	checkInitiatedAt(F=V, T1, T2, Inits),
	%write('my inits: '), write(Inits), nl, 
	checkInitiatedAtAll0(F=V, RestRanges, RestInits).


checkInitiatedAt(F=V, T1, T2, InitList):-
	computeInitiationsIncremental(F=V, T1, T2, InitList). %, member(T, InitList).

computeInitiationsIncremental(_, T1, T2, []):-
	T1>=T2, !.

computeInitiationsIncremental(F=V, T1, T2, [T1|Tail]):-
	nextTimePoint(T1, T1next),
	initiatedAt(F=V, T1, T1, T1next), !,
	%write('\t\t\tinitiation point: '), write(T1), nl,
	indexOf(Index, F=V),
	addStartingPointAllVals(Index, F=V, T1),
	addCyclicPointAllFVPs(Index, F=V, T1next, t),
	%write('\t\t\tcached starting point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl,
	%simpleFluent(F=V2), \+V2=V,
	%indexOf(Index2, F=V2),
	%addCyclicPointAllFVPs(Index2, F=V2, T1next, f), 
	%addEndingPoint(Index2, F=V2, T1, T1),
	computeInitiationsIncremental(F=V, T1next, T2, Tail).

computeInitiationsIncremental(F=V, T1, T2, InitList):-
	nextTimePoint(T1, T1next),
	indexOf(Index, F=V),
	addProcessedRangeInit(Index, F=V, T1),
	%addLastProcessedPointSP(Index, F=V, T1),
	computeInitiationsIncremental(F=V, T1next, T2, InitList).

/*
findAllStoredInitPointsBetweenDesc([], _T1, _T2, []).

findAllStoredInitPointsBetweenDesc([(S, _)|_RestStored], T1, _T2, []):-
	prevTimePoint(S, T), T<T1, !.

findAllStoredInitPointsBetweenDesc([(S, t)|RestStored], T1, T2, [T|RestInitList]):-
	prevTimePoint(S, T), T<T2, T>=T1, !,
	findAllStoredInitPointsBetweenDesc(RestStored, T1, T2, RestInitList).

findAllStoredInitPointsBetweenDesc([_|RestStored], T1, T2, InitList):-
	findAllStoredInitPointsBetweenDesc(RestStored, T1, T2, InitList).

	%findall(Tinit, (member((S, t), StoredPoints), prevTimePoint(S, Tinit), Tinit>=T1, Tinit<T2), InitList),

findAllStoredTermPointsBetweenDesc([], _T1, _T2, []).

findAllStoredTermPointsBetweenDesc([(S, _)|_RestStored], T1, _T2, []):-
	prevTimePoint(S, T), T<T1, !.

findAllStoredTermPointsBetweenDesc([(_, t)|RestStored], T1, T2, TermList):-
	!, findAllStoredTermPointsBetweenDesc(RestStored, T1, T2, TermList).

findAllStoredTermPointsBetweenDesc([(S, f)|RestStored], T1, T2, TermList):-
	prevTimePoint(S, T), T>=T2, !, 
	findAllStoredTermPointsBetweenDesc(RestStored, T1, T2, TermList).

findAllStoredTermPointsBetweenDesc([(S, f)|RestStored], T1, T2, [T|RestTermList]):-
	prevTimePoint(S, T), T<T2, T>=T1,
	findAllStoredTermPointsBetweenDesc(RestStored, T1, T2, RestTermList).
*/

%largestStoredPoint([(T, Val)], (T, Val)).
largestStoredPoint([T], T).

largestStoredPoint([_H1, H2|T], LSPoint):-
	largestStoredPoint([H2|T], LSPoint).

%largestStoredPointDesc([(T, _)|_], T).

%========
/*
endCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((_S,T), Tail), T>=T1, T<T2.

endCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((_S,T), [H|Tail]), T>=T1, T<T2.

endCyclic(Index, F=V, T1, T, T2) :-
	storedCyclicPoints(Index, F=V, StoredPoints),
	%write('\t\t\tstoredCyclicPoints: '), write(StoredPoints), nl,
	intervalsFromStoredPoints(StoredPoints, -1, Intervals),
	%write('\t\t\tresp. Intervals: '), write(Intervals), nl,
	member((_S, T), Intervals), T>=T1, T<T2, !.

endCyclic(Index, F=V, T1, T, T2):-
	prevTimePoint(T, Tprev),
	broken(F=V, T1, Tprev, T2),
	addCyclicPoint(Index, F=V, T, f).
	%write('\t\t\tcached cyclic point for '), write(F=V), write(' at '), write(T), write(' with value "f"'), nl.
*/
/*
terminatedAtCyclic(Index, F=V, T):-
	holdsAtCyclic(Index, F=V, T),
	nextTimePoint(T, Tnext),
	\+ holdsAtCyclic(Index, F=V, Tnext).

terminatedAtCyclic(_, _, Ts, _, Te):-
	Ts>Te, !, fail.

terminatedAtCyclic(Index, F=V, Ts, Ts, _Te):-
	terminatedAtCyclic(Index, F=V, Ts), !.

terminatedAtCyclic(Index, F=V, Ts, T, Te):-
	nextTimePoint(Ts, TsNext), 
	terminatedAtCyclic(Index, F=V, TsNext, T, Te).
*/

terminatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic1'), nl,
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((_S,E), Tail),
		\+E=inf,	
	prevTimePoint(E, T). %, T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V), !,
		%write('\t\t\t\tprocessedCyclic2'), nl,
	simpleFPList(Index, F=V, [H|Tail], []),
		%write('\t\t\t\tList: '), write([H|Tail]), nl,
	member((_S,E), [H|Tail]), 
		\+E=inf,
	prevTimePoint(E, T). %, T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, ProcessedRange),
		%write('\t\t\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
	%largestStoredPoint(SPoints, LSPoint),
	%T=<Thigh, T>=Tlow, !,
	tinIntervals(T, ProcessedRange), !,
	endingPoints(Index, F=V, EPoints),
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(E, EPoints),
	prevTimePoint(E, T). %, T>=T1, T<T2.

terminatedAtCyclic(_Index, F=V, T):-
	%write('checking termination at '), write(T), nl, 
	%computeInitiationsIncremental(F=V, T, T, InitList), 
	nextTimePoint(T, Tnext),
	checkTerminatedAt(F=V, T, Tnext, TermList), member(T, TermList).
	%write('TermList: '), write(TermList), nl,
	%member(T, InitList).

/*
terminatedAtCyclic(Index, F=V, T) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, [Tlow, Thigh]),
		%write('\t\t\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
	%largestStoredPoint(SPoints, LSPoint),
	T=<Thigh, T>=Tlow, !,
	endingPoints(Index, F=V, EPoints),
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(E, EPoints),
	prevTimePoint(E, T). %, T>=T1, T<T2.

terminatedAtCyclic(_Index, F=V, T):-
	%write('checking termination at '), write(T), nl, 
	%computeInitiationsIncremental(F=V, T, T, InitList), 
	nextTimePoint(T, Tnext),
	checkTerminatedAt(F=V, T, _, Tnext).
	%write('TermList: '), write(TermList), nl,
	%member(T, InitList).
	*/

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((_S,E), Tail), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((_S,E), [H|Tail]), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], []), !,
	endingPoints(Index, F=V, EPoints),
	member(E, EPoints), prevTimePoint(E, T), T>=T1, T<T2.
	%checkTerminatedAt(F=V, T1, T2, TermList), member(T, TermList), T>=T1, T<T2. 

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), 
	endingPoints(Index, F=V, EPoints), !,
	(member(E, EPoints), prevTimePoint(E, T), T>=T1, T<T2 ; checkTerminatedAtAll(F=V, UnprocessedIntervals, TermList), member(T, TermList)).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), !,
	\+ endingPoints(Index, F=V, _EPoints),
	checkTerminatedAtAll(F=V, UnprocessedIntervals, TermList), 
	member(T, TermList), T>=T1, T<T2.
	%computeInitiationsIncremental(F=V, T1, T2, InitList),
	%member(T, InitList).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	\+ processedRangeTerm(Index, F=V, _), !,
	checkTerminatedAt(F=V, T1, T2, TermList), member(T, TermList), T>=T1, T<T2. 

/*
terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, [Tlow, _Thigh]),
	T2<Tlow, !, 
	checkTerminatedAt(F=V, T1, T, T2), T>=T1, T<T2. 

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, [_Tlow, Thigh]),
	T1>Thigh, !, 
	checkTerminatedAt(F=V, T1, T, T2), T>=T1, T<T2. 

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, [Tlow, Thigh]),
	endingPoints(Index, F=V, EPoints), !,
	(member(E, EPoints), prevTimePoint(E, T), T>=T1, T<T2 ; checkTerminatedAt(F=V, T1, T, Tlow) ; checkTerminatedAt(F=V, Thigh, T, T2)).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	processedRangeTerm(Index, F=V, [Tlow, Thigh]),
	\+ endingPoints(Index, F=V, _EPoints), !,
	(checkTerminatedAt(F=V, T1, T, Tlow) ; checkTerminatedAt(F=V, Thigh, T, T2)).
	%computeInitiationsIncremental(F=V, T1, T2, InitList),
	%member(T, InitList).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	\+ processedRangeTerm(Index, F=V, _), !,
	checkTerminatedAt(F=V, T1, T, T2), T>=T1, T<T2. 
*/

/*
terminatedAtCyclic(Index, F=V, T) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%endingPoints(Index, F=V, EPoints, LPPoint),
		%write('\t\t\t\tendingPoints of '), write(F=V), write(' : '), write(EPoints), nl,
	%largestStoredPoint(EPoints, LEPoint),
	LPPoint>=T, !,
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(E, EPoints),
	prevTimePoint(E, T). %, T>=T1, T<T2.

terminatedAtCyclic(_Index, F=V, T):-
	%write('checking termination at '), write(T), nl, 
	nextTimePoint(T, Tnext),
	checkTerminatedAt(F=V, T, _, Tnext).
	%computeTerminationsIncremental(F=V, T, T, TermList), 
	%write('TermList: '), write(TermList), nl,
	%member(T, TermList).

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), !,
	member((_S,E), Tail), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V), !,
	simpleFPList(Index, F=V, [H|Tail], []),
	member((_S,E), [H|Tail]), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%endingPoints(Index, F=V, EPoints, LPPoint),
		%write('\t\tendingPoints of '), write(F=V), write(' : '), write(EPoints), nl,
	%largestStoredPoint(EPoints, LEPoint),
	processedRange(Index, F=V, [Tlow, _Thigh]),
	T2<Tlow, !, 
	%LPPoint>=T2, !,
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(E, EPoints),
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	endingPoints(Index, F=V, EPoints, LastProcessedPoint),
		%write('\t\tendingPoints of '), write(F=V), write(' : '), write(EPoints), nl,
	%largestStoredPoint(EPoints, LEPoint),
	LastProcessedPoint>T1, LastProcessedPoint<T2, !,
	(member(S, EPoints), prevTimePoint(S, T), T>=T1, T<T2 ; checkTerminatedAt(F=V, LastProcessedPoint, T, T2)).
	%(member(S, EPoints), prevTimePoint(S, T), T>=T1, T<T2 ; computeTerminationsIncremental(F=V, LEPoint, T2, TermList), member(T, TermList)).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	endingPoints(Index, F=V, _EPoints, LastProcessedPoint),
		%write('\t\tendingPoints of '), write(F=V), write(' : '), write(EPoints), nl,
	%largestStoredPoint(EPoints, LEPoint),
	LastProcessedPoint=<T1, !,
	checkTerminatedAt(F=V, LastProcessedPoint, T, T2), T>=T1, T<T2. 
	%computeTerminationsIncremental(F=V, T1, T2, TermList),
	%member(T, TermList).

termiatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	%\+ storedCyclicPoints(Index, F=V, _StoredPoints), 
	\+ endingPoints(Index, F=V, _EPoints, _LPPoint),
	%write('No stored points!'), nl,
	initTime(InitTime),
	%write('No stored points!'), nl,
	checkTerminatedAt(F=V, InitTime, T, T2), T>=T1, T<T2.
	%computeTerminationsIncremental(F=V, T1, T2, TermList),
	%member(T, TermList).
*/
/*
checkTerminatedAt(F=V, T1, T, T2):-
	terminatedAt(F=V, T1, T, T2), T>=T1, T<T2,
	indexOf(Index, F=V),
	nextTimePoint(T, Tnext),
	addCyclicPointAllFVPs(Index, F=V, Tnext, f), 
	addEndingPoint(Index, F=V, T, T).

checkTerminatedAt(F=V, T1, T, T2):-
	simpleFluent(F=V2), \+V2=V, 
	initiatedAt(F=V2, T1, T, T2), T>=T1, T<T2,
	indexOf(Index2, F=V2),
	addStartingPointAllVals(Index2, F=V2, T),
	nextTimePoint(T, Tnext),
	addCyclicPointAllFVPs(Index2, F=V2, Tnext, t),
	simpleFluent(F=V3), \+V3=V2,
	indexOf(Index3, F=V3),
	addCyclicPointAllFVPs(Index3, F=V3, Tnext, f), 
	addEndingPoint(Index3, F=V3, T, T).
*/

checkTerminatedAtAll(F=V, Ranges, FlatTerms):-
	checkTerminatedAtAll0(F=V, Ranges, Terms),
	flatten(Terms, FlatTerms).

checkTerminatedAtAll0(_, [], []).

checkTerminatedAll0(F=V, [(T1, T2)|RestRanges], [Terms|RestTerms]):-
	checkTerminatedAt(F=V, T1, T2, Terms),
	checkTerminatedAll0(F=V, RestRanges, RestTerms).

checkTerminatedAt(F=V, T1, T2, TermList):-
	computeTerminationsIncremental(F=V, T1, T2, TermList). %, member(T, TermList).

computeTerminationsIncremental(_, T1, T2, []):-
	T1>=T2, !.

computeTerminationsIncremental(F=V, T1, T2, [T1|Tail]):-
	nextTimePoint(T1, T1next),
	terminatedAt(F=V, T1, T1, T1next), !,
	indexOf(Index, F=V),
	addEndingPoint(Index, F=V, T1),
	addCyclicPointAllFVPs(Index, F=V, T1next, f), 
	computeTerminationsIncremental(F=V, T1next, T2, Tail).

computeTerminationsIncremental(F=V, T1, T2, [T1|Tail]):-
	simpleFluent(F=V2), \+V2=V, 
	nextTimePoint(T1, T1next),
	initiatedAt(F=V2, T1, T1, T1next), !,
	indexOf(Index2, F=V2),
	addStartingPointAllVals(Index2, F=V2, T1),
	addCyclicPointAllFVPs(Index2, F=V2, T1next, t),
	%write('\t\t\tcached starting point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl,
	%simpleFluent(F=V3), \+V3=V2,
	%indexOf(Index3, F=V3),
	%addCyclicPointAllFVPs(Index3, F=V3, T1next, f), 
	%addEndingPoint(Index3, F=V3, T1, T1),
	computeTerminationsIncremental(F=V, T1next, T2, Tail).

computeTerminationsIncremental(F=V, T1, T2, TermList):-
	nextTimePoint(T1, T1next),
	indexOf(Index, F=V),
	addProcessedRangeTerm(Index, F=V, T1),
	%addLastProcessedPointEP(Index, F=V, T1),
	computeTerminationsIncremental(F=V, T1next, T2, TermList).

%==============

/*
intervalsFromStoredPoints([], -1, []):- !.
intervalsFromStoredPoints([], T, [(T, inf)]).
intervalsFromStoredPoints([(T, t)|Tail], -1, Intervals):-
	!, intervalsFromStoredPoints(Tail, T, Intervals).
intervalsFromStoredPoints([(_T, t)|Tail], PrevT, Intervals):-
	intervalsFromStoredPoints(Tail, PrevT, Intervals).
intervalsFromStoredPoints([(_T, f)|Tail], -1, Intervals):-
	!, intervalsFromStoredPoints(Tail, -1, Intervals).
intervalsFromStoredPoints([(T, f)|Tail], PrevT, [(PrevT, T)|RestIntervals]):-
	intervalsFromStoredPoints(Tail, -1, RestIntervals).
*/

lastPointBeforeOrOnT(T, [(X,Val)], (X,Val)) :- !, X=<T.	
lastPointBeforeOrOnT(T, [(X1,Val1),(X2,_)|_], (X1,Val1)) :- X1=<T, X2>T, !.	
lastPointBeforeOrOnT(T, [(X,_)|Rest0], R) :-
	X<T, lastPointBeforeOrOnT(T, Rest0, R).		

/*
lastPointBeforeOrOnTDesc(T, [(X,Val)], (X,Val)) :- !, X=<T.	
lastPointBeforeOrOnTDesc(T, [(X1,Val1),(X2,_)|_], (X2,Val1)) :- X1>T, X2=<T, !.	
lastPointBeforeOrOnTDesc(T, [(X,_)|Rest0], R) :-
	X>T, lastPointBeforeOrOnTDesc(T, Rest0, R).	
*/	
	
%% Changing this to incorporate everything %%
findFluentVal(_Index, _U, T, (T,t)) :- !.
findFluentVal(Index, F=V, T, (Point,t)) :-
	notBrokenOrReInitiated(Index, F=V, Point, T), !,
	addCyclicPointAllFVPs(Index, F=V, T, t).
findFluentVal(Index, F=V, T, (_Point,t)) :-
	addCyclicPointAllFVPs(Index, F=V, T, f), !, false.
findFluentVal(Index, F=V, T, (Point,f)) :-
	startedBetween(Index, F=V, Point, InitPoint, T),
	nextTimePoint(InitPoint, NextPoint),
	addCyclicPointAllFVPs(Index, F=V, NextPoint, t),
	notBrokenOrReInitiated(Index, F=V, NextPoint, T), !,
	addCyclicPointAllFVPs(Index, F=V, T, t).
findFluentVal(Index, F=V, T, (_Point,f)) :-
	addCyclicPointAllFVPs(Index, F=V, T, f), !, false.
	
% we are looking in the interval [Ts,Te)
notBrokenOrReInitiated(_, _, Ts, Te) :- Ts>=Te, !.
notBrokenOrReInitiated(Index, F=V, Ts, Te) :-
	brokenOnce(Index, F=V, Ts, T, Te), !,
	nextTimePoint(T, NextT),
	startedBetween(Index, F=V, NextT, Init, Te),
	%nextTimePoint(Init, InitNext), addCyclicPointAllFVPs(Index, F=V, InitNext, t),
	notBrokenOrReInitiated(Index, F=V, Init, Te).
notBrokenOrReInitiated(_, _, _, _).	

% we are looking in the interval [Ts,Te)
brokenOnce(_Index, F=V1, Ts, T, Te) :-
	simpleFluent(F=V2), \+V2=V1,
	indexOf(Index2, F=V2),
	startedBetween(Index2, F=V2, Ts, T, Te), !.
	%nextTimePoint(T, Tnext),
	%addCyclicPointAllFVPs(Index2, F=V2, Tnext, t).

brokenOnce(_Index, F=V, Ts, T, Te) :-
	terminatedAt(F=V, Ts, T, Te), !.
	%nextTimePoint(T, Tnext),
	%addCyclicPointAllFVPs(Index, F=V, Tnext, f).

% we are looking in the interval [Ts,Te)
startedBetween(_, _, Ts, _, Te) :- Ts>=Te, !, false.
startedBetween(Index, F=V, Ts, T, Te) :-
	startingPoints(Index, F=V, SPoints),
	member(SPoint, SPoints), 
	prevTimePoint(SPoint, T), 
	Ts=<T, !, T<Te.	
startedBetween(Index, F=V, Ts, T, Te) :-
	initiatedAt(F=V, Ts, T, Te), !,
	addStartingPointAllVals(Index, F=V, T).

% we are looking in the interval [Ts,Te)
initPointBetween(Index, F=V, Ts, T, Te) :-
	startingPoints(Index, F=V, SPoints), 
	member(SPoint, SPoints), 
	prevTimePoint(SPoint, T), 
	Ts=<T, !, T<Te.	
initPointBetween(_Index, F=V, Ts, Ts, Te) :- 
	Ts<Te, initiallyCyclic(F=V), !.		
initPointBetween(Index, F=V, Ts, T, Te) :-
	nextTimePoint(Ts, NextTs),
	initiatedAt(F=V, NextTs, T, Te), !,
	addStartingPointAllVals(Index, F=V, T).
	
addStartingPointAllVals(Index, F=V, InitPoint):-
	addStartingPoint(Index, F=V, InitPoint),
	simpleFluent(F=V2), \+V=V2,
	indexOf(Index2, F=V2),
	addEndingPoint(Index2, F=V2, InitPoint).

/*
addLastProcessedPointSP(Index, F=V, LastProcessedPoint):-
	retract(startingPoints(Index, F=V, SPoints, PrevLPPoint)), !,
	max(LastProcessedPoint, PrevLPPoint, NewLPPoint),
	assert(startingPoints(Index, F=V, SPoints, NewLPPoint)).

addLastProcessedPointSP(Index, F=V, LastProcessedPoint) :-
	assert(startingPoints(Index, F=V, [], LastProcessedPoint)).
*/

addStartingPoint(Index, F=V, InitPoint):-
	retract(startingPoints(Index, F=V, SPoints)), !,
	addProcessedRangeInit(Index, F=V, InitPoint),
	nextTimePoint(InitPoint, SPoint),
	insertNo(SPoint, SPoints, NewSPoints),
	%max(LastProcessedPoint, PrevLPPoint, NewLPPoint),
	assert(startingPoints(Index, F=V, NewSPoints)).

addStartingPoint(Index, F=V, InitPoint) :-
	addProcessedRangeInit(Index, F=V, InitPoint),
	nextTimePoint(InitPoint, SPoint),
	assert(startingPoints(Index, F=V, [SPoint])).

/*
addLastProcessedPointEP(Index, F=V, LastProcessedPoint):-
	retract(endingPoints(Index, F=V, SPoints, PrevLPPoint)), !,
	%write('before max'),
	max(LastProcessedPoint, PrevLPPoint, NewLPPoint),
	%write('after max'),
	assert(endingPoints(Index, F=V, SPoints, NewLPPoint)).

addLastProcessedPointEP(Index, F=V, LastProcessedPoint) :-
	assert(endingPoints(Index, F=V, [], LastProcessedPoint)).
	*/

%% New code %%
addEndingPoint(Index, F=V, TermPoint):-
	retract(endingPoints(Index, F=V, EPoints)), !,
	addProcessedRangeTerm(Index, F=V, TermPoint),
	nextTimePoint(TermPoint, EPoint),
	insertNo(EPoint, EPoints, NewEPoints),
	%max(LastProcessedPoint, PrevLPPoint),
	assert(endingPoints(Index, F=V, NewEPoints)).

addEndingPoint(Index, F=V, TermPoint) :-
	addProcessedRangeTerm(Index, F=V, TermPoint),
	nextTimePoint(TermPoint, EPoint),
	assert(endingPoints(Index, F=V, [EPoint])).
%% New code end %%

addCyclicPointAllFVPs(Index, F=V, T, t):-
	addCyclicPoint(Index, F=V, T, t), 
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addCyclicPoint(Index2, F=V2, T, f).

addCyclicPointAllFVPs(Index, F=V, T, f):-
	addCyclicPoint(Index, F=V, T, f).

addCyclicPoint(Index, F=V, T, Val) :-
	retract(storedCyclicPoints(Index, F=V, OldCPoints)), !, 
	%%% Changed this in order to store cyclic points in descending order.
	%write('Tuple: '), write((T,Val)), nl,
	%write('OldPoint: '), write(OldCPoints), nl,
	insertTuple((T,Val), OldCPoints, NewCPoints),
	%write('NewPoint: '), write(NewCPoints), nl,
	assert(storedCyclicPoints(Index, F=V, NewCPoints)).
addCyclicPoint(Index, F=V, T, Val) :-
	assert(storedCyclicPoints(Index, F=V, [(T,Val)])).	

addProcessedRangeInit(Index, F=V, T):-
	retract(processedRangeInit(Index, F=V, OldProcessedIntervals)), !,
	nextTimePoint(T, Tnext),
	%write('OldProcessedIntervals: '), write(OldProcessedIntervals), nl,
	union_all([[(T,Tnext)], OldProcessedIntervals], NewProcessedRange),
	%write('NewProcessedIntervals: '), write(NewProcessedRange), nl,
	%computeNewProcessedRange(T, [Tlow, Thigh], NewProcessedRange),
	assert(processedRangeInit(Index, F=V, NewProcessedRange)).

addProcessedRangeInit(Index, F=V, T):-
	nextTimePoint(T, Tnext),
	assert(processedRangeInit(Index, F=V, [(T,Tnext)])).

addProcessedRangeTerm(Index, F=V, T):-
	retract(processedRangeTerm(Index, F=V, OldProcessedIntervals)), !,
	nextTimePoint(T, Tnext),
	union_all([[(T,Tnext)], OldProcessedIntervals], NewProcessedRange),
	%computeNewProcessedRange(T, [Tlow, Thigh], NewProcessedRange),
	assert(processedRangeTerm(Index, F=V, NewProcessedRange)).

addProcessedRangeTerm(Index, F=V, T):-
	nextTimePoint(T, Tnext),
	assert(processedRangeTerm(Index, F=V, [(T, Tnext)])).

insertNo(X, [], [X]).
insertNo(X, [X|Rest], [X|Rest]) :- !.
insertNo(X, [Y|Rest], [X,Y|Rest]) :- X<Y, !.
insertNo(X, [Y|Rest0], [Y|Rest]) :- 
	insertNo(X, Rest0, Rest).		
	
insertTuple(X, [], [X]) :- !.
insertTuple((X,Val), [(X,Val)|Rest], [(X,Val)|Rest]) :- !.
insertTuple((X,Val), [(Y,Val2)|Rest], [(X,Val),(Y,Val2)|Rest]) :- X<Y, !.
insertTuple(X, [Y|Rest0], [Y|Rest]) :-
	insertTuple(X, Rest0, Rest).

/*
computeNewProcessedRange(T, [OldLow, OldHigh], [T, OldHigh]):-
	T=<OldLow. 

computeNewProcessedRange(T, [OldLow, OldHigh], [OldLow, T]):-
	T>=OldHigh. 

computeNewProcessedRange(T, [OldLow, OldHigh], [OldLow, OldHigh]):-
	T>OldLow, T<OldHigh. 
*/
/*
insertTupleDesc(X, [], [X]) :- !.
insertTupleDesc((X,Val), [(X,Val)|Rest], [(X,Val)|Rest]) :- !.
insertTupleDesc((X,Val), [(Y,Val2)|Rest], [(X,Val),(Y,Val2)|Rest]) :- X>Y, !.
insertTupleDesc(X, [Y|Rest0], [Y|Rest]) :-
	insertTupleDesc(X, Rest0, Rest).
*/
	
/******************* entity index: use of cut to avoid backtracking *********************/

indexOf(Index, E) :-
	index(E, Index), !.

/******************* APPLICATION-INDEPENDENT holdsFor, holdsAt AND happensAt (INCARNATIONS) *********************/


%%%%%%% holdsFor as used in the body of entity definitions

% processed input entity/statically determined fluent
holdsForProcessedIE(Index, IE, L) :- 
  	iePList(Index, IE, L, _), !.

holdsForProcessedIE(_Index, _IE, []).

% cached simple fluent
holdsForProcessedSimpleFluent(Index, F=V, L) :-	
	simpleFPList(Index, F=V, L, _), !.
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, L, _), _), !.

holdsForProcessedSimpleFluent(_Index, _U, []).

% cached output entity/statically determined fluent
holdsForProcessedSDFluent(Index, F=V, L) :- 
  	sdFPList(Index, F=V, L, _), !.
  	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, L, _), _), !.

holdsForProcessedSDFluent(_Index, _U, []).


%%%%%%% holdsAt as used in the body of entity definitions

% T should be given in all 4 predicates below

% processed input entity/statically determined fluent
holdsAtProcessedIE(Index, F=V, T) :- 
  	iePList(Index, F=V, [H|Tail], _),
	tinIntervals(T, [H|Tail]).

% cached simple fluent
holdsAtProcessedSimpleFluent(Index, F=V, T) :-	
	simpleFPList(Index, F=V, [H|Tail], _),
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [H|Tail], _), _), 
	%write(Index), nl, nl,
	tinIntervals(T, [H|Tail]).

% cached output entity/statically determined fluent
holdsAtProcessedSDFluent(Index, F=V, T) :- 
  	sdFPList(Index, F=V, [H|Tail], _),
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [H|Tail], _), _),
	tinIntervals(T, [H|Tail]).

% statically determined fluent that is neither an input entity nor an output entity
% ie the intervals of F=V are not cached
holdsAtSDFluent(F=V, T) :- 
  	holdsForSDFluent(F=V, [H|Tail]),
	tinIntervals(T, [H|Tail]).


%%%%%%% happensAt as used in the body of entity definitions

%%%% special event: the starting time of a fluent

%%% in each case below (input entity/statically determined fluent, simple fluent 
%%% and output entity/statically determined fluent), the first rule checks if 
%%% the first interval in (Qi-WM, Qi] is amalgamated with the last interval before Qi-WM
%%% If it is then start(F=V) does not take place at the starting time 
%%% of the first interval in (Qi-WM, Qi]

% compute the starting points of processed input entities/statically determined fluents
happensAtProcessedIE(Index, startI(F=V), S) :-
	iePList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
	member((S,_E), Tail).
happensAtProcessedIE(Index, startI(F=V), S) :-
	iePList(Index, F=V, [H|Tail], []), 
	member((S,_E), [H|Tail]).
% compute the starting points of simple fluents
happensAtProcessedSimpleFluent(Index, startI(F=V), S) :-
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), _),
	member((S,_E), Tail).
happensAtProcessedSimpleFluent(Index, startI(F=V), S) :-
	simpleFPList(Index, F=V, [H|Tail], []),
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [H|Tail], []), _),
	member((S,_E), [H|Tail]).
% compute the starting points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, startI(F=V), S) :-
	sdFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),  
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), _), 
	member((S,_E), Tail).
happensAtProcessedSDFluent(Index, startI(F=V), S) :-
	sdFPList(Index, F=V, [H|Tail], []), 
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [H|Tail], []), _),
	member((S,_E), [H|Tail]).
	
% compute the starting points of processed input entities/statically determined fluents
happensAtProcessedIE(Index, start(F=V), T) :-
	iePList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
	member((S,_E), Tail), prevTimePoint(S, T).
happensAtProcessedIE(Index, start(F=V), T) :-
	iePList(Index, F=V, [H|Tail], []), 
	member((S,_E), [H|Tail]), prevTimePoint(S, T).
% compute the starting points of simple fluents
happensAtProcessedSimpleFluent(Index, start(F=V), T) :-
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), _),  
	member((S,_E), Tail), prevTimePoint(S, T).
happensAtProcessedSimpleFluent(Index, start(F=V), T) :-
	simpleFPList(Index, F=V, [H|Tail], []),
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [H|Tail], []), _), 
	member((S,_E), [H|Tail]), prevTimePoint(S, T).
% compute the starting points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, start(F=V), T) :-
	sdFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),  
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), _),
	member((S,_E), Tail), prevTimePoint(S, T).
happensAtProcessedSDFluent(Index, start(F=V), T) :-
	sdFPList(Index, F=V, [H|Tail], []),
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [H|Tail], []), _), 
	member((S,_E), [H|Tail]), prevTimePoint(S, T).

% start(F=V) is not defined for fluents that are neither input nor output entities, 
% ie fluents that are not cached
% For such fluents we do not have access to the last interval before Qi-WM 
% and therefore we cannot compute whether the last interval before Qi-WM 
% is amalgamated with the first interval in (Qi-WM,Qi]


%%%% special event: the ending time of a fluent interval 
/*
% compute the ending points of processed input entities/statically determined fluents
happensAtProcessedIE(Index, end(F=V), E) :-
	iePList(Index, F=V, [H|Tail], _), 
	member((_S,E), [H|Tail]), \+ E=inf.
% compute the ending points of simple fluents
happensAtProcessedSimpleFluent(Index, end(F=V), E) :-
	simpleFPList(Index, F=V, [H|Tail], _),
	member((_S,E), [H|Tail]), \+ E=inf.
% compute the ending points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, endO(F=V), E) :-
	sdFPList(Index, F=V, [H|Tail], _), 
	member((_S,E), [H|Tail]), \+ E=inf.
% compute the ending points of statically determined fluents
% that are neither input nor output entities, ie these fluents are not cached
happensAtSDFluent(endO(F=V), E) :-
	holdsForSDFluent(F=V, [H|Tail]), 
	member((_S,E), [H|Tail]), \+ E=inf.
*/
% compute the ending points of processed input entities/statically determined fluents
happensAtProcessedIE(Index, end(F=V), T) :-
	iePList(Index, F=V, [H|Tail], _), 
	member((_S,E), [H|Tail]), 
	\+ E=inf, prevTimePoint(E, T).
% compute the ending points of simple fluents
happensAtProcessedSimpleFluent(Index, end(F=V), T) :-
	simpleFPList(Index, F=V, [H|Tail], _),
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, [H|Tail], _), _),
	member((_S,E), [H|Tail]), 
	\+ E=inf, prevTimePoint(E, T).
% compute the ending points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, end(F=V), T) :-
	sdFPList(Index, F=V, [H|Tail], _), 
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, [H|Tail], _), _),
	member((_S,E), [H|Tail]), 
	\+ E=inf, prevTimePoint(E, T).
% compute the ending points of statically determined fluents
% that are neither input nor output entities, ie these fluents are not cached
happensAtSDFluent(end(F=V), T) :-
	holdsForSDFluent(F=V, [H|Tail]), 
	member((_S,E), [H|Tail]), 
	\+ E=inf, prevTimePoint(E, T).

%%%% happensAtProcessed for non-special events

% cached events
happensAtProcessed(Index, E, T) :-
	%fetchKey(E, Key),
	%recorded(Key, evTList(E, L), _),
	evTList(Index, E, L),
	member(T, L).


%%%%%%% USER INTERACTION %%%%%%%

%%%%%%% holdsFor is used ONLY for user interaction
%%%%%%% use iePList/simpleFPList/sdFPList and look no further

holdsFor(F=V, L) :-
	retrieveIntervals(F=V, L).

% retrieve the intervals of input entities (those for which we collect their intervals)
retrieveIntervals(F=V, L) :-
	% collectIntervals2/2 is produced in the compilation stage 
	% by combining collectIntervals/1, indexOf/2 and grounding/1
	collectIntervals2(Index, F=V),
	retrieveIEIntervals(Index, F=V, L).

% retrieve the intervals of input entities (those for which we build their intervals from time-points)
retrieveIntervals(F=V, L) :-
	% buildFromPoints2/2 is produced in the compilation stage 
	% by combining collectIntervals/1, indexOf/2 and grounding/1
	buildFromPoints2(Index, F=V),
	retrieveIEIntervals(Index, F=V, L).

% retrieve the intervals of output entities
retrieveIntervals(F=V, L) :-
	% cachingOrder2/2 is produced in the compilation stage 
	% by combining cachingOrder/1, indexOf/2 and grounding/1
	cachingOrder2(Index, F=V), 
	retrieveOEIntervals(Index, F=V, L).


retrieveIEIntervals(Index, F=V, L) :-
	iePList(Index, F=V, RestrictedList, Extension), !,
	amalgamatePeriods(Extension, RestrictedList, L).

retrieveIEIntervals(_Index, _U, []).


retrieveOEIntervals(Index, F=V, L) :-
	sDFluent(F=V), !,
	retrieveOESDFluentIntervals(Index, F=V, L).

retrieveOEIntervals(Index, F=V, L) :-
	simpleFPList(Index, F=V, RestrictedList, Extension), !, 
	%write('RestrictedList: '), write(RestrictedList), nl,
	%write('Extension: '), write(Extension), nl,
	%fetchKey(F=V, Key),
	%recorded(Key, simpleFPList(F=V, RestrictedList, Extension), _), !,
	amalgamatePeriods(Extension, RestrictedList, L).

retrieveOEIntervals(_Index, _U, []).


retrieveOESDFluentIntervals(Index, F=V, L) :-
	sdFPList(Index, F=V, RestrictedList, Extension), !,
	%fetchKey(F=V, Key),
	%recorded(Key, sdFPList(F=V, RestrictedList, Extension), _), !,
	amalgamatePeriods(Extension, RestrictedList, L).

retrieveOESDFluentIntervals(_Index, _U, []).


%%%%%%% holdsAt is used ONLY for user interaction
% T should be given

holdsAt(F=V, T) :-
	holdsFor(F=V, [H|Tail]),
	tinIntervals(T, [H|Tail]).


tinIntervals(T, L) :-
	member((S,E), L),
	gt(E,T), !, S=<T.


%%%%%%% happensAt is used ONLY for user interaction

% retrieve the time-points of input entities
happensAt(E, T) :-
	inputEntity(E),
	happensAtIE(E, T).

% happensAtIE redirects to the indexed knowledge in the database.
%happensAtIE(E, T):-
%	happensAtIEIndexed(T, E).

% retrieve the time-points of output entities
happensAt(E, T) :-
	event(E), 
	% cachingOrder2/2 is produced in the compilation stage 
	% by combining cachingOrder/1, indexOf/2 and grounding/1
	cachingOrder2(Index, E),
	happensAtProcessed(Index, E, T).

