
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
:- use_module(library(socket)).

%:- ['compiler.prolog']. %% After adding indexOf in compiler, some unit tests fail... so comment it for now...
:- ['inputModule.prolog'].
:- ['processSimpleFluents.prolog'].
:- ['processSDFluents.prolog'].
:- ['processEvents.prolog'].
:- ['utilities/interval-manipulation.prolog'].
:- ['utilities/amalgamate-periods.prolog'].
:- ['utilities/makeLogs.prolog'].
% Load the dynamic grounding module
:- ['dynamic grounding/dynamicGrounding.prolog'].
% Load module for handling deadlines
:- ['timeoutTreatment.prolog'].

/***** dynamic predicates *****/

% The predicates below are asserted/retracted
:- dynamic temporalDistance/1, input/1, noDynamicGrounding/0, preProcessing/1, initTime/1, queryTime/1, iePList/4, simpleFPList/4, sdFPList/4, evTList/3, happensAtIE/2, holdsForIESI/2, holdsAtIE/2, processedCyclic/2, initiallyCyclic/1, storedCyclicPoints/3, startingPoints/3, endingPoints/3, processedRangeInit/3, processedRangeTerm/3.

% The predicates below may or may not appear in the event description of an application;
% thus they must be declared dynamic
:- dynamic collectIntervals2/2, buildFromPoints2/2, cyclic/1, fi/3, p/1, internalEntity/1, sDFluent/1,	simpleFluent/1, inputEntity/1, collectGrounds/2, dgrounded/2.

/***** multifile predicates *****/

:- multifile 
% holdsFor/2 and happensAt/2 are defined in this file and may also be defined in an event description
holdsFor/2, happensAt/2,
% these predicates may appear in the data files of an application
updateSDE/2, updateSDE/3, updateSDE/4,
% these predicates are used in processSimpleFluent.prolog
initially/1, initiatedAt/4, terminatedAt/4.

/***** discontiguous predicates *****/

:- discontiguous
% these predicates are defined in this file 
happensAtProcessedIE/3, happensAtProcessedSDFluent/3, happensAtProcessedSimpleFluent/3, deadlines1/3,
% these predicates may be part of the declarations of an event description 
inputEntity/1, internalEntity/1, outputEntity/1, index/2, event/1, simpleFluent/1, sDFluent/1, grounding/1, dgrounded/2,
% these predicates may be part of an event description 
holdsFor/2, holdsForSDFluent/2, initially/1, initiatedAt/2, terminatedAt/2, initiates/3, terminates/3, initiatedAt/4, terminatedAt/4, happensAt/2, fi/3, p/1,
% this predicate may appear in the data files of an application
updateSDE/4. 

/********************************** INITIALISE RECOGNITION ***********************************/



initialiseRecognition(InputFlag, DynamicGroundingFlag, PreProcessingFlag, TemporalDistance) :-
	assertz(temporalDistance(TemporalDistance)), 
	% Assert threshold for forget and dynamic grounding mechanisms here 
	% to avoid carrying these values forever 
	assertz(eventsPerTimepointThreshold(-1)), 
	assertz(groundTermOverlapThreshold(-1)), %
	(InputFlag=ordered, assertz(input(InputFlag)) ; assertz(input(unordered))),
	% if we need dynamic grounding then dynamicGrounding/1 is already defined
	% so there is no need to assert anything here
	(DynamicGroundingFlag=dynamicgrounding ; assertz(noDynamicGrounding)),	
	% if we need preprocessing then preProcessing/1 is already defined
	% so there is no need to assert anything here
	(PreProcessingFlag=preprocessing ; assertz(preProcessing(_))), !.


initialiseRecognition(InputFlag, DynamicGroundingFlag, PreProcessingFlag, ForgetThreshold, DynamicGroundingThreshold, TemporalDistance) :-
	assertz(temporalDistance(TemporalDistance)), 
	% Assert threshold for forget and dynamic grounding mechanisms here 
	% to avoid carrying these values forever 
	assertz(eventsPerTimepointThreshold(ForgetThreshold)), 
	assertz(groundTermOverlapThreshold(DynamicGroundingThreshold)), %
	(InputFlag=ordered, assertz(input(InputFlag)) ; assertz(input(unordered))),
	% if we need dynamic grounding then dynamicGrounding/1 is already defined
	% so there is no need to assert anything here
	(DynamicGroundingFlag=dynamicgrounding ; assertz(noDynamicGrounding)),	
	% if we need preprocessing then preProcessing/1 is already defined
	% so there is no need to assert anything here
	(PreProcessingFlag=preprocessing ; assertz(preProcessing(_))), !.


/************************************* EVENT RECOGNITION *************************************/


