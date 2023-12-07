/****************************************************************
 *                                                              *
 * FCP in the Event Calculus (Marek's version).                 * 
 *                                                              *
 ****************************************************************/

:- set_flag(all_dynamic, on).
:- use_module(library(lists)). 

:- [examplenarrative].


/************* 
 * EC ENGINE *
 *************/


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


rigid( role_of(c)  = chair  ).
rigid( role_of(b1) = bidder ).
rigid( role_of(b2) = bidder ).
rigid( role_of(b3) = bidder ).



/*******************************
 * SYNTAX OF ACTION CONSTANTS: *
 *                             *
 * request_floor(bidder)       *
 * assign_floor(bidder)        *
 * extend_assignment(bidder)   *
 * revoke_floor                *
 * release_floor(bidder)       *
 *******************************/                          


/*****************
 * INITIAL STATE *
 *****************/


% ----- We specify the value of every simple fluent at the initial state 

initially( status = free ).

% ----- initially no agent is sanctioned

initially( s1(c) = 0 ).
initially( s1(b1) = 0 ).
initially( s1(b2) = 0 ).
initially( s1(b3) = 0 ).

% ----- 'pow', 'permitted', `obliged' and so on are statically determined fluents     
% ----- and, therefore, their value is determined by state constraints                     

initially( Fluent = false ) :-
	\+ ( Fluent = status ),
	\+ ( Fluent = pow(_, _) ),
	\+ ( Fluent = permitted(_, _) ),
	\+ ( Fluent = obliged(_, _) ),
	\+ ( Fluent = entitled(_, _) ),
	\+ ( Fluent = best_candidate ),
	\+ ( Fluent = s1(_) ),
	\+ ( Fluent = s2(_) ),
	\+ initially( Fluent = true ).


/***********************
 * INSTITUTIONAL POWER *
 ***********************/


% ----- we treat only the `request_floor' action as a communicative one
% ----- therefore, we associate institutional power only with that action

% ----- an agent is empowered to request the floor if it has a pending 
% ----- request and it has not accumulated too many sanctions (less than 5)

holdsAt( pow(Bidder, request_floor(Bidder)) = true, T ) :-
	\+ rigid( role_of(Bidder) = chair ),
	holdsAt( requested(Bidder, T2) = false, T ),
	holdsAt( s1(Bidder) = SanctionValue, T ),
	( SanctionValue < 5 ).	

% ----- we need to add an axiom concerning the power to request;
% ----- the extra axiom should calculate the value of the s2 fluent

holdsAt( pow(Agent, Action) = false, T ) :-
	\+ holdsAt( pow(Agent, Action) = true, T ).


/**************
 * PERMISSION *
 **************/


holdsAt( permitted(Bidder, request_floor(Bidder)) = true, T ) :-
	holdsAt( pow(Bidder, request_floor(Bidder)) = true, T ).


% ----- 'assign_floor', 'revoke_floor' and 'release_floor' are treated as
% ----- brute actions and, therefore, only permission is associated with these

holdsAt( permitted(Chair, assign_floor(Bidder)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ),
	holdsAt( best_candidate = Bidder, T ).

% ----- extending an assignment when the floor is free makes no sense
% ----- however it is permitted to do so 

holdsAt( permitted(Chair, extend_assignment(Bidder)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ).

holdsAt( permitted(Chair, extend_assignment(Bidder)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Bidder, ExpiryTime), T ),
	holdsAt( best_candidate = Bidder, T ).

% ----- revoking the floor when the floor is free makes no sense
% ----- however it is permitted to do so 

holdsAt( permitted(Chair, revoke_floor) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ).

holdsAt( permitted(Chair, revoke_floor) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Bidder, Expiry), T ),
	(T >= Expiry),
	\+ holdsAt( best_candidate = Bidder, T ).

holdsAt( permitted(Bidder, release_floor(Bidder)) = true, T ) :-
	holdsAt( status = granted(Bidder, Expiry), T ).

holdsAt( permitted(Agent, Action) = false, T ) :-
	\+holdsAt( permitted(Agent, Action) = true, T ).


/**************
 * OBLIGATION *
 **************/


holdsAt( obliged(Chair, assign_floor(Bidder)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = free, T ),
	holdsAt( best_candidate = Bidder, T ).

holdsAt( obliged(Chair, extend_assignment(Bidder)) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Bidder, ExpiryTime), T ),
	holdsAt( best_candidate = Bidder, T ).

% ----- the chair is obliged to revoke the floor if
% ----- (i) the floor is already granted
% ----- (ii) the allowed time of having the floor has expired
% ----- (iii) there is another best candidate

% ----- if the allowed time of having the floor has expired and there is noone
% ----- requesting the floor, then the chair is permitted but not obliged to 
% ----- revoke the floor 

holdsAt( obliged(Chair, revoke_floor) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Bidder, Expiry), T ),
	(T > Expiry),
	holdsAt( best_candidate = Bidder2, T ),
	\+ ( Bidder = Bidder2 ).

