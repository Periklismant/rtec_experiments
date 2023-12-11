
% these predicates are defined in this file
% and may also be defined in an event description
:- multifile initiatedAt/4, fi/3, p/1.

:- dynamic inertiaCheck/1.

%%% initiatedAt(+U, +T1, -T, +T2) %%%	
% initiatedAt/4 for deadline fluents	
initiatedAt(F=NewV, T1, T, T2) :-
        fi(F=V, F=NewV, Duration),
        	%updateVariableTemp(rule_evaluations, 1),
        % do not evaluate dInitiatedAt/5 clauses to look for breaking points 
        % of F=V between an initiation of F=V and its deadline 
        % when the duration of F=V may be extended
	\+ inertiaCheck(F=V),
	% initiatedAt incarnation for deadline fluents:
        dInitiatedAt(F=V, Duration, T1, T, T2),
        	updateVariableTemp(rule_evaluations, 1).

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
        initiatedAt(F=V, EarlierT1, EarlierT, EarlierT2),
	% make sure that the initiating point in within the correct range
	EarlierT1=<EarlierT, EarlierT<EarlierT2,		
	nextTimePoint(EarlierT, NextEarlierT),
	T is EarlierT+Duration,
	deadlineConditions(Index, F=V, NextEarlierT, T).
	    
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
	deadlineConditions(Index, F=V, NextInitTime, T).	

%%%%%%%%% Naive Implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
	
%%% deadlineConditions(+Index, +(F=V), +T1, +T2) %%%	
	
% fluent duration MAY be extended
% ie F=V must not be re-initiated and must not be broken in [T1,T2) 
deadlineConditions(Index, F=V, T1, T2) :-
	p(F=V),
	% extend the period in which we look for re-initiations
	% so that a re-initiation takes precedence over the deadline  
	% (the deadline will not take place)
	nextTimePoint(T2, NextT2),
	\+ startedBetween4(Index, F=V, T1, NextT2),
	% assert inertiaCheck flag to avoid going through dinitiatedAt/5 clauses
	% in the evaluation of brokenOnceRange 
	assertz(inertiaCheck(F=V)),
	\+ brokenOnceRange(Index, F=V, T1, T2), !,
	% retract the above flag
	retract(inertiaCheck(F=V)).
% fluent duration MAY be extended	
% the clause below deals with the case in which F=V is broken
% in this case we need to retract the inertiaCheck flag 
% and indicate failure of deadlineConditions
deadlineConditions(_Index, F=V, _T1, _T2) :-
	p(F=V), !,
	retract(inertiaCheck(F=V)),
	fail.
% fluent duration MAY NOT be extended	
% ie F=V must not be broken in [T1,T2)
% for fluents that may not be extended we do not check re-initiations
deadlineConditions(Index, F=V, T1, T2) :-
	\+ brokenOnceRange(Index, F=V, T1, T2).	
	
%%% brokenOnceRange(+Index, +F=V, +T1, +T2) %%%		
%% naive implementation: always invoke rules.
brokenOnceRange(_Index, F=V, T1, T2) :-
        terminatedAt(F=V, T1, _, T2), !.
brokenOnceRange(_Index, F=V, T1, T2) :-
        simpleFluent(F=V2), \+V2=V,
        initiatedAt(F=V2, T1, _, T2), !.

%%% startedBetween4(+Index, +F=V, +T1, +T2) %%%
startedBetween4(_, _, T1, T2) :- T1>=T2, !, false.
% naive implementation: always invoke rules.
startedBetween4(_Index, F=V, T1, T2) :-
	initiatedAt(F=V, T1, _, T2), !.

%%%%%%%%%%%%%% Naive implementation end %%%%%%%%%%%%%%%%%%%%
	
% calcEarlyBoundary(+InitTime, +T1MinusDuration, -EarlierT1)        
calcEarlyBoundary(InitTime, T1MinusDuration, EarlierT1) :-
	T1MinusDuration=<InitTime, !,
        nextTimePoint(InitTime, EarlierT1).
%T1MinusDuration>InitTime,        
calcEarlyBoundary(_, EarlierT1, EarlierT1).        
