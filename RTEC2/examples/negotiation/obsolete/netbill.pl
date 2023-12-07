/****************************************************************
 *                                                              *
 * A NetBill protocol			                        * 
 *                                                              *
 *                                                              *
 * Implemented in SWI Prolog	                                *
 *								*
 ****************************************************************/

% RUN updateNarrative TO UPADTE THE NARRATIVE
 
 
% The following predicate definitions are all over the place
% in this file, so give the Prolog system/compiler due warning. 
:- discontiguous initially/1, sdFluent/1, holdsAt/2, initiates/3, meets/2.

:- dynamic happens/2. 

:- ['role-management.pl'].

%:- set_flag(all_dynamic, on).	       % a predicate may be defined by 
				       % non-consecutive clauses


/*********************************** 
 * EVENT CALCULUS REASONING ENGINE *
 ***********************************/


holdsAt( Fluent = V, T ) :-
	\+ sdFluent( Fluent ),	    % sdFluents are determined by separate laws
	initially( Fluent = V ),
	\+ broken( Fluent = V, 0, T ).

holdsAt( Fluent = V, T ) :-
	\+ sdFluent( Fluent ),
	happens( Event, EarlyTime ),
	EarlyTime < T,
	initiates( Event, Fluent = V, EarlyTime ),
	\+ broken( Fluent = V, EarlyTime, T ).
	
broken( Fluent = V, T1, T3 ) :-
	happens( Event, T2 ),
	T1 =< T2,
	T2 < T3,
	terminates( Event, Fluent = V, T2 ).

terminates( Event, Fluent = V, T ) :-
	initiates( Event, Fluent = V2, T ),
	\+ (V = V2).		  % is this condition necessary?


/******************************************************************** 
 * 'STATICALLY DETERMINED' FLUENTS 				    *
 *								    *					
 * The values of these fluents are determined by state constraints, *
 * not by the Event Calculus Reasoning Engine			    *
 *								    *
 *								    *
 * boolean domain:						    *
 *								    *
 * can( agent, action )						    *
 * pow( agent, action )						    *
 * per( agent, action )						    *
 * suspended( role, agent )					    *
 ********************************************************************/


sdFluent( can(_, _) ).
sdFluent( pow(_, _) ).
sdFluent( per(_, _) ).
sdFluent( suspended(_, _) ).


/***************************************************************
 * SIMPLE FLUENTS                                              *
 *							       *
 * The values of these fluents are determined by the 	       *
 * Event Calculus Reasoning Engine			       *
 *                                                             *
 *                                                             *
 * boolean domain:					       *
 *                                                             *
 * request(     merchant, consumer, goods_description )        *
 * contract(    merchant, consumer, goods_description, price ) *
 * obl( agent, action )					       *
 * violation( role, agent ) 				       *
 * banned( agent )					       *
 *							       *
 * domain list of role names				       *
 * role_of( agent )					       *
 *							       *
 * domain ZxZ						       *
 * bank_account( agent )				       *
 *                                                             *
 * domain Z 						       *
 * quote(       merchant, consumer, goods_description, price ) *
 * ad_count( agent, agent )				       *
 * suspendedUntil( role, agent )			       *
 ***************************************************************/  


/****************************************************************
 * NOTES							*
 *								*
 * 'goods_description' works as a contract id			*
 * we should not have a narrative in which the same consumer	*
 * and merchant have two or more contracts on the same 		*
 * goods_description at the same time				*
 * for simplicity this constraint has not been incorporated 	*
 * in the specification						*
 ****************************************************************/


/*****************
 * INITIAL STATE *
 *****************/


% ----- We specify the value of every simple fluent at the initial state

initially( role_of(c1) = [consumer] ).  % agent 'c1' occupies the role of the consumer
initially( role_of(c2) = [consumer] ).  % agent 'c2' occupies the role of the consumer
initially( role_of(m1) = [merchant] ).  % agent 'm1' occupies the role of the merchant
initially( role_of(m2) = [merchant] ).  % agent 'm2' occupies the role of the merchant

