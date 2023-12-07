/****************************************************************
 *                                                              *
 * A chaired Floor Control Protocol (cFCP)                      * 
 *                                                              *
 *                                                              *
 * Implemented in Eclipse Prolog                                *
 ****************************************************************/

:- set_flag(all_dynamic, on).
:- use_module(library(lists)). 



/************************* 
 * EVENT CALCULUS AXIOMS *
 *************************/


holdsAt(Fluent, T) :-
	initially(Fluent),
	\+ broken(Fluent, 0, T).

holdsAt(Fluent, T) :-
	happens(Event, EarlyTime),
	EarlyTime < T,
	initiates(Event, Fluent, EarlyTime),
	\+ broken(Fluent, EarlyTime, T).

broken(Fluent, T1, T3) :-
	happens(Event, T2),
	T1 =< T2,
	T2 < T3,
	terminates(Event, Fluent, T2).

terminates(Event, Fluent = V, T) :-
	initiates(Event, Fluent = V2, T),
	\+ (V = V2).


/*************** 
 * RIGID FACTS *
 ***************/


rigid( role_of(c)  = chair  ).     % agent 'c' occupies the role of the chair
rigid( role_of(sub1) = subject ).  % agent 'sub1' occupies the role of the subject
rigid( role_of(sub2) = subject ).  % agent 'sub2' occupies the role of the subject
rigid( role_of(sub3) = subject ).  % agent 'sub3' occupies the role of the subject



/*************************************
 * SYNTAX OF ACTIONS                 *
 *                                   *
 * request_floor(subject, chair)     *
 * assign_floor(chair, subject)      *
 * extend_assignment(chair, subject) *
 * revoke_floor(chair)               *
 * release_floor(subject)            *
 * manipulate_resource(subject)      *
 *************************************/                          


/*****************
 * INITIAL STATE *
 *****************/


% ----- We specify the value of every simple fluent at the initial state 

initially( status = free ).

% ----- initially no agent is sanctioned

initially( s1(c) = 0 ).
initially( s1(sub1) = 0 ).
initially( s1(sub2) = 0 ).
initially( s1(sub3) = 0 ).

% ----- the value of 'pow', 'per', `obl' and so on,      
% ----- is determined by state constraints                     

initially( Fluent = false ) :-
	\+ ( Fluent = status ),
	\+ ( Fluent = pow(_, _) ),
	\+ ( Fluent = per(_, _) ),
	\+ ( Fluent = obl(_, _) ),
	\+ ( Fluent = best_candidate ),
	\+ ( Fluent = s1(_) ),
	\+ ( Fluent = s2(_) ),
	\+ initially( Fluent = true ).


/***********************
 * INSTITUTIONAL POWER *
 ***********************/


% ----- we associate institutional power only with the `request_floor' action

% ----- an agent is empowered to request the floor if it doesn't have a pending 
% ----- request and not accumulated too many sanctions (less than 5)

holdsAt( pow(Subject, request_floor(Subject, Chair)) = true, T ) :-
	rigid( role_of(Subject) = subject ),
	rigid( role_of(Chair) = chair ),
	holdsAt( requested(Subject, T2) = false, T ),
	holdsAt( s1(Subject) = SanctionValue, T ),
	( SanctionValue < 5 ).	

holdsAt( pow(Agent, Action) = false, T ) :-
	\+ holdsAt( pow(Agent, Action) = true, T ).


/**************
 * PERMISSION *
 **************/


holdsAt( per(Subject, request_floor(Subject, Chair)) = true, T ) :-
	holdsAt( pow(Subject, request_floor(Subject, Chair)) = true, T ).