eventRecognition(QueryTime, WM) :-
	InitTime is QueryTime-WM,
	assertz(initTime(InitTime)),
	assertz(queryTime(QueryTime)),
    % delete input entities that have taken place before or on Qi-WM
	forget(InitTime),
	% calculate the items for which we will perform reasoning
	dynamicGrounding(InitTime, QueryTime),
	% compute the intervals of input entities/statically determined fluents
	inputProcessing(InitTime, QueryTime),
	preProcessing(QueryTime),
	% CYCLES & DEADLINES CHANGE
        findall((Index,F=V,SPoints), (startingPoints(Index,F=V,SPoints), retract(startingPoints(Index,F=V,SPoints))), _),
        %findall((Index,F=V,SPoints), (startingPoints(Index,F=V,SPoints), write(startingPoints(Index,F=V,SPoints)), nl,
        %                              retractStartingPoints(Index, F=V, SPoints, InitTime)), _),
	findall((Index,F=V,EPoints), (endingPoints(Index,F=V,EPoints),retract(endingPoints(Index,F=V,EPoints))), _),
	findall((Index,F=V,Range), (processedRangeTerm(Index,F=V,Range),retract(processedRangeTerm(Index,F=V,Range))), _),
	findall((Index,F=V,Range), (processedRangeInit(Index,F=V,Range),retract(processedRangeInit(Index,F=V,Range))), _),
	% CYCLES #1 CHANGE
	%write('Before prepareCyclic'), nl,
	prepareCyclic,
	%write('After prepareCyclic'), nl,
	% DEADLINES #1 CHANGE
	findall((F=V,Duration), (fi(F=V,_,Duration), deadlines1(F=V,Duration,InitTime)), _),
	% the order in which entities are processed makes a difference
	% start from lower-level entities and then move to higher-level entities
	% in this way the higher-level entities will use the CACHED lower-level entities
	% the order in which we process entities is set by cachingOrder/1 
	% which is specified in the domain-dependent file 
	% cachingOrder2/2 is produced in the compilation stage 
	% by combining cachingOrder/1, indexOf/2 and grounding/1
	findall(OE, (cachingOrder2(Index,OE), processEntity(Index,OE,InitTime,QueryTime)), _),
    (skipLogs, ! ; commitVariables(processEntityFlag)),
	%findall(OE, (cachingOrder2(Index,OE), holdsFor(OE, I), write('Derived Intervals of '), write(OE), write(': '), write(I), nl), _),
	%findall(OE, (cachingOrder2(Index,OE), startingPoints(Index, OE, SPoints), write('Cached initiation points of '),  write(OE), write(': '), write(SPoints), nl), _),
	%findall(OE, (cachingOrder2(Index,OE), endingPoints(Index, OE, EPoints), write('Cached termination points of '),  write(OE), write(': '), write(EPoints), nl), _),
	% DEADLINES #2 CHANGE
	findall((F=V,Duration), (fi(F=V,_,Duration), deadlines2(F=V,Duration,InitTime)), _),
	retract(queryTime(QueryTime)),
	retract(initTime(InitTime)).

processEntity(Index, OE, InitTime, QueryTime) :-
	(
		% compute the intervals of output entities/statically determined fluents
		sDFluent(OE), 
		processSDFluent(Index, OE, InitTime) 
		;
		% compute the intervals of simple fluents 
		% (simple fluents are by definition output entities) 
		simpleFluent(OE), 
		processSimpleFluent(Index, OE, InitTime, QueryTime),
		% CYCLES #2 CHANGE (no need to assert if not cyclic)
		assertCyclic(Index, OE)
		;
		% compute the time-points of output entities/events
		event(OE), 
		processEvent(Index, OE)
	), !.

/*
retractStartingPoints(Index, F=V, SPoints, InitTime):-
    getPointsAfterInitTime(SPoints, InitTime, PointsThatRemain),
    PointsThatRemain=[], !,
    retract(startingPoints(Index, F=V, SPoints)).
    %assertz(startingPoints(Index, F=V, PointsThatRemain)).
retractStartingPoints(Index, F=V, SPoints, InitTime):-
    getPointsAfterInitTime(SPoints, InitTime, PointsThatRemain),
    retract(startingPoints(Index, F=V, SPoints)),
    assertz(startingPoints(Index, F=V, PointsThatRemain)), write(PointsThatRemain), nl.
    %
getPointsAfterInitTime([], _, []).
getPointsAfterInitTime([SPoint|RestSPoints],InitTime,PointsThatRemain):-
    SPoint=<InitTime, !,
    getPointsAfterInitTime(RestSPoints,InitTime,PointsThatRemain).
getPointsAfterInitTime([SPoint|RestSPoints],_InitTime,[SPoint|RestSPoints]).
*/

/******************* deadlines treatment *********************/

% Process deadline attempts computed at the previous query time

% the rule below deals with fluents whose expiration may be extended
% ie fi and p
% keep the happensAt(attempt(F=V),T) computed at the previous query time
% iff (a) holdsAt(F=V,nextTimePoint(Qi-WM)), (b) T>Qi-WM, and (c) T-Duration=<Qi-WM
deadlines1(F=V, Duration, InitTime) :-
	p(F=V), !,
	indexOf(Index, F=V), 
	retract( evTList(Index, attempt(F=V), ListofDeadlineAttempts) ),
	% (a) holdsAt(F=V,nextTimePoint(Qi-WM))
	simpleFPList(Index, F=V, I1, I2),
	amalgamatePeriods(I2, I1, I),
	nextTimePoint(InitTime, NextInitTime),
	tinIntervals(NextInitTime, I),
	% find the deadline attempt that satisfies conditions (b) and (c) mentioned above
	% this predicate is defined below
	findDeadlineAttempt(ListofDeadlineAttempts, Attempt, InitTime, Duration), 
	assertz( evTList(Index, attempt(F=V), Attempt) ).
	
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
	retract( evTList(Index, attempt(F=V), ListofDeadlineAttempts) ),	
	% (a) holdsAt(F=V,nextTimePoint(Qi-WM))
	simpleFPList(Index, F=V, I1, I2),
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
	assertz( evTList(Index, attempt(F=V), [Attempt]) ).

