


/****************************************************************
 *                                                              *
 * An Argumentation 						*
 * Alexander Artikis						*
 *								*
 * Based on the AIJ specification of Alexander Artikis		*
 *                                                              *
 *                                                              *
 * Implemented in RTEC		                                *
 ****************************************************************/


:- dynamic happensAt/2.

% In the file below agent/1, role/1, motion/1 and role_of are defined.
:- ['narrative-RTEC.prolog'].


/*
ToDo:
---This specification is half-written in the RTEC language. Check from the beginning.
---Make timeout injection more generic and declarative. Also the first claim may not necessarily take place at t=0.

To Consider:
---cache derived events (acting on behalf of a role)
---do we need premise=false? It depends on silence implies consent

NOTES:
---I am not convinced that this protocol should be included in the paper due to the fact that complexity grows with number of propositions. Maybe we should keep due to the features that normative positions are defined for roles. Also maybe something interesting will come out from the analysis of proper/timely and complex normative positions.
---object and retract are writtean as object and rtract to avoid the clash with Prolog's keywords
---holdsAt representation requires the same number of rules; therefore the holdsFor representation is no less succinct and, of course, we have richer information: intervals
---turn is a simple fluent; if we assume that we have in advance the timeouts then we can answer queries of the form: until when is an agent empowered to perform an action?
---power is defined for roles and then for agents. NICE FEATURE!
*/


/****************************************
  AGENT ACTIONS 	                
                                       
  claim(Agent, Proposition)           
  concede(Agent, Proposition)      	
  rtract(Agent, Proposition)      			
  deny(Agent, Proposition)          
  object(Agent, Action)      
  declare(Agent, Role)	

  DERIVED ACTIONS
 			
  claim(Role, Proposition)           
  concede(Role, Proposition)      	
  rtract(Role, Proposition)      			
  deny(Role, Proposition)          
  object(Role, Action)      
  declare(Role, Role)	
		
  INJECTED ACTIONS			
 					
  pTimeout	
  oTimeout			
  endTimeout				
 ****************************************/    

/********************************************************************************************
  SIMPLE FLUENTS 	              
                                     
  role_of(Agent, Role)		boolean 			cached-defined in narrative	
  topic				Topic	 			cached-defined in narrative
  turn				Role+none			cached
  premise(Role, Proposition)	boolean				cached
  winner			Role+none			cached
  invalidActionHappened		Action				cached
  pow(declare(Role, Role))	boolean				cached
 ********************************************************************************************/

/****************************************************************************
  STATICALLY DETERMINED FLUENTS 	              
                                     
  pow(Act)			boolean				cached
 ****************************************************************************/	


/*****************
  DERIVED ACTIONS
 *****************/

% acting on behalf of a role

happensAt(claim(Role, Q), T) :-
	happensAt(claim(Ag, Q), T),
	holdsAt(role_of(Ag)=Role, T).

happensAt(concede(Role, Q), T) :-
	happensAt(concede(Ag, Q), T),
	holdsAt(role_of(Ag)=Role, T).

happensAt(rtract(Role, Q), T) :-
	happensAt(rtract(Ag, Q), T),
	holdsAt(role_of(Ag)=Role, T).

happensAt(deny(Role, Q), T) :-
	happensAt(deny(Ag, Q), T),
	holdsAt(role_of(Ag)=Role, T).

happensAt(objct(Role, Act), T) :-
	happensAt(objct(Ag, Act), T),
	holdsAt(role_of(Ag)=Role, T).

happensAt(delcare(DetRole, Role, Q), T) :-
	happensAt(declare(Ag, Role, Q), T),
	holdsAt(role_of(Ag)=DetRole, T).

/*****************
  INJECT TIMEOUTS
 *****************/

processInputStream :-
	happensAt(claim(proponent,_Q), 0),	
	assert( happensAt(oTimeout, 10) ),
	assert( happensAt(pTimeout, 20) ),
	assert( happensAt(oTimeout, 30) ),
	assert( happensAt(pTimeout, 40) ),
	assert( happensAt(oTimeout, 50) ),
	assert( happensAt(dTimeout, 60) ),
	assert( happensAt(endTimeout, 70) ).


/*******
  TURN
 *******/

initially(turn=proponent).

initiatedAt(turn=proponent, _, T, _) :-
	happensAt(pTimeout, T).

initiatedAt(turn=opponent, _, T, _) :-
	happensAt(oTimeout, T).

initiatedAt(turn=determiner, _, T, _) :-
	happensAt(dTimeout, T).

initiatedAt(turn=none, _, T, _) :-
	happensAt(endTimeout, T).


/*********
  PREMISE
 *********/

% anything goes between the protagonists until it is the determiner's turn to speak

initiatedAt(premise(Role, Q)=true, _, T, _) :-
	happensAt(claim(Role, Q), T),
	\+ holdsAt(turn=determiner, T).