holdsAt( per(Chair, assign_floor(Chair, Subject)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ),
	holdsAt( best_candidate = Subject, T ).

holdsAt( per(Chair, extend_assignment(Chair, Subject)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, ExpiryTime), T ),
	holdsAt( best_candidate = Subject, T ).

holdsAt( per(Chair, revoke_floor(Chair)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, Expiry), T ),
	(T >= Expiry),
	\+ holdsAt( best_candidate = Subject, T ).

holdsAt( per(Subject, release_floor(Subject)) = true, T ) :-
	holdsAt( status = granted(Subject, Expiry), T ).

holdsAt( per(Subject, manipulate_resource(Subject)) = true, T ) :-
	holdsAt( status = granted(Subject, Expiry), T ),
	( T < Expiry ).

holdsAt( per(Agent, Action) = false, T ) :-
	\+holdsAt( per(Agent, Action) = true, T ).


/**************
 * OBLIGATION *
 **************/


holdsAt( obl(Chair, assign_floor(Chair, Subject)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ),
	holdsAt( best_candidate = Subject, T ).

holdsAt( obl(Chair, extend_assignment(Chair, Subject)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, ExpiryTime), T ),
	holdsAt( best_candidate = Subject, T ).

% ----- the chair is obliged to revoke the floor if
% ----- (i) the floor is already granted
% ----- (ii) the allowed time of having the floor has expired
% ----- (iii) there is another best candidate

% ----- if the allowed time of holding the floor has expired and there is noone
% ----- requesting the floor, then the chair is permitted but not obliged to 
% ----- revoke the floor 

holdsAt( obl(Chair, revoke_floor(Chair)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, Expiry), T ),
	(T >= Expiry),
	holdsAt( best_candidate = Subject2, T ),
	\+ ( Subject = Subject2 ).

holdsAt( obl(Subject, release_floor(Subject)) = true, T ) :-
	holdsAt( status = granted(Subject, Expiry), T ),
	(T >= Expiry),
	holdsAt( best_candidate = Subject2, T ),
	\+ ( Subject = Subject2 ).

holdsAt( obl(Agent, Action) = false, T ) :-
	\+holdsAt( obl(Agent, Action) = true, T ).


/************
 * SANCTION *
 ************/

/**********************************************************************
 * we express sanctions by means of two fluents:                      *
 * (i) s1, expressing non-compliance with the obligation to assign    *
 * the floor, and revoking and extending the assignment of the floor  *
 * when being forbidden to do so, and                                 *
 * (ii) s2, expressing non-compliance with the obligation to revoke   *
 * and release the floor                                              *
 *								      *
 * Due to space limitations, a simpler account of sanction is         *
 * presented in the paper					      *
 **********************************************************************/


% ----- assigning the floor not to the best candidate is 
% ----- considered 'anti-social' behaviour

initiates(assign_floor(Chair, Subject), s1(Chair) = Value, T) :-
	rigid( role_of(Subject) = subject ),
	holdsAt( obl(Chair, assign_floor(Chair, Subject2)) = true, T ),
	\+ ( Subject = Subject2),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- revoking the floor when not permitted to do so
% ----- is considered 'anti-social' behaviour

initiates(revoke_floor(Chair), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( per(Chair, revoke_floor(Chair)) = false, T ),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- extending an assignment when not permitted to do so
% ----- is considered 'anti-social' behaviour

initiates(extend_assignment(Chair, Subject), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( per(Chair, extend_assignment(Chair, Subject)) = false, T ),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- as long as the chair does not comply with its obligation to
% ----- revoke the floor, an additive sanction is created

holdsAt( s2(Chair) = Value, T ) :-
	holdsAt( obl(Chair, revoke_floor(Chair)) = true, T ),
	holdsAt( status = granted(Subject, Expiry), T ),
	( T > Expiry ),
	( Value is T - Expiry ).

% ----- the value of s2 is added to the value of s1 when the chair
% ----- revokes the floor or when the subject holding the floor
% ----- releases the floor. In either case, the chair's obligation
% ----- to revoke the floor is 'deleted'.

initiates(revoke_floor(Chair), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( s1(Chair) = S1Prev, T ),
	holdsAt( s2(Chair) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).

initiates(release_floor(Subject), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, Expiry), T ),
	holdsAt( s1(Chair) = S1Prev, T ),
	holdsAt( s2(Chair) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).

% ----- as long as the holder does not comply with its obligation to
% ----- release the floor, an additive sanction is created

holdsAt( s2(Subject) = Value, T ) :-
	holdsAt( obl(Subject, release_floor(Subject)) = true, T ),
	holdsAt( status = granted(Subject, Expiry), T ),
	( T > Expiry ),
	( Value is T - Expiry ).

% ----- the value of s2 is added to the value of s1 when the chair
% ----- revokes the floor or when the subject holding the floor
% ----- releases the floor. In either case, the holder's obligation
% ----- to release the floor is 'deleted'.

initiates(revoke_floor(Chair), s1(Subject) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, Expiry), T ),
	holdsAt( s1(Subject) = S1Prev, T ),
	holdsAt( s2(Subject) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).

initiates(release_floor(Subject), s1(Subject) = Value, T) :-
	holdsAt( status = granted(Subject, Expiry), T ),
	holdsAt( s1(Subject) = S1Prev, T ),
	holdsAt( s2(Subject) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).


/***************** 
 * request_floor *
 *****************/


initiates(request_floor(Subject, Chair), requested(Subject, T) = true, T) :-
	holdsAt( pow(Subject, request_floor(Subject, Chair)) = true, T ).


/**************** 
 * assign_floor *
 ****************/


% ----- the floor is granted for the next 5 time-points

initiates(assign_floor(Chair, Subject), status = granted(Subject, Expiry), T) :-
	rigid( role_of(Chair) = chair ),
	rigid( role_of(Subject) = subject ),
	holdsAt( status = free, T ),
	( Expiry is T + 5 ).

initiates(assign_floor(Chair, Subject), requested(Subject, T2) = false, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ),
	holdsAt( requested(Subject, T2) = true, T ).


/********************* 
 * extend_assignment *
 *********************/


% ----- prolong the time of having the floor

initiates(extend_assignment(Chair, Subject), status = granted(Subject, ExtendedExpiry), T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, ExpiryTime), T ),
	( ExtendedExpiry is T + 5 ).

initiates(extend_assignment(Chair, Subject), requested(Subject, T2) = false, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, ExpiryTime), T ),
	holdsAt( requested(Subject, T2) = true, T ).


/**************** 
 * revoke_floor *
 ****************/


initiates(revoke_floor(Chair), status = free, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Subject, Expiry), T ).


