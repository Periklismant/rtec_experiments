/****************************************************************
 *                                                              *
 * A Role-Management protocol		                        *
 * in the context of the NetBill protocol			* 
 *                                                              *
 *                                                              *
 * Implemented in SWI Prolog	                                *
 *								*
 ****************************************************************/
 

/*************************************************************** 
 * 'STATICALLY DETERMINED' FLUENTS 			       *
 *							       *
 * boolean domain:					       *
 *							       *
 * role_cond( agent, role )				       *
 *							       *
 * domain is Z						       *
 *							       *
 * merchants						       *
 * consumers						       *
 ***************************************************************/

sdFluent( role_cond(_, _) ).
sdFluent( merchants ).
sdFluent( consumers ).


/***************************************************************
 * SIMPLE FLUENTS                                              *
 *                                                             *
 * boolean domain:					       *
 *                                                             *
 * applied( agent, role )				       *
 ***************************************************************/  


/*****************
 * INITIAL STATE *
 *****************/

% ----- We specify the value of every simple fluent at the initial state

initially( role_of( raa ) = [ra_authority] ).


/****************************************************************
 * ACTIONS	                                                *
 *                                                              *
 * apply(    agent, role )			                *
 * assign(   agent, agent, role )				*
 * withdraw( agent, role     ) 					*
 ****************************************************************/


/***********************
 * PHYSICAL CAPABILITY *
 ***********************/

% ----- every agent is physically capable of performing every protocol action

holdsAt( can( Agent, apply(Agent, Role)) = true, T ).
holdsAt( can( RAA,   assign(RAA, Agent, Role)) = true, T ).
holdsAt( can( Agent, withdraw(Agent, Role)) = true, T ).


/***********************
 * INSTITUTIONAL POWER *
 ***********************/


% ----- an agent is empowered to apply for a role if it has no pending 
% ----- application on that role, it does not occupy the role, it has not been
% ----- banned, and it satisfies the conditions of the role

holdsAt( pow( Agent, apply(Agent, Role)) = true, T ) :-
	holdsAt( applied( Agent, Role ) = false, T),
	holdsAt( role_of( Agent ) = AgRoles, T),
	\+ member( Role, AgRoles ),
	holdsAt( banned( Agent ) = false, T),
	holdsAt( role_cond( Agent, Role ) = true, T).

% ----- an agent RAA is empowered to assign the role of the consumer to another
% ----- agent if RAA is a role-assigning authority, and the protocol-specific
% ----- constraints are not violated by the role-assignment

holdsAt( pow( RAA, assign(RAA, Agent, consumer)) = true, T ) :-
	holdsAt( role_of( RAA ) = RAARoles, T),
	member( ra_authority, RAARoles ),
	holdsAt( applied(Agent, consumer) = true, T ),
	holdsAt( merchants = Merchants, T),
	holdsAt( consumers = Consumers, T),
	Merchants >= ((Consumers+1)/2).
	
% ----- similarly we specify the power to assign the role of the merchant
	
holdsAt( pow( RAA, assign(RAA, Agent, merchant)) = true, T ) :-
	holdsAt( role_of( RAA ) = RAARoles, T),
	member( ra_authority, RAARoles ),
	holdsAt( applied(Agent, merchant) = true, T ).

% ----- an agent is empowered to withdraw from the role of consumer at any time

holdsAt( pow( Agent, withdraw(Agent, consumer)) = true, T ) :-
	holdsAt( role_of( Agent ) = AgRoles, T),
	member( consumer, AgRoles ).
	
% ----- an agent is empowered to withdraw from the role of merchant if it 
% ----- has no pending quotes
	
holdsAt( pow( Agent, withdraw(Agent, merchant)) = true, T ) :-
	holdsAt( role_of( Agent ) = AgRoles, T),
	member( merchant, AgRoles ),
	findall( QuoteT, holdsAt( quote(Agent, _, _, _) = QuoteT, T ), List ),
	sort(List, NewList),
	last(NewList, QT),
	QT < T.


/**********************
 * EFFECTS OF ACTIONS *
 **********************/


/*****************
 * apply	 *
 *****************/

initiates(apply(Agent, Role), applied(Agent, Role) = true, T) :-
	holdsAt( pow(Agent, apply(Agent, Role)) = true, T ).
	

/*****************
 * assign	 *
 *****************/

initiates(assign(RAA, Agent, Role), applied(Agent, Role) = false, T) :-
	holdsAt( pow(RAA, assign(RAA, Agent, Role)) = true, T ).
	
initiates(assign(RAA, Agent, Role), role_of(Agent) = [Role | Roles], T) :-
	holdsAt( pow(RAA, assign(RAA, Agent, Role)) = true, T ),
	holdsAt( role_of(Agent) = Roles, T ).
	

/*****************
 * withdraw	 *
 *****************/

initiates(withdraw(Agent, Role), role_of(Agent) = NewRoles, T) :-
	holdsAt( pow(Agent, withdraw(Agent, Role)) = true, T ),
	holdsAt( role_of(Agent) = Roles, T ),
	delete(Roles, Role, NewRoles).


/*****************************
 * PROTOCOL-SPECIFIC FLUENTS *
 *****************************/

% ----- an agent satisfies the role of the consumer if it has the available funds
% ----- in this simple example an agent always satisfies the role of the merchant
 
holdsAt( role_cond( Agent, consumer) = true, T ) :-
	holdsAt( bank_account( Agent ) = (Bal, Av), T),
	Av > 100.
	
holdsAt( role_cond( Agent, consumer) = false, T ) :-
	\+ holdsAt( role_cond( Agent, consumer) = true, T ).
	
% ----- calculate the number of merchants and consumers
	
holdsAt( merchants = Merchants, T ) :-
	findall( Roles, ( holdsAt(role_of(Agent) = Roles, T), member(merchant, Roles) ), RolesList),
	length(RolesList, Merchants).
	
holdsAt( consumers = Consumers, T ) :-
	findall( Roles, ( holdsAt(role_of(Agent) = Roles, T), member(consumer, Roles) ), RolesList),
	length(RolesList, Consumers).


/*************
 * NARRATIVE *
 *************/


happens( apply(c111, consumer), 2 ).
%happens( apply(c2, consumer), 3 ).
happens( apply(m2, consumer), 4 ).

happens( assign(raa, c2, consumer), 5 ).
happens( assign(raa, c111, consumer), 6 ).
happens( assign(raa, m2, consumer), 7 ).

happens( withdraw(c2, consumer), 8 ).
happens( withdraw(m1, merchant), 9 ).
happens( withdraw(c111, consumer), 10 ).

happens( withdraw(m2, merchant), 23 ).