% deadlines2/1 computes and stores the deadline attempts

% the two rules below deal with fluents whose expiration may be extended

% the rule below deals with the case where there are
% dealine attempts from the previous query time
deadlines2(F=V, Duration, InitTime) :-
	p(F=V),
	indexOf(Index, F=V),
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
	p(F=V), !,
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
	retract( evTList(Index, attempt(F=V), List) ), !,
	simpleFPList(Index, F=V, I1, I2),
	amalgamatePeriods(I2, I1, I),
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
	amalgamatePeriods(I2, I1, I),
	findall(T, 
		(member((S,_),I), prevTimePoint(S,PrevS), PrevS>InitTime, T is PrevS+Duration), 
	NewList), !,
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
        nextTimePoint(InitTime, NextInitTime),
	findall(F=V, 
	  (
	    cyclic(F=V),
	    indexOf(Index, F=V),
            /*
            startingPoints(Index, F=V, [SPoint]),
            prevTimePoint(SPoint, PrevTimepoint),
            addStartingPointAllVals(Index, F=V, PrevTimepoint),
            addProcessedRangeAllVals(Index, F=V, SPoint),
            addCyclicPointAllFVPs(Index, F=V, SPoint, t),
            assertz(initiallyCyclic(F=V))
            */
            simpleFPList(Index, F=V, I1, I2),
            amalgamatePeriods(I2, I1, I),
            tinIntervals(NextInitTime, I),
            assertz(initiallyCyclic(F=V)), 
            		addStartingPointAllVals(Index, F=V, InitTime),
            		addProcessedRangeAllVals(Index, F=V, InitTime),
            		addCyclicPointAllFVPs(Index, F=V, InitTime, t)
		),
	  _).
assertInitiallyCyclic :-
	 % InitTime=<0
	 findall(F=V, 
	  (
	    cyclic(F=V),
	    grounding(F=V),
	    %initially(F=V),
		(initiatedAt(F=V,-1,-1,0); initially(F=V)),
	    assertz(initiallyCyclic(F=V)), 
			indexOf(Index, F=V), 
	  		addStartingPointAllVals(Index, F=V, 0),
			addProcessedRangeAllVals(Index, F=V, 1),
	  		addCyclicPointAllFVPs(Index, F=V, 1, t)
		),
	  _).
	  
assertCyclic(Index, F=V) :- 
	  cyclic(F=V), !,
	  assertz(processedCyclic(Index, F=V)).
assertCyclic(_, _).

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
	lastPointBeforeOrOnT(T, StoredPoints, (Point,Val)), !, 
	findFluentVal(Index, F=V, T, (Point,Val)).
% the rule below are classic EC simple fluent computation
holdsAtCyclic(Index, F=V, T) :-
	initTime(InitTime), 
	initPointBetween(Index, F=V, InitTime, InitPoint, T),
	nextTimePoint(InitPoint, NextPoint),
	notBrokenOrReInitiated(Index, F=V, NextPoint, T), 
	% since we computed a time-point for the cyclic fluent we store it 
	% in order to avoid recomputing it in the future
	addCyclicPoint(Index, F=V, T, t), !.
% store that we failed to prove holdsAt(F=V, T)
holdsAtCyclic(Index, F=V, T) :-
	addCyclicPoint(Index, F=V, T, f), !, false.
	
	
lastPointBeforeOrOnT(T, [(X,Val)], (X,Val)) :- !, X=<T.	
lastPointBeforeOrOnT(T, [(X1,Val1),(X2,_)|_], (X1,Val1)) :- X1=<T, X2>T, !.	
lastPointBeforeOrOnT(T, [(X,_)|Rest0], R) :-
	X<T, lastPointBeforeOrOnT(T, Rest0, R).		
	
findFluentVal(_Index, _U, T, (T,Val)) :- !, Val=t.
findFluentVal(Index, F=V, T, (Point,t)) :-
	notBrokenOrReInitiated(Index, F=V, Point, T), !,
	addCyclicPoint(Index, F=V, T, t).
findFluentVal(Index, F=V, T, (_Point,t)) :-
	addCyclicPoint(Index, F=V, T, f), !, false.
findFluentVal(Index, F=V, T, (Point,f)) :-
	startedBetween(Index, F=V, Point, InitPoint, T),
	nextTimePoint(InitPoint, NextPoint),
	notBrokenOrReInitiated(Index, F=V, NextPoint, T), !,
	addCyclicPoint(Index, F=V, T, t).
findFluentVal(Index, F=V, T, (_Point,f)) :-
	addCyclicPoint(Index, F=V, T, f), !, false.
	
