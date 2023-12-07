% these predicates are defined in this file
% and may also be defined in an event description
:- multifile initiatedAt/4, maxDuration/3.

:- dynamic inertiaCheck/1.

maxDuration(F=V, F=NewV, Duration) :-
	maxDurationUE(F=V, F=NewV, Duration).	

%%% initiatedAt(+U, +T1, -T, +T2) %%%	
% initiatedAt/4 for deadline fluents	
initiatedAt(F=NewV, T1, T, T2) :-
		getCPUtime(T1dInits),
        maxDuration(F=V, F=NewV, Duration),
        % do not evaluate dInitiatedAt/5 clauses to look for breaking points 
        % of F=V between an initiation of F=V and its deadline 
        % when the duration of F=V may be extended
	\+ inertiaCheck(F=V),
	% initiatedAt incarnation for deadline fluents:
        dInitiatedAt(F=V, Duration, T1, T, T2),
        	getCPUtime(T2dInits), %% Some T is not bound (when I skip logs wtf).
        	updateTimeTemp(process_deadline_initiations, T1dInits, T2dInits),
        	updateVariableTemp(deadline_initiation_instances, 1).
        	%write(F=V), nl,
        	%write(F=NewV), nl,
        	%write(Duration), nl, nl.

%%% dInitiatedAt(+(F=V), +Duration, +T1, -T, +T2) %%%	
        
% the rule below deals with the case where the initiation of a fluent-value pair 
% that is subject to deadlines takes place within the working memory	
dInitiatedAt(F=V, Duration, T1, T, T2) :-
	EarlierT2 is T2-Duration, 
	initTime(InitTime), 
	EarlierT2>InitTime,
	T1MinusDuration is T1-Duration, 
	calcEarlyBoundary(InitTime, T1MinusDuration, EarlierT1),
	% sanity check:
	EarlierT2>EarlierT1,
        indexOf(Index, F=V), 
        % the disjunction below computes the initiation point of F=V
	initiatedAt(F=V, EarlierT1, EarlierT, EarlierT2),
	%%% For the naive implementation, we never consult the cache.
	/*
	(
            % for cyclic fluents we cannot restrict attention to stored starting points
            % we have to also evaluate initiatedAt 
            cyclic(F=V),
            initiatedAt(F=V, EarlierT1, EarlierT, EarlierT2) 
            % it proved insufficient to store the above starting point
            ;
            \+ cyclic(F=V),
            % instead of evaluating initiatedAt, look for cached starting points 
            startingPoints(Index, F=V, SPoints), 
            member(EarlierTNext, SPoints), 
            prevTimePoint(EarlierTNext, EarlierT) 
	),
	*/
	% make sure that the initiating point in within the correct range
	EarlierT1=<EarlierT, EarlierT<EarlierT2,		
	nextTimePoint(EarlierT, NextEarlierT),
	T is EarlierT+Duration,
	deadlineConditionsNaive(Index, F=V, NextEarlierT, T).
	    
% the rule below deals with the case where the initiation of a fluent-value pair 
% that is subject to deadlines takes place before the working memory
dInitiatedAt(F=V, Duration, T1, T, T2) :-
        indexOf(Index, F=V),
	happensAtProcessed(Index, attempt(F=V), T), T1=<T, T<T2, 
	% attempt(F=V) was caused by events taking place before or on Qi-WM 
	EarlyT is T-Duration, 
	initTime(InitTime), 
	EarlyT=<InitTime,
	nextTimePoint(InitTime, NextInitTime),
	deadlineConditionsNaive(Index, F=V, NextInitTime, T).	

	
%%% deadlineConditions(+Index, +(F=V), +T1, +T2) %%%	
	
