/****************************************************************
 *                                                              *
 * A Voting Protocol (VoPr) in RTEC				*
 * Alexander Artikis						*
 *								*
 * Based on the specification of Jeremy Pitt		 	* 
 *                                                              *
 ****************************************************************/

/*
In this example, institutional power is best expressed by statically determined
fluents. Power is NOT used as a condition in the rules expressing the effects 
of actions because cycles cannot include statically determined fluents. 
Power however is defined to answer queries. 
*/

/****************************************
  AGENT ACTIONS 	                                             
  propose(Agent, Motion)           
  second(Agent, Motion)           
  vote(Agent, Motion, aye)      	
  vote(Agent, Motion, nay)      			
  close_ballot(Agent, Motion)          
  declare(Agent, Motion, carried/not_carried)	
 ****************************************/                          

/********************************
  PROTOCOL FLOW 
  propose(Ag,M), second(Ag,M), vote(V1,M,Vote),...,vote(Vn,M,Vote),
  close_ballot(C,M), declare(C, M, Outcome)

  agents start voting as soon as there is a secondment, ie there is no open_ballot
 ********************************/

 initially(perm_close_ballot(_M)=null).

 initiatedAt(perm_close_ballot(M)=false,T):-
     happensAt(open_ballot(_,M),T),
     holdsAt(perm_close_ballot(M)=null,T).

 maxDuration(perm_close_ballot(M)=false,perm_close_ballot(M)=true, 10).

 initiatedAt(perm_close_ballot(M)=null,T):-
     happensAt(close_ballot(_,M),T),
     holdsAt(perm_close_ballot(M)=true,T).

% The elements of these domains are derived from the ground arguments of input entitites
dynamicDomain(person(_P)).

% Grounding of input entities

grounding(open_ballot(Ag, M)) :- person(Ag), motion(M).
grounding(close_ballot(Ag, M)) :- person(Ag), motion(M).

grounding(perm_close_ballot(M)=null):- motion(M).
grounding(perm_close_ballot(M)=false):- motion(M).
grounding(perm_close_ballot(M)=true):- motion(M).