% we are looking in the interval [Ts,Te)
notBrokenOrReInitiated(_, _, Ts, Te) :- Ts>=Te, !.
notBrokenOrReInitiated(Index, F=V, Ts, Te) :-
	brokenOnce(Index, F=V, Ts, T, Te), !,	
	nextTimePoint(T, NextT),
	startedBetween(Index, F=V, NextT, Init, Te),
	notBrokenOrReInitiated(Index, F=V, Init, Te).
notBrokenOrReInitiated(_, _, _, _).	

% we are looking in the interval [Ts,Te)
brokenOnce(Index, F=V1, Ts, T, Te) :-
	simpleFluent(F=V2), \+V2=V1, %grounding(F=V2), \+V2=V1,
	startedBetween(Index, F=V2, Ts, T, Te), !.
brokenOnce(_Index, F=V, Ts, T, Te) :-
	terminatedAt(F=V, Ts, T, Te), !.

% we are looking in the interval [Ts,Te)
startedBetween(_, _, Ts, _, Te) :- Ts>=Te, !, false.
startedBetween(Index, F=V, Ts, T, Te) :-
	startingPoints(Index, F=V, SPoints),
	member(SPoint, SPoints), 
	prevTimePoint(SPoint, T), 
	Ts=<T, !, T<Te.	
startedBetween(Index, F=V, Ts, T, Te) :-
	initiatedAt(F=V, Ts, T, Te), !,
	addStartingPoint(Index, F=V, T).

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
	addStartingPoint(Index, F=V, T).

	
addStartingPoint(Index, F=V, InitPoint) :-
	retract(startingPoints(Index, F=V, SPoints)), !,
	nextTimePoint(InitPoint, SPoint),
	insertNo(SPoint, SPoints, NewSPoints),
	assertz(startingPoints(Index, F=V, NewSPoints)).
addStartingPoint(Index, F=V, InitPoint) :-
	nextTimePoint(InitPoint, SPoint),
	assertz(startingPoints(Index, F=V, [SPoint])).
	
addCyclicPoint(Index, F=V, T, Val) :-
	retract(storedCyclicPoints(Index, F=V, OldCPoints)), !, 
	insertTuple((T,Val), OldCPoints, NewCPoints),
	assertz(storedCyclicPoints(Index, F=V, NewCPoints)).
addCyclicPoint(Index, F=V, T, Val) :-
	assertz(storedCyclicPoints(Index, F=V, [(T,Val)])).	

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

/******************* initiatedAtCyclic/terminatedAtCyclic *********************/

% In some applications, e.g., NetBill and biological feedback loops, we
% (i) cyclic dependencies, and 
% (ii) initiatedAt/terminatedAt conditions in the bodies of rules. 
%
% The purpose of predicates initiatedAtCyclic/terminatedAtCyclic is to avoid infinite loops and 
% redundant computations when evaluating initiatedAt/terminatedAt conditions in the presence of cycles.
%
% initiatedAtCyclic(+Index, +F=V, +T)
% The 3-arity incarnation of this predicate is used when initiatedAtCyclic is not the first condition of the rule. 
% In this case, the time-point T of the evaluation is known.
% case: (i) the maximal intervals of F=V have been processed,
% 		(ii) there is a broken period.
% The starting point of the intervals of F=V are (some of the) initiation points of F=V.
% (So, cutting here is maybe not correct.)
initiatedAtCyclic(Index, F=V, T) :-
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T)), nl,
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic1'), nl,
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((S,_E), Tail),	
	prevTimePoint(S, T), !. %, T>=T1, T<T2.

% case: (i) the maximal intervals of F=V have been processed,
% 		(ii) there is no broken period.
% The starting point of the intervals of F=V are (some of the) initiation points of F=V.
initiatedAtCyclic(Index, F=V, T) :-
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T)), nl,
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic2'), nl,
	simpleFPList(Index, F=V, [H|Tail], []),
		%write('\t\t\t\tList: '), write([H|Tail]), nl,
	member((S,_E), [H|Tail]), 
		%\+E=inf,
	prevTimePoint(S, T), !. %, T>=T1, T<T2.

% case: (i) there are some time-points Tp inside the window where the truth value of initiatedAt(F=V, Tp) has been computed.
% 		(ii) and T is one of these time-points.
% In this case, we can derive with certainty whether F=V is initiated at T or not. 
% There is a starting point S corresponding to the initiation point T, then F=V is initiated at T. Otherwise, F=V is not initiated at T.
initiatedAtCyclic(Index, F=V, T) :-
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T)), nl,
	% \+ processed 
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeInit(Index, F=V, ProcessedRange),
		%write('\t\t\t\tProcessed range '), write(F=V), write(' : '), write(ProcessedRange), nl,
	%largestStoredPoint(SPoints, LSPoint),
	%T=<Thigh, T>=Tlow, !,
	tinIntervals(T, ProcessedRange), !,
	startingPoints(Index, F=V, SPoints),
		%write('\t\t\t\tstartingPoints of '), write(F=V), write(' : '), write(SPoints), nl,
	%findall(Tterm, (member((S, f), StoredPoints), prevTimePoint(S, Tterm), Tterm>=T1, Tterm<T2), TermList),
	%findAllStoredTermPointsBetween(StoredPoints, T1, T2, TermList),
	%member(T, TermList).
	member(S, SPoints),
	prevTimePoint(S, T). %, T>=T1, T<T2.