% fluent duration MAY be extended
% ie F=V must not be re-initiated and must not be broken in [T1,T2) 
deadlineConditions(Index, F=V, T1, T2) :-
	maxDurationUE(F=V, _, _), 
	% extend the period in which we look for re-initiations
	% so that a re-initiation takes precedence over the deadline  
	% (the deadline will not take place)
	nextTimePoint(T2, NextT2),
	\+ startedBetween4(Index, F=V, T1, NextT2),
	% assert inertiaCheck flag to avoid going through dinitiatedAt/5 clauses
	% in the evaluation of brokenOnceRange 
	assert(inertiaCheck(F=V)),
	\+ brokenOnceRange(Index, F=V, T1, T2), !,
	% retract the above flag
	retract(inertiaCheck(F=V)).
% fluent duration MAY be extended	
% the clause below deals with the case in which F=V is broken
% in this case we need to retract the inertiaCheck flag 
% and indicate failure of deadlineConditions
deadlineConditions(_Index, F=V, _T1, _T2) :-
        maxDurationUE(F=V, _, _), !,
	retract(inertiaCheck(F=V)),
	fail.
% fluent duration MAY NOT be extended	
% ie F=V must not be broken in [T1,T2)
% for fluents that may not be extended we do not check re-initiations
deadlineConditions(Index, F=V, T1, T2) :-
	\+ brokenOnceRange(Index, F=V, T1, T2).	
	
	
%%% brokenOnceRange(+Index, +F=V, +T1, +T2) %%%		
% F=V is broken in [T1,T2)
brokenOnceRange(Index, F=V, T1, T2) :-
	brokenOnce(Index, F=V, T1, _, T2).		
	
	
%%% startedBetween4(+Index, +F=V, +T1, +T2) %%%
startedBetween4(_, _, T1, T2) :- T1>=T2, !, false.
% F=V is initiated in [T1,T2)
% for non-cyclic fluents we can restrict the search to cached starting points
startedBetween4(Index, F=V, T1, T2) :-
	startingPoints(Index, F=V, SPoints),
	member(SPoint, SPoints), 
	prevTimePoint(SPoint, T), 
	T1=<T, !, T<T2.
% for cyclic fluents we may have to additionally evaluate initiatedAt
startedBetween4(_Index, F=V, T1, T2) :-
        cyclic(F=V),
	initiatedAt(F=V, T1, _, T2), !.

	
% calcEarlyBoundary(+InitTime, +T1MinusDuration, -EarlierT1)        
calcEarlyBoundary(InitTime, T1MinusDuration, EarlierT1) :-
	T1MinusDuration=<InitTime, !,
        nextTimePoint(InitTime, EarlierT1).
%T1MinusDuration>InitTime,        
calcEarlyBoundary(_, EarlierT1, EarlierT1).        

%%%%%%%%% Naive Implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%%% deadlineConditions(+Index, +(F=V), +T1, +T2) %%%	
	
% fluent duration MAY be extended
% ie F=V must not be re-initiated and must not be broken in [T1,T2) 
deadlineConditionsNaive(Index, F=V, T1, T2) :-
	%write('naive eval'), nl,
	maxDurationUE(F=V, _, _), 
	% extend the period in which we look for re-initiations
	% so that a re-initiation takes precedence over the deadline  
	% (the deadline will not take place)
	nextTimePoint(T2, NextT2),
	\+ startedBetween4Naive(Index, F=V, T1, NextT2),
	% assert inertiaCheck flag to avoid going through dinitiatedAt/5 clauses
	% in the evaluation of brokenOnceRange 
	assert(inertiaCheck(F=V)),
	\+ brokenOnceRangeNaive(Index, F=V, T1, T2), !,
	% retract the above flag
	retract(inertiaCheck(F=V)).
% fluent duration MAY be extended	
% the clause below deals with the case in which F=V is broken
% in this case we need to retract the inertiaCheck flag 
% and indicate failure of deadlineConditions
deadlineConditionsNaive(_Index, F=V, _T1, _T2) :-
        maxDurationUE(F=V, _, _), !,
	retract(inertiaCheck(F=V)),
	fail.
% fluent duration MAY NOT be extended	
% ie F=V must not be broken in [T1,T2)
% for fluents that may not be extended we do not check re-initiations
deadlineConditionsNaive(Index, F=V, T1, T2) :-
	\+ brokenOnceRangeNaive(Index, F=V, T1, T2).	