initially( bank_account(c1) = (10, 310) ).	%The balance and available amount, respectively, of c1
initially( bank_account(c2) = (100, 600) ).	%The balance and available amount, respectively, of c2
initially( bank_account(m1) = (150, 650) ).	%The balance and available amount, respectively, of m1
initially( bank_account(m2) = (80, 580) ).	%The balance and available amount, respectively, of m2

initially( quote(_, _, _, _) = 0 ).

initially( ad_count(_, _) = 0 ). % setting the initial values of the fluents recording the number of unsolicited adverts

initially( suspendedUntil(_, _) = 0). % no agent is initially suspended


initially( Fluent = false ) :-
	\+ sdFluent( Fluent ),
	\+ Fluent = role_of(_),
	\+ Fluent = bank_account(_),
	\+ Fluent = quote(_, _, _, _), 
	\+ Fluent = ad_count(_, _),
	\+ Fluent = suspendedUntil(_, _),
	\+ initially( Fluent = true ).


/**************************************************************************
 * ACTIONS	                                                          *
 *                                                                        *
 * request_quote( consumer, merchant, goods_description                 ) *
 * present_quote( merchant, consumer, goods_description,  price         ) *
 * accept_quote(  consumer, merchant, goods_description,  price         ) *
 * send_EPO(      consumer, iServer,  goods_description,  price         ) *
 * send_goods(    merchant, iServer,  goods_description,  goods, key    ) *
 **************************************************************************/


/***********************
 * PHYSICAL CAPABILITY *
 ***********************/


holdsAt( can( Consumer, send_EPO(Consumer, _, _, P)) = true, T ) :-
	holdsAt( bank_account( Consumer ) = (_, Av), T),
	Av > P.
	
holdsAt( can( Ag, Act) = true, T ) :-
	\+ Act = send_EPO(_, _, _, _).

holdsAt( can( Ag, Act ) = false, T ) :-
	\+ holdsAt( can( Ag, Act ) = true, T ).


/***********************
 * INSTITUTIONAL POWER *
 ***********************/


% ----- a consumer is empowered to request a quote from any merchant 
% ----- concerning any type of good

holdsAt( pow( Consumer, request_quote(Consumer, Merchant, GD)) = true, T ) :-
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ).

% ----- a merchant is empowered to present a quote to any consumer 
% ----- concerning any type of good, at any price
% ----- in other words, a merchant may not wait for a 'request_quote'
% ----- before sending a 'present_quote'

holdsAt( pow( Merchant, present_quote(Merchant, Consumer, GD, Price)) = true, T ) :-
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ),
	holdsAt( suspended(merchant, Merchant) = false, T ).

% ----- a consumer is empowered to accept a quote from a merchant 
% ----- if that merchant has presented that quote having the power to do so
% ----- and the quote has not expired
% ----- and the consumer is not currently suspended

holdsAt( pow( Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ) :-
	holdsAt( quote(Merchant, Consumer, GD, Price) = QuoteT, T ),
	QuoteT >= T,
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( suspendedUntil(consumer, Consumer) = SusT, T ),
	SusT =< T, 
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ).

% ----- a consumer is empowered to send an EPO to the Intermediation Server (iServer) 
% ----- conserning goods described as GD if there is a contract on GD 
% ----- Note that the consumer is empowered to send an EPO at any price
% ----- ie, not necessarily the price specified in the contract
% ----- However, as will be shown later, the consumer is 
% ----- *obliged* to send an EPO according to the price in the contract

holdsAt( pow( Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ) :-
	holdsAt( contract(Merchant, Consumer, GD, Price2) = true, T ).

	
% ----- a merchant is empowered to send goods and decryption key to the iServer
% ----- if there is a contract for the delivery of these goods 

holdsAt( pow( Merchant, send_goods(Merchant, iServer, GD, G, Key)) = true, T ) :-
	holdsAt( contract(Merchant, Consumer, GD, Price) = true, T ).

	
holdsAt( pow( Agent, Action ) = false, T ) :-
	\+ holdsAt( pow( Agent, Action ) = true, T ).


/***********************
 * PERMISSION	       *
 ***********************/


% ----- a consumer is always permitted to request a quote from a merchant

holdsAt( per( Consumer, request_quote(Consumer, Merchant, GD)) = true, T ) :-
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ).