/***************** 
 * release_floor *
 *****************/


initiates(release_floor(Subject), status = free, T) :-
	holdsAt( status = granted(Subject, Expiry), T ).


/************************ 
 * AUXILIARY PREDICATES *
 ************************/


% ----- this is an application-specific predicate: calculating the best
% ----- candidate for the floor at each time-point
% ----- in this example the best candidate is the one that submitted
% ----- first a valid request for the floor

holdsAt(best_candidate = Subject, T) :-
	setof((RequestTime, B), holdsAt( requested(B, RequestTime) = true, T ), [H|Tail]),
	(H = (_, Subject)).

% ----- retrieve information about each agent in a coherent manner

holdsAt(description_of(Agent, State), T) :-
	findall(Role,      rigid(   role_of(Agent) = Role           ), Roles),
	findall(PAction,   holdsAt( pow(Agent, PAction) = true,   T ), PActions),
	findall(PerAction, holdsAt( per(Agent, PerAction) = true, T ), PerActions),
	findall(OAction,   holdsAt( obl(Agent, OAction) = true,   T ), OActions),
	findall(Agent,     holdsAt( sanctioned(Agent) = true,     T ), SList),
	append([roles(Roles)],     [permissions(PerActions)], Temp1),
	append([powers(PActions)], [obligations(OActions)],   Temp2),
	append(Temp1, Temp2, Temp12),
	append(Temp12, [sanctions(SList)], State).


/*************
 * NARRATIVE *
 *************/


% ----- this is an example narrative, that is, a list of externally observable
% ----- events of a run of a cFCP

% ----- sub3 requests the floor 

happens(request_floor(sub3, c),     1).

% ----- sub2 requests the floor

happens(request_floor(sub2, c),     2).     

% ----- c assigns the floor to sub2 although sub2 is not the best candidate

happens(assign_floor(c, sub2),      3).  

% ----- c extends the assignment of holding the floor although the holder sub2 
% ----- did request it

happens(extend_assignment(c, sub2), 4). 

% ----- sub1 requests the floor

happens(request_floor(sub1, c),     5).

% ----- c revokes the floor 6 time-points after the allocated time expired

happens(revoke_floor(c),          15).

% ----- sub2 requests the floor

happens(request_floor(sub2, c),     16).