initiatedAt(premise(Role, Q)=true, _, T, _) :-
	happensAt(concede(Role, Q), T),
	\+ holdsAt(turn=determiner, T).

initiatedAt(premise(Role, Q)=false, _, T, _) :-
	happensAt(rtract(Role, Q), T),
	\+ holdsAt(turn=determiner, T).

initiatedAt(premise(Role, Q)=false, _, T, _) :-
	happensAt(deny(Role, Q), T),
	\+ holdsAt(turn=determiner, T).

initiatedAt(premise(Role, Q)=false, _, T, _) :-
	happensAt(objct(Role2, claim(Role, Q)), T),
	holdsAt(pow(objct(Role2, claim(Role, Q)))=true, T).

initiatedAt(premise(Role, Q)=false, _, T, _) :-
	happensAt(objct(Role2, concede(Role, Q)), T),
	holdsAt(pow(objct(Role2, concede(Role, Q)))=true, T).

initiatedAt(premise(Role, Q)=true, _, T, _) :-
	happensAt(objct(Role2, rtract(Role, Q)), T),
	holdsAt(pow(objct(Role2, rtract(Role, Q)))=true, T).

initiatedAt(premise(Role, Q)=true, _, T, _) :-
	happensAt(objct(Role2, deny(Role, Q)), T),
	holdsAt(pow(objct(Role2, deny(Role, Q)))=true, T).

/********
  WINNER
 ********/

initiatedAt(winner=Role, _, T, _) :-
	happensAt(declare(DetRole, Role), T).