% ----- the chair is obliged to revoke the floor after the expiry time
% ----- whereas the bidder is obliged to release the floor AT the 
% ----- expiry time, i.e. if the bidder does not immediately release
% ----- floor at the expiry time then the chair is obliged to revoke the floor

holdsAt( obliged(Bidder, release_floor(Bidder)) = true, T ) :-
	holdsAt( status = granted(Bidder, Expiry), T ),
	(T >= Expiry),
	holdsAt( best_candidate = Bidder2, T ),
	\+ ( Bidder = Bidder2 ).

holdsAt( obliged(Agent, Action) = false, T ) :-
	\+holdsAt( obliged(Agent, Action) = true, T ).


/***************
 * ENTITLEMENT *
 ***************/

% ----- a bidder is entitled to have the floor if the chair is obliged
% ----- to assign the floor to the bidder, ie if the floor is free and
% ----- the bidder is the best candidate

holdsAt( entitled(Bidder, floor) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( obliged(Chair, assign_floor(Bidder)) = true, T ).

% ----- a bidder is entitled to have the floor if the chair is obliged
% ----- to revoke the floor and the bidder is the best candidate

holdsAt( entitled(Bidder, floor) = true, T ) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( obliged(Chair, revoke_floor) = true, T ),
	holdsAt( best_candidate = Bidder, T ).

% ----- a bidder is entitled to have the floor if it already has the floor,
% ----- it was assigned the floor in a 'correct' manner and the assignment
% ----- has not expired

holdsAt( entitled(Bidder, floor) = true, T ) :-
	holdsAt( status = granted(Bidder, Expiry), T ),
	( T =< Expiry ),
	holdsAt( correct_assignment = true, T).
	
holdsAt( entitled(Agent, Action) = false, T ) :-
	\+holdsAt( entitled(Agent, Action) = true, T ).

% ----- SHOULD WE ADD THE FOLLOWING TYPE OF ENTITLEMENT: a bidder b is entitled
% ----- to have the floor if a bidder b' has the floor, b' was assigned the 
% ----- floor in an 'incorrect' manner, and b is the best candidate
% ----- Note that in this case we will have entitlement without obligation on 
% ----- the chair to assign the floor (however, the chair will be sanctioned for
% ----- assigning the floor in an 'incorrect' manner) 


/************
 * SANCTION *
 ************/

/*************************************************
 * we express sanctions by means of two fluents: *
 * s1, a simple fluent and                       *
 * s2, a statically determined fluent            *
 *************************************************/


% ----- assigning the floor not to the best candidate is 
% ----- considered 'anti-social' behaviour

initiates(assign_floor(Bidder), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( obliged(Chair, assign_floor(Bidder2)) = true, T ),
	\+ (Bidder = Bidder2),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- revoking the floor when not permitted to do so
% ----- is considered 'anti-social' behaviour

initiates(revoke_floor, s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( permitted(Chair, revoke_floor) = false, T ),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- extending an assignment when not permitted to do so
% ----- is considered 'anti-social' behaviour

initiates(extend_assignment(Bidder), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( permitted(Chair, extend_assignment(Bidder)) = false, T ),
	holdsAt( s1(Chair) = Prev, T ),
	( Value is Prev + 1 ).

% ----- as long as the chair does not comply with its obligation to
% ----- revoke the floor, an additive sanction is created

holdsAt( s2(Chair) = Value, T ) :-
	holdsAt( obliged(Chair, revoke_floor) = true, T ),
	holdsAt( status = granted(Bidder, Expiry), T ),
	( Temp is Expiry + 1),
	( T > Temp ),
	( Value is T - Temp ).

% ----- the value of s2 is added to the value of s1 when the chair
% ----- revokes the floor or when the bidder holding the floor
% ----- releases the floor. In either case, the chair's obligation
% ----- to revoke the floor is 'deleted'.

initiates(revoke_floor, s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( s1(Chair) = S1Prev, T ),
	holdsAt( s2(Chair) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).

initiates(release_floor(Bidder), s1(Chair) = Value, T) :-
	rigid( role_of(Chair) = chair ),
	holdsAt( status = granted(Bidder, Expiry), T ),
	holdsAt( s1(Chair) = S1Prev, T ),
	holdsAt( s2(Chair) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).


% ----- recall that the bidder is obliged to release the floor
% ----- earlier than the time that the chair is obliged to 
% ----- revoke the floor

holdsAt( s2(Bidder) = Value, T ) :-
	holdsAt( obliged(Bidder, release_floor(Bidder)) = true, T ),
	holdsAt( status = granted(Bidder, Expiry), T ),
	( T > Expiry ),
	( Value is T - Expiry ).

% ----- the value of s2 is added to the value of s1 when the chair
% ----- revokes the floor or when the bidder holding the floor
% ----- releases the floor. In either case, the bidder's obligation
% ----- to release the floor is 'deleted'.

initiates(revoke_floor, s1(Bidder) = Value, T) :-
	holdsAt( status = granted(Bidder, Expiry), T ),
	holdsAt( s1(Bidder) = S1Prev, T ),
	holdsAt( s2(Bidder) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).

initiates(release_floor(Bidder), s1(Bidder) = Value, T) :-
	holdsAt( status = granted(Bidder, Expiry), T ),
	holdsAt( s1(Bidder) = S1Prev, T ),
	holdsAt( s2(Bidder) = S2Prev, T ),
	( Value is S1Prev + S2Prev ).


% ----- the following types of sanctions should be added:
% ----- (i) failing to conform to the obligation to extend the assignment by a particular time -- DO WE WANT SUCH A SANCTION?


/***************** 
 * request_floor *
 *****************/


initiates(request_floor(Bidder), requested(Bidder, T) = true, T) :-
	holdsAt( pow(Bidder, request_floor(Bidder)) = true, T ).


/**************** 
 * assign_floor *
 ****************/

% ----- the floor is granted for the next 5 time-points

initiates(assign_floor(Bidder), status = granted(Bidder, Expiry), T) :-
	holdsAt( status = free, T ),
	( Expiry is T + 5 ).

initiates(assign_floor(Bidder), requested(Bidder, T2) = false, T) :-
	holdsAt( status = free, T ),
	holdsAt( requested(Bidder, T2) = true, T ).

% ----- assigning the floor when permitted to do so is considered a 
% ----- 'correct' assignment

initiates(assign_floor(Bidder), correct_assignment = true, T) :-
	holdsAt( status = free, T ),
	holdsAt( correct_assignment = false, T),
	rigid( role_of(Chair) = chair ),
	holdsAt( permitted(Chair, assign_floor(Bidder)) = true, T ).

/********************* 
 * extend_assignment *
 *********************/


% ----- prolong the time of having the floor

initiates(extend_assignment(Bidder), status = granted(Bidder, ExtendedExpiry), T) :-
	holdsAt( status = granted(Bidder, ExpiryTime), T ),
	( ExtendedExpiry is T + 5 ).

initiates(extend_assignment(Bidder), requested(Bidder, T2) = false, T) :-
	holdsAt( status = granted(Bidder, ExpiryTime), T ),
	holdsAt( requested(Bidder, T2) = true, T ).

% ----- extending the assignment of the floor when permitted to do so is considered a 
% ----- 'correct' extension

initiates(extend_assignment(Bidder), correct_assignment = true, T) :-
	holdsAt( status = granted(Bidder, ExpiryTime), T ),
	holdsAt( correct_assignment = false, T),
	rigid( role_of(Chair) = chair ),
	holdsAt( permitted(Chair, extend_assignment(Bidder)) = true, T).


/**************** 
 * revoke_floor *
 ****************/


initiates(revoke_floor, status = free, T) :-
	holdsAt( status = granted(Bidder, Expiry), T ).

% ----- revokeing the floor signals the end of an assignment (if any)

initiates(revoke_floor, correct_assignment = false, T) :-
	holdsAt( correct_assignment = true, T ).


/***************** 
 * release_floor *
 *****************/


initiates(release_floor(Bidder), status = free, T) :-
	holdsAt( status = granted(Bidder, Expiry), T ).

% ----- releasing the floor signals the end of the assignment (if any)

initiates(release_floor(Bidder), correct_assignment = false, T) :-
	holdsAt( status = granted(Bidder, Expiry), T ),
	holdsAt( correct_assignment = true, T ).



/************************ 
 * AUXILIARY PREDICATES *
 ************************/


% ----- this is an application-specific predicate: calculating the best
% ----- candidate for the floor at each time-point
% ----- in this example the best candidate is the one that submitted
% ----- first a request for the floor

holdsAt(best_candidate = Bidder, T) :-
	setof((RequestTime, B), holdsAt( requested(B, RequestTime) = true, T ), [H|Tail]),
	(H = (_, Bidder)).

% ----- retrieve information about each agent in a coherent manner

holdsAt(description_of(Agent, State), T) :-
	findall(Role,      rigid(   role_of(Agent) = Role                 ), Roles),
	findall(PAction,   holdsAt( pow(Agent, PAction) = true,         T ), PActions),
	findall(PerAction, holdsAt( permitted(Agent, PerAction) = true, T ), PerActions),
	findall(OAction,   holdsAt( obliged(Agent, OAction) = true,     T ), OActions),
	findall(Agent,     holdsAt( sanctioned(Agent) = true,           T ), SList),
	append([roles(Roles)],     [permissions(PerActions)], Temp1),
	append([powers(PActions)], [obligations(OActions)],   Temp2),
	append(Temp1, Temp2, Temp12),
	append(Temp12, [sanctions(SList)], State).


/*********************
 * TODO              *
 *********************/

% ----- sanctions

% ----- fix entitlement: too many solutions
% ----- fix entitlement: if I have the floor, does it make sense to say that I am entitled to have it? Read Firozabadi paper
% ----- test with various narratives
% ----- roles as fluents and RAP, RTP

% ----- should consider introducing more actions, eg 'withdraw_request(Bidder)'
% ----- should introduce timeouts for gathering all requests