% case: T is not one of the time-points where the truth value of initiatedAt(F=V, Tp) has been computed.
% TODO: Check if this can be broken up into sub cases
initiatedAtCyclic(_Index, F=V, T):-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T,')']),
	%write('checking termination at '), write(T), nl, 
	%computeInitiationsInRange(F=V, T, T, InitList), 
	nextTimePoint(T, Tnext),
		%writeAll(['\t\t\tcomputeInitiationsInRange(', F=V, T, Tnext, ')']), 
	computeInitiationsInRange(F=V, T, Tnext, InitList), member(T, InitList).
	%write('TermList: '), write(TermList), nl,
	%member(T, InitList).

% initiatedAtCyclic(+Index, +F=V, +T1, -T, +T2)
% The 5-arity incarnation of this predicate is used when initiatedAtCyclic is the first condition of the rule. 
% In this case, the time-point T of the evaluation is not known, but the range [T1,T2) in which the evaluation should take place is given.
% case: (i) the maximal intervals of F=V have been processed,
% 		(ii) there is a broken period.
% The starting point of the intervals of F=V are (some of the) initiation points of F=V.
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T1,T,T2,')']),
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic1'), nl,
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((S,_E), Tail), 
	prevTimePoint(S, T), T>=T1, T<T2.

% case: (i) the maximal intervals of F=V have been processed,
% 		(ii) there is no broken period.
% The starting point of the intervals of F=V are (some of the) initiation points of F=V.
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T1,T,T2,')']),
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic2'), nl,
	simpleFPList(Index, F=V, [H|Tail], []),
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((S,_E), [H|Tail]), 
	prevTimePoint(S, T), T>=T1, T<T2.


% case: (i) there are some time-points Tp inside the window where the truth value of initiatedAt(F=V, Tp) has been computed.
% 		(ii) and all time-points in range [T1,T2) have been processed wrt initiatedAt
% In this case, we can derive with certainty whether F=V is initiated at T or not. 
% There is a starting point S that falls within the given range, then we return the corresponding initiation point. Otherwise, initiatedAtCyclic returns false.
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T1,T,T2,')']),
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T1, T, T2)), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
		%writeAll(['\t\t\tprocessedRangeInit(',F=V,ProcessedRange,')']),
		%write('\t\t\t\tProcessed range '), write(F=V), write(' : '), write(ProcessedRange), nl,
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], []), !,
		%write('\t\t\t\tRelative Complement Empty!'), nl,
	startingPoints(Index, F=V, SPoints),
		%write('startingPoints OK.'), nl,
		%writeAll(['\t\t\tstartingPoints(',F=V,SPoints,')']),
		%write('\t\t\t\tStarting Points: '), write(SPoints), nl,
	member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2.
		%writeAll(['\t\t\t', F=V, 'is initated at', T]).
	%computeInitiationsInRange(F=V, T1, T2, InitList), member(T, InitList), T>=T1, T<T2. 

% case: (i) there are some time-points Tp inside the window where the truth value of initiatedAt(F=V, Tp) has been computed.
% 		(ii) and some of the time-points in range [T1,T2) have been processed wrt initiatedAt
% In this case, we compute the initiations that are in cached list SPoints and the compute, point-by-point, all the initiations of F=V that are within the unprocessed range.
initiatedAtCyclic(Index, F=V, T1, T, T2) :-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T1,T,T2,')']),
	%storedCyclicPoints(Index, F=V, StoredPoints),
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T1, T, T2)), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
		%writeAll(['\t\t\tprocessedRangeInit(',F=V,ProcessedRange,')']),
		%write('\t\t\t\tProcessed range '), write(F=V), write(' : '), write(ProcessedRange), nl,
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), 
		%write('\t\t\t\tUnprocessed Intervals: '), write(UnprocessedIntervals), nl,
	%write('UnprocessedIntervals: '), write(UnprocessedIntervals), nl,
	startingPoints(Index, F=V, SPoints), !,
		%writeAll(['\t\t\tstartingPoints(',F=V,SPoints,')']),
		%write('\t\t\t\tStarting Points: '), write(SPoints), nl,
	(member(S, SPoints), prevTimePoint(S, T), T>=T1, T<T2 ; computeInitiationsInRangeAll(F=V, UnprocessedIntervals, InitList), member(T, InitList), T>=T1, T<T2).

% case: There is no cached list of starting points, and thus we compute all initiation points, point-by-point, in the given range.
initiatedAtCyclic(Index, F=V, T1, T, T2):-
		%writeAll(['\t\t\tinitiatedAtCyclic(',F=V,T1,T,T2,')']),
	%write(F=V), nl,
	%write('FVP: '), write(F=V), write(' T1='), write(T1), write(' and T2='), write(T2), nl,
		%write('\t\t\t'), write(initiatedAtCyclic(Index, F=V, T1, T, T2)), nl,
	processedRangeInit(Index, F=V, ProcessedRange),
		%write('\t\t\t\tProcessed range'), write(initiatedAtCyclic(Index, F=V, T1, T, T2)), nl,
	%write('ProcessedRangeInit: '), write(ProcessedRange), nl,
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), !,
	%write('UnprocessedIntervals: '), write(UnprocessedIntervals), nl,
	\+ startingPoints(Index, F=V, _SPoints),
	computeInitiationsInRangeAll(F=V, UnprocessedIntervals, InitList), member(T, InitList), T>=T1, T<T2.
	%computeInitiationsInRange(F=V, T1, T2, InitList),
	%member(T, InitList).