initiatedAt(winner=none, _, T, _) :-
	happensAt(objct(Role, declare(DetRole, Role2), T),
	holdsAt(pow(objct(Role, declare(DetRole, Role2)))=true, T).

/***********************
  INVALIDACTIONHAPPENED
 ***********************/

initiatedAt(invalidActionHappened=claim(Role, Q), _, T, _) :-
	happensAt(claim(Role, Q), T),
	\+ holdsAt(pow(claim(Role, Q))=true, T).

initiatedAt(invalidActionHappened=concede(Role, Q), _, T, _) :-
	happensAt(concede(Role, Q), T),
	\+ holdsAt(pow(concede(Role, Q))=true, T).

initiatedAt(invalidActionHappened=rtract(Role, Q), _, T, _) :-
	happensAt(rtract(Role, Q), T),
	\+ holdsAt(pow(rtract(Role, Q))=true, T).

initiatedAt(invalidActionHappened=deny(Role, Q), _, T, _) :-
	happensAt(deny(Role, Q), T),
	\+ holdsAt(pow(deny(Role, Q))=true, T).

initiatedAt(invalidActionHappened=declare(DetRole, Role), _, T, _) :-
	happensAt(declare(DetRole, Role), T),
	\+ holdsAt(pow(declare(DetRole, Role))=true, T).

initiatedAt(invalidActionHappened=none, _, T, _) :-
	happensAt(Act, T),
	Act=..[_, Role, _],
	holdsAt(pow(Role, Act)=true, T).

initiatedAt(invalidActionHappened=none, _, T, _) :-
	happensAt(dTimeout, T).

initiatedAt(invalidActionHappened=none, _, T, _) :-
	happensAt(endTimeout, T).


/*********************
  INSTITUTIONAL POWER
 *********************/

% power of a role

holdsFor(pow(claim(proponent, _Q))=true, I) :-
	holdsFor(turn=proponent, I).

holdsFor(pow(claim(opponent, _Q))=true, I) :-
	holdsFor(turn=opponent, I).

holdsFor(pow(concede(proponent, _Q))=true, I) :-
	holdsFor(turn=proponent, I).

holdsFor(pow(concede(opponent, _Q))=true, I) :-
	holdsFor(turn=opponent, I).

holdsFor(pow(rtract(proponent, _Q))=true, I) :-
	holdsFor(turn=proponent, I).

holdsFor(pow(rtract(opponent, _Q))=true, I) :-
	holdsFor(turn=opponent, I).

holdsFor(pow(deny(proponent, _Q))=true, I) :-
	holdsFor(turn=proponent, I).

holdsFor(pow(deny(opponent, _Q))=true, I) :-
	holdsFor(turn=opponent, I).

holdsFor(pow(objct(proponent, Act))=true, I) :-
	holdsFor(invalidActionHappened=Act, I).

holdsFor(pow(objct(opponent, Act))=true, I) :-
	holdsFor(invalidActionHappened=Act, I).


initiatedAt(pow(declare(determiner, proponent))=true, _, T, _) :-
	happensAt(dTimeout, T),
	holdsAt(topic=Q, T),
	holdsFor(accepts(proponent, Q)=true, T).

initiatedAt(pow(declare(determiner, opponent))=true, _, T, _) :-
	happensAt(dTimeout, T),
	holdsAt(topic=Q, T),
	holdsFor(accepts(proponent, Q)=false, T).

initiatedAt(pow(declare(determiner, proponent))=false, _, T, _) :-
	happensAt(endTimeout, T).

initiatedAt(pow(declare(determiner, opponent))=false, _, T, _) :-
	happensAt(endTimeout, T).


/*************
  PERMISSION
 *************/

/*************
  OBLIGATION
 *************/

/*****************************
  COMPLEX NORMATIVE RELATIONS
 *****************************/

/***********
  SANCTION
 ***********/


/********************************
  ACCEPTS (LOGIC OF DISPUTATION)
 ********************************/

% the logic of disputation can be as complicated as one wants
% the following rule expresses a very simple logic of disputation
% (which is adequate to conduct simple experiments)

holdsFor(accepts(Role, Q)=true, I) :-
	holdsFor(premise(Role, Q)=true, I).

holdsFor(accepts(Role, Q)=false, I) :-
	holdsFor(premise(Role, Q)=false, I).


/**************
  DECLARATIONS 
 **************/

/****************************************************************
*		     INPUT EVENTS				*
****************************************************************/

% instantaneous

sde(instantaneous, _, claim(_Ag, _Q)).
sde(instantaneous, _, concede(_Ag, _Q)).
sde(instantaneous, _, rtract(_Ag, _Q)).
sde(instantaneous, _, deny(_Ag, _Q)).
sde(instantaneous, _, pTimeout).
sde(instantaneous, _, oTimeout).
sde(instantaneous, _, dTimeout).
sde(instantaneous, _, endTimeout).

% the are not durative input events


/****************************************************************
*		     FLUENTS					*
****************************************************************/

% state which entity is a simple fluent - explicitly state 2-valued fluents 

simpleFluent(role_of(_Ag, _Role)=true).    
simpleFluent(turn=proponent).  
simpleFluent(turn=opponent).  
simpleFluent(turn=determiner).
simpleFluent(premise(_Role, _Q)=true).
% we may be agnostic about premises
simpleFluent(premise(_Role, _Q)=false).
simpleFluent(winner=proponent).  
simpleFluent(winner=opponent).
simpleFluent(invalidActionHappened=claim(_Role, _Q)).
simpleFluent(invalidActionHappened=concede(_Role, _Q)).
simpleFluent(invalidActionHappened=rtract(_Role, _Q)).
simpleFluent(invalidActionHappened=deny(_Role, _Q)).
simpleFluent(invalidActionHappened=declare(_DetRole, _Role)).
simpleFluent(pow(delcare(_DetRole, _Role))=true).


% simple2vFluents?


sDFluent(holdsFor, manipulateIntervals, ce, pow(claim(_Role, _Q))=true). 
sDFluent(holdsFor, manipulateIntervals, ce, pow(concede(_Role, _Q))=true). 
sDFluent(holdsFor, manipulateIntervals, ce, pow(rtract(_Role, _Q))=true). 
sDFluent(holdsFor, manipulateIntervals, ce, pow(deny(_Role, _Q))=true). 
sDFluent(holdsFor, manipulateIntervals, ce, pow(objct(_Role, _Act))=true). 
sDFluent(holdsFor, manipulateIntervals, ce, accepts(_Role, _Q)=true). 
sDFluent(holdsFor, manipulateIntervals, ce, accepts(_Role, _Q)=false).


/****************************************************************
*		     CACHED ENTITIES				*
****************************************************************/


/******************************************************************************
THE ORDER OF cachedEntity BELOW MAKES A DIFFERENCE
start from the lower-level entities and then move to the higher-level entities
in this way the higher-level entities will use the lower-level entities 
that will be already CACHED

The fluents below are the only fluents that are used in the VoPr specification
Eg we do not use the intervals in which voted()=null 
*******************************************************************************/

cachedEntity(Ag, role_of(Ag, Role)=true) :-
	agent(Ag), role(Role). 

%%%%% ATTENTION: I have to modify caching.prolog so that the following will work
%%%%% Simply add a ' recognise(_, processingInputStream, _, _, _) :- !. ' clause
%%%%% The timeouts should be injected at this point as we need to compute first 
%%%%% the intervals of pow(open_ballot(Ag,M))=true
cachedEntity(_, processingInputStream) :-
	processInputStream.

cachedEntity(Role, pow(claim(Role, Q))=true) :-
	role(Role), proposition(Q). 

cachedEntity(Role, pow(concede(Role, Q))=true) :-
	role(Role), proposition(Q). 

cachedEntity(Role, pow(rtract(Role, Q))=true) :-
	role(Role), proposition(Q). 

cachedEntity(Role, pow(deny(Role, Q))=true) :-
	role(Role), proposition(Q). 