% ----- a merchant is permitted to present a specified number of quotes
% ----- the specified limit is calculated by means of the value of the addcount
% ----- fluent, the value of which is manipulated by the present_quote action
% ----- see below for the effects of this action
	
holdsAt( per( Merchant, present_quote(Merchant, Consumer, GD, Price)) = true, T ) :-
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ),
	holdsAt( request( Consumer, Merchant, GD) = true, T).
	
holdsAt( per( Merchant, present_quote(Merchant, Consumer, GD, Price)) = true, T ) :-
	holdsAt( role_of( Consumer ) = CRoles, T),
	member( consumer, CRoles ),
	holdsAt( role_of( Merchant ) = MRoles, T),
	member( merchant, MRoles ),
	holdsAt( ad_count( Merchant, Consumer) = Count, T),
	Count < 10.

% ----- a consumer is permitted to accept a quote if it is empowered to do so 
% ----- and it has the available funds
	
holdsAt( per( Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ) :-
	holdsAt( pow( Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ),
	holdsAt( bank_account(Consumer) = (Bal, Av), T ),
	Av >= Price.	

% ----- an agent is permitted to send an EPO of a specified amount if 
% ----- it is obliged to do so
% ----- otherwise it is permitted to send an EPO of any amount
	
holdsAt( per( Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ) :-
	holdsAt( obl( Consumer, send_EPO(Consumer, iServer, GD, Price2)) = true, T ),
	Price > Price2.

holdsAt( per( Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ) :-
	findall(Price2, holdsAt( obl( Consumer, send_EPO(Consumer, iServer, GD, Price2)) = true, T ), []).	

% ----- the permission to send_goods is specified similar to the permission to 
% ----- send_EPO; we omit the specification of the permission to send_goods here


holdsAt( per( Agent, Action ) = false, T ) :-
	\+ holdsAt( per( Agent, Action ) = true, T ).

	
/***********************
 * OBLIGATION	       *
 ***********************/


% ----- accepting a quote while having the power to do, that is, 
% ----- establishing a contract, initiates obligations 
% ----- for the contracting parties

initiates(accept_quote(Consumer, Merchant, GD, Price), obl(Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T) :-
	holdsAt( pow(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ).
	
initiates(accept_quote(Consumer, Merchant, GD, Price), obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = true, T) :-
	holdsAt( pow(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ).

% ----- the timeout signalling the end of the contract
% ----- terminates the obligations of the contracting parties, 
% ----- if these obligations still exist	
	
initiates(timeout(GD), obl(Consumer, send_EPO(Consumer, iServer, GD, Price)) = false, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ).
	
initiates(timeout(GD), obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = false, T) :-
	holdsAt(  obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = true, T ).

% discharging the obligations
	
initiates(send_EPO(Consumer, iServer, GD, Price), obl(Consumer, send_EPO(Consumer, iServer, GD, Price2)) = false, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, iServer, GD, Price2)) = true, T ),
	Price >= Price2.
	
initiates(send_goods(Merchant, iServer, GD, G, Key), obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = false, T) :-
	holdsAt(  obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = true, T ),
	decrypt(G, Key, Decrypted_G).
	meets(Decrypted_G, GD).

% ----- the following time-independent predicate represents the decryption 
% ----- of goods G with the Key; the result is Decrypted_G

% ----- we provide here toy definitions of this predicate just to run
% ----- simple examples

decrypt(enc_book_contents, key, dec_book_contents).

% ----- the following time-independent predicate expresses whether 
% ----- some electronic goods meet a specified standard

meets(dec_book_contents, book1).


/***********************
 * SANCTION	       *
 ***********************/


% ----- presenting a quote, while being forbidden to do so, results in a 
% ----- monetary sanction for the merchant
 
initiates(present_quote(Merchant, Consumer, GD, Price), bank_account(Merchant) = (NewBal, NewAv), T) :-
	holdsAt( per(Merchant, present_quote(Merchant, Consumer, GD, Price)) = false, T ),
	holdsAt( bank_account(Merchant) = (Bal, Av), T ),
	NewBal is Bal - 10,
	NewAv is Av - 10.

% ----- if a merchant sends too many unsolicited quotes (100), which is clearly
% ----- forbidden, then it will be suspended
% ----- a suspended merchant loses the power to present a quote
	
holdsAt( suspended(merchant, Merchant) = true, T ) :-
	holdsAt( role_of(Merchant) = MRoles, T ),
	member( merchant, MRoles ),
	holdsAt( ad_count(Merchant, _ ) = AC, T ),
	AC >= 100.
	
holdsAt( suspended(Role, Agent) = false, T ) :-
	\+ holdsAt( suspended(Role, Agent) = true, T ).


% ----- record the violation of the permission to accept a quote, and therefore,
% ----- establish a contract, with the violation fluent

initiates(accept_quote(Consumer, Merchant, GD, Price), violation(consumer, Consumer) = true, T) :-
	holdsAt( pow(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ),
	holdsAt( per(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = false, T ).
	
% ----- the following two axioms terminate the violation fluent

initiates(send_EPO(Consumer, _, GD, Price), violation(consumer, Consumer) = false, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, _, GD, Price2)) = true, T ),
	holdsAt( violation(consumer, Consumer) = true, T ),
	Price >= Price2.
	
initiates(timeout(GD), violation(consumer, Consumer) = false, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, _, GD, Price)) = true, T ),
	holdsAt( violation(consumer, Consumer) = true, T ).

% ----- failure to discharge the obligation to send an EPO by the specified 
% ----- deadline suspends the consumer, provided that the consumer has not 
% ----- violated earlier the permission to accept a quote
	
initiates(timeout(GD), suspendedUntil(consumer, Consumer) = NewT, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ),
	holdsAt( violation(consumer, Consumer) = false, T),
	NewT is T + 10.
	
% ----- if the consumer had violated the permission to accept the quote 
% ----- then more severe sanctions are applied: he loses the role of consumer
	
initiates(timeout(GD), role_of(Consumer) = NewRoles, T) :-
	holdsAt( obl(Consumer, send_EPO(Consumer, iServer, GD, Price)) = true, T ),
	holdsAt( violation(consumer, Consumer) = true, T),
	holdsAt( role_of(Consumer) = Roles, T),
	delete(Roles, consumer, NewRoles).
	
initiates(timeout(GD), suspendedUntil(merchant, Merchant) = NewT, T) :-
	holdsAt(  obl(Merchant, send_goods(Merchant, iServer, GD, G, Key)) = true, T ),
	NewT is T + 10.

% ----- in a similar way we could express the sanction that results from the 
% ----- non-compliance with the obligation to send the goods

/**********************
 * EFFECTS OF ACTIONS *
 **********************/


/*****************
 * request_quote *
 *****************/


initiates(request_quote(Consumer, Merchant, GD), request(Consumer, Merchant, GD) = true, T) :-
	holdsAt( pow(Consumer, request_quote(Consumer, Merchant, GD)) = true, T ).


/*****************
 * present_quote *
 *****************/


initiates(present_quote(Merchant, Consumer, GD, Price), request(Consumer, Merchant, GD) = false, T) :-
	holdsAt( request(Consumer, Merchant, GD) = true, T ).

% ----- presenting a quote, having the power to do so, initiates a valid quote,
% ----- that is, a quote that can successfully be accepted by the consumer,
% ----- for a specified period of time
	
initiates(present_quote(Merchant, Consumer, GD, Price), quote(Merchant, Consumer, GD, Price) = NewT, T) :-
	holdsAt( pow(Merchant, present_quote(Merchant, Consumer, GD, Price)) = true, T ),
	NewT is T + 10.
	
	
% ----- the following two axioms record the number of unsolicited advertisements
% ----- this is necessary in order to express the permission to present a quote
	

initiates(present_quote(Merchant, Consumer, GD, Price), ad_count(Merchant, Consumer) = NewCount, T) :-
	holdsAt( request(Consumer, Merchant, GD) = false, T ),
	holdsAt( ad_count( Merchant, Consumer) = Count, T),
	NewCount is Count + 1.
	
initiates(present_quote(Merchant, Consumer, GD, Price), ad_count(Merchant, Consumer) = NewCount, T) :-
	holdsAt( request(Consumer, Merchant, GD) = true, T ),
	holdsAt( ad_count( Merchant, Consumer) = Count, T),
	NewCount is Count - 2.


/*****************
 * accept_quote  *
 *****************/

% ----- a consumer may accept a quote only once; this is achieved by setting the
% ----- value of the quote fluent to 0
 
initiates(accept_quote(Consumer, Merchant, GD, Price), quote(Merchant, Consumer, GD, Price) = 0, T) :-
	holdsAt( pow(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ).

% ----- accepting a quote, having the power to do so, initiates a 
% ----- contract between the consumer and merchant in question

initiates(accept_quote(Consumer, Merchant, GD, Price), contract(Merchant, Consumer, GD, Price) = true, T) :-
	holdsAt( pow(Consumer, accept_quote(Consumer, Merchant, GD, Price)) = true, T ).

% ----- the following axiom records a type of forbidden accept_quote actions
% ----- the fluent violation is used for the definition of sanctions


/************
 * send_EPO *
 ************/


% ----- the following two axioms express the effects of a send_EPO action
% ----- in terms of the bank accounts of the parties in question 

initiates( send_EPO( Ag, _, _, P) , bank_account(Ag) = (NewBal, NewAv), T ) :-
	holdsAt( bank_account(Ag) = (Bal, Av), T),
	NewBal is Bal-P,
	NewAv is Av-P.

initiates( send_EPO( _, _, GD, P) , bank_account(Ag2) = (NewBal, NewAv), T ) :-
	holdsAt( contract(_, Ag2, GD, _) = true, T ),
	holdsAt( bank_account(Ag2) = (Bal, Av), T),
	NewBal is Bal+P,
	NewAv is Av+P.


/*****************
 * timeout       *
 *****************/

% ----- a timeout terminates the corresponding contract

initiates(timeout(GD), contract(Merchant, Consumer, GD, Price) = false, T) :-
	holdsAt( contract(Merchant, Consumer, GD, Price) = true, T ).
 

/******************* 
 * CHECK NARRATIVE *
 *******************/


% ----- test for physical capability

incons( physical_incapablity(Ag, Act) ) :-
	happens( Act, T ),
	Act =.. [_, Ag | Tail],
	\+ holdsAt( can(Ag, Act) = true, T ).


/*************
 * NARRATIVE *
 *************/


% ----- this is an example narrative, that is, a list of externally observable
% ----- events of a run of NetBill

%happens( request_quote(c1, m2, book1), 1 ).
happens( present_quote(m2, c1, book1, 5), 2 ).

happens( present_quote(m2, c1, book1, 5), 3 ).
happens( present_quote(m2, c1, book1, 5), 4 ).
happens( present_quote(m2, c1, book1, 5), 5 ).
happens( present_quote(m2, c1, book1, 5), 6 ).
happens( present_quote(m2, c1, book1, 5), 7 ).
happens( present_quote(m1, c1, book1, 5), 8 ).
happens( present_quote(m2, c1, book1, 5), 9 ).
happens( present_quote(m2, c1, book1, 5), 10 ).
happens( present_quote(m2, c1, book1, 5), 11 ).
happens( present_quote(m2, c1, book1, 5), 12 ).

happens( accept_quote(c1, m2, book1, 5), 3 ).
happens( send_goods(m2, iServer, book2, book_content, key), 4 ).
happens( send_goods(m2, iServer, book1, enc_book_contents, key), 5 ).
happens( send_EPO(c1, iServer, book1, 6 ), 6 ).

%happens( present_quote(m2, c1, book11, 5), 7 ).

%happens( send_EPO(c1, iServer, book1, 400 ), 7 ).


updateNarrative :-
	happens( accept_quote( Consumer, Merchant, GD, Price ), T ),
	holdsAt( pow(Consumer, accept_quote( Consumer, Merchant, GD, Price )) = true, T ),
	NewT is T+10,
	assert( happens(timeout(GD), NewT) ).