% case: There is no time-point where initiatedAt has been evaluated for F=V, and thus we compute all initiation points, point-by-point, in the given range.
initiatedAtCyclic(Index, F=V, T1, T, T2):-
	\+ processedRangeInit(Index, F=V, _), !,
		%writeAll(['\t\t\tcomputeInitiationsInRange(',F=V,T1,T2,')']),
	computeInitiationsInRange(F=V, T1, T2, InitList), member(T, InitList), T>=T1, T<T2. 

% computeInitiationsInRange(+F=V, +T1, +T2, -InitList)
% Starting from time-point T1, we compute the initiation points of F=V at each time-point in [T1,T2).
% Each derived initiation point T is cached as an initiation of F=V, and a termination of F=V'.
% The next time-point T+1 after each initiation is a cyclic point of F=V with value true, and a cyclic point of F=V' with value false.
% case: stop when we reach time-point T2.
computeInitiationsInRange(_, T1, T2, []):-
	T1>=T2, !.
% case: the initiation of F=V has been processed by an intermediate query, and F=V is initiated at T1.
computeInitiationsInRange(F=V, T1, T2, [T1|Tail]):-
	nextTimePoint(T1, T1next),
        indexOf(Index,F=V),
        processedRangeInit(Index, F=V, ProcRange),
        tinIntervals(T1, ProcRange),
	startingPoints(Index, F=V, SPoints),
	member(S, SPoints), !,
	prevTimePoint(S, T1),
	addStartingPointAllVals(Index, F=V, T1),
	addProcessedRangeAllVals(Index, F=V, T1),
	addCyclicPointAllFVPs(Index, F=V, T1next, t),
	computeInitiationsInRange(F=V, T1next, T2, Tail).
% case: the initiation of F=V has been processed by an intermediate query, and F=V is not initiated at T1.
computeInitiationsInRange(F=V, T1, T2, [T1|Tail]):-
	nextTimePoint(T1, T1next),
        indexOf(Index,F=V),
        processedRangeInit(Index, F=V, ProcRange),
        tinIntervals(T1, ProcRange), !,
	addProcessedRangeInit(Index, F=V, T1),
	computeInitiationsInRange(F=V, T1next, T2, Tail).

% case: F=V is initiated at T1.
computeInitiationsInRange(F=V, T1, T2, [T1|Tail]):-
	nextTimePoint(T1, T1next),
        indexOf(Index,F=V),
	initiatedAt(F=V, T1, T1, T1next), !,
	indexOf(Index, F=V),
	addStartingPointAllVals(Index, F=V, T1),
	addProcessedRangeAllVals(Index, F=V, T1),
	addCyclicPointAllFVPs(Index, F=V, T1next, t),
	computeInitiationsInRange(F=V, T1next, T2, Tail).
% case: F=V is not initiated at T1.
computeInitiationsInRange(F=V, T1, T2, InitList):-
	nextTimePoint(T1, T1next),
	indexOf(Index, F=V),
	addProcessedRangeInit(Index, F=V, T1),
	computeInitiationsInRange(F=V, T1next, T2, InitList).

% computeInitiationsInRangeAll(+F=V, +Ranges, -FlatInits)
% Compute all the initiation points of F=V in the temporal ranges stored in list Ranges.
% The derived initiation points are stored in list FlatInits.
computeInitiationsInRangeAll(F=V, Ranges, FlatInits):-
	computeInitiationsInRangeAll0(F=V, Ranges, Inits),
	flatten(Inits, FlatInits).
% auxiliary predicate
%computeInitiationsInRangeAll0(+F=V, +Ranges, -FlatInits)
computeInitiationsInRangeAll0(_, [], []).
computeInitiationsInRangeAll0(F=V, [(T1, T2)|RestRanges], [Inits|RestInits]):-
	computeInitiationsInRange(F=V, T1, T2, Inits),
	computeInitiationsInRangeAll0(F=V, RestRanges, RestInits).

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

% The implementation of terminatedAtCyclic is very similar to that of initiatedAtCyclic.
% For further documentation, see the comments in initiatedAtCyclic.
% terminatedAtCyclic(+Index, +F=V, +T)
terminatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic1'), nl,
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),
		%write('\t\t\t\tTail: '), write(Tail), nl,
	member((_S,E), Tail),
		\+E=inf,	
	prevTimePoint(E, T), !. %, T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T) :-
	processedCyclic(Index, F=V),
		%write('\t\t\t\tprocessedCyclic2'), nl,
	simpleFPList(Index, F=V, [H|Tail], []),
		%write('\t\t\t\tList: '), write([H|Tail]), nl,
	member((_S,E), [H|Tail]), 
		\+E=inf,
	prevTimePoint(E, T), !. %, T>=T1, T<T2.

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
	computeTerminationsInRange(F=V, T, Tnext, TermList), member(T, TermList), !.
	%write('TermList: '), write(TermList), nl,
	%member(T, InitList).

% terminatedAtCyclic(+Index,+F=V,+T1,-T,+T2)
terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]), 
	member((_S,E), Tail), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	processedCyclic(Index, F=V),
	simpleFPList(Index, F=V, [H|Tail], []),
	member((_S,E), [H|Tail]), 
	prevTimePoint(E, T), T>=T1, T<T2.

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], []), !,
	endingPoints(Index, F=V, EPoints),
	member(E, EPoints), prevTimePoint(E, T), T>=T1, T<T2.
	%computeTerminationsInRange(F=V, T1, T2, TermList), member(T, TermList), T>=T1, T<T2. 

terminatedAtCyclic(Index, F=V, T1, T, T2) :-
	%storedCyclicPoints(Index, F=V, StoredPoints),
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), 
	endingPoints(Index, F=V, EPoints), !,
	(member(E, EPoints), prevTimePoint(E, T), T>=T1, T<T2 ; computeTerminationsInRangeAll(F=V, UnprocessedIntervals, TermList), member(T, TermList)).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	%write(F=V), nl,
	processedRangeTerm(Index, F=V, ProcessedRange),
	relative_complement_all([(T1,T2)], [ProcessedRange], UnprocessedIntervals), !,
	\+ endingPoints(Index, F=V, _EPoints),
	computeTerminationsInRangeAll(F=V, UnprocessedIntervals, TermList), 
	member(T, TermList), T>=T1, T<T2.
	%computeInitiationsIncremental(F=V, T1, T2, InitList),
	%member(T, InitList).

terminatedAtCyclic(Index, F=V, T1, T, T2):-
	\+ processedRangeTerm(Index, F=V, _), !,
	computeTerminationsInRange(F=V, T1, T2, TermList), member(T, TermList), T>=T1, T<T2.

% computeTerminationsInRange(+F=V, +T1, +T2, -TermList):-
computeTerminationsInRange(_, T1, T2, []):-
	T1>=T2, !.
computeTerminationsInRange(F=V, T1, T2, [T1|Tail]):- !,
	nextTimePoint(T1, T1next),
	terminatedAt(F=V, T1, T1, T1next), !,
	indexOf(Index, F=V),
	addEndingPoint(Index, F=V, T1),
	addCyclicPointAllFVPs(Index, F=V, T1next, f), 
	computeTerminationsInRange(F=V, T1next, T2, Tail).

computeTerminationsInRange(F=V, T1, T2, [T1|Tail]):-
	simpleFluent(F=V2), \+V2=V, 
	nextTimePoint(T1, T1next),
	initiatedAt(F=V2, T1, T1, T1next), !,
	indexOf(Index2, F=V2),
	addStartingPointAllVals(Index2, F=V2, T1),
	addProcessedRangeAllVals(Index2, F=V2, T1),
	addCyclicPointAllFVPs(Index2, F=V2, T1next, t),
	%write('\t\t\tcached starting point for '), write(F=V), write(' at '), write(T), write(' with value "t"'), nl,
	%simpleFluent(F=V3), \+V3=V2,
	%indexOf(Index3, F=V3),
	%addCyclicPointAllFVPs(Index3, F=V3, T1next, f), 
	%addEndingPoint(Index3, F=V3, T1, T1),
	computeTerminationsInRange(F=V, T1next, T2, Tail).
computeTerminationsInRange(F=V, T1, T2, TermList):-
	nextTimePoint(T1, T1next),
	indexOf(Index, F=V),
	addProcessedRangeTerm(Index, F=V, T1),
	%addLastProcessedPointEP(Index, F=V, T1),
	computeTerminationsInRange(F=V, T1next, T2, TermList).

% checkTerminatedAtAll(+F=V, +Ranges, -FlatTerms)
computeTerminationsInRangeAll(F=V, Ranges, FlatTerms):-
	computeTerminationsInRangeAll0(F=V, Ranges, Terms), !,
	flatten(Terms, FlatTerms).
% auxiliary predicate
% computeTerminationsInRangeAll0(+F=V, +Ranges, -FlatTerms)
computeTerminationsInRangeAll0(_, [], []):- !.
computeTerminationsInRangeAll0(F=V, [(T1, T2)|RestRanges], [Terms|RestTerms]):-
	computeTerminationsInRange(F=V, T1, T2, Terms),
	computeTerminationsInRangeAll0(F=V, RestRanges, RestTerms).

%%%%%%% Auxiliary predicates for initiatedAtCyclic/terminatedAtCyclic %%%%%%%%%%

% addStartingPointsAllVals(+Index, +F=V, +SPoints)
addStartingPointsAllVals(_Index, _U, []).
addStartingPointsAllVals(Index, F=V, [SPoint|RestSPoints]):-
    prevTimePoint(SPoint,InitPoint),
    addStartingPointAllVals(Index, F=V, InitPoint),
    addStartingPointsAllVals(Index, F=V, RestSPoints).

% addStartingPointAllVals(+Index, +F=V, +InitPoint)
addStartingPointAllVals(Index, F=V, InitPoint):-
	addStartingPoint(Index, F=V, InitPoint),
	simpleFluent(F=V2), \+V=V2,
	indexOf(Index2, F=V2),
	addEndingPoint(Index2, F=V2, InitPoint).

% addEndingPoint(+Index, +F=V, +TermPoint)
addEndingPoint(Index, F=V, TermPoint):-
	retract(endingPoints(Index, F=V, EPoints)), !,
	addProcessedRangeTerm(Index, F=V, TermPoint),
	nextTimePoint(TermPoint, EPoint),
	insertNo(EPoint, EPoints, NewEPoints),
	%max(LastProcessedPoint, PrevLPPoint),
	assertz(endingPoints(Index, F=V, NewEPoints)).
addEndingPoint(Index, F=V, TermPoint) :-
	addProcessedRangeTerm(Index, F=V, TermPoint),
	nextTimePoint(TermPoint, EPoint),
	assertz(endingPoints(Index, F=V, [EPoint])).

% addCyclicPointAllFVPs(+Index,+F=V,+T,+Val)
addCyclicPointAllFVPs(Index, F=V, T, t):-
	addCyclicPoint(Index, F=V, T, t), 
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addCyclicPoint(Index2, F=V2, T, f).
addCyclicPointAllFVPs(Index, F=V, T, f):-
	addCyclicPoint(Index, F=V, T, f).

% addProcessedRangeInit(+Index,+F=V,+T)
addProcessedRangeInit(Index, F=V, T):-
	retract(processedRangeInit(Index, F=V, OldProcessedIntervals)), !,
	nextTimePoint(T, Tnext),
	union_all([[(T,Tnext)], OldProcessedIntervals], NewProcessedRange),
	assertz(processedRangeInit(Index, F=V, NewProcessedRange)).
addProcessedRangeInit(Index, F=V, T):-
	nextTimePoint(T, Tnext),
	assertz(processedRangeInit(Index, F=V, [(T,Tnext)])).

% addProcessedRangeTerm(+Index, +F=V, +T):-
addProcessedRangeTerm(Index, F=V, T):-
	retract(processedRangeTerm(Index, F=V, OldProcessedIntervals)), !,
	nextTimePoint(T, Tnext),
	union_all([[(T,Tnext)], OldProcessedIntervals], NewProcessedRange),
	%computeNewProcessedRange(T, [Tlow, Thigh], NewProcessedRange),
	assertz(processedRangeTerm(Index, F=V, NewProcessedRange)).
addProcessedRangeTerm(Index, F=V, T):-
	nextTimePoint(T, Tnext),
	assertz(processedRangeTerm(Index, F=V, [(T, Tnext)])).

% addProcessedRangeAllVals(+Index,+F=V,+T):-
addProcessedRangeAllVals(Index,F=V,T):-
	addProcessedRangeInit(Index,F=V,T),
	simpleFluent(F=V2), \+V2=V,
	indexOf(Index2, F=V2),
	addProcessedRangeTerm(Index2,F=V2,T).


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

holdsForProcessedSimpleFluent(_Index, _U, []).

% cached output entity/statically determined fluent
holdsForProcessedSDFluent(Index, F=V, L) :- 
  	sdFPList(Index, F=V, L, _), !.

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
	tinIntervals(T, [H|Tail]).

% cached output entity/statically determined fluent
holdsAtProcessedSDFluent(Index, F=V, T) :- 
  	sdFPList(Index, F=V, [H|Tail], _),
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
	member((S,_E), Tail).
happensAtProcessedSimpleFluent(Index, startI(F=V), S) :-
	simpleFPList(Index, F=V, [H|Tail], []),
	member((S,_E), [H|Tail]).
% compute the starting points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, startI(F=V), S) :-
	sdFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),  
	member((S,_E), Tail).
happensAtProcessedSDFluent(Index, startI(F=V), S) :-
	sdFPList(Index, F=V, [H|Tail], []), 
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
	member((S,_E), Tail), prevTimePoint(S, T).
happensAtProcessedSimpleFluent(Index, start(F=V), T) :-
	simpleFPList(Index, F=V, [H|Tail], []),
	member((S,_E), [H|Tail]), prevTimePoint(S, T).
% compute the starting points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, start(F=V), T) :-
	sdFPList(Index, F=V, [(IntervalBreakingPoint,_)|Tail], [(_,IntervalBreakingPoint)]),  
	member((S,_E), Tail), prevTimePoint(S, T).
happensAtProcessedSDFluent(Index, start(F=V), T) :-
	sdFPList(Index, F=V, [H|Tail], []), 
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
	member((_S,E), [H|Tail]), 
	\+ E=inf, prevTimePoint(E, T).
% compute the ending points of output entities/statically determined fluents
happensAtProcessedSDFluent(Index, end(F=V), T) :-
	sdFPList(Index, F=V, [H|Tail], _), 
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
	amalgamatePeriods(Extension, RestrictedList, L).

retrieveOEIntervals(_Index, _U, []).


retrieveOESDFluentIntervals(Index, F=V, L) :-
	sdFPList(Index, F=V, RestrictedList, Extension), !,
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

% retrieve the time-points of output entities
happensAt(E, T) :-
	event(E), 
	% cachingOrder2/2 is produced in the compilation stage 
	% by combining cachingOrder/1, indexOf/2 and grounding/1
	cachingOrder2(Index, E),
	happensAtProcessed(Index, E, T).

