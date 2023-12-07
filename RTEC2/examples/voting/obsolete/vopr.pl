/****************************************************************
 *                                                              *
 * A Voting Protocol (VoPr)					*
 * Jeremy Pitt, Imperial College London				*
 * Event Calculus by Marek Sergot				*
 * Original chaired Floor Control Protocol by Alexander Artikis * 
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

% ----- There are no rigid facts in the voting protocol


/****************************************
 * SYNTAX OF ACTIONS                    *
 *                                      *
 * open_session(Agent, Session)         *
 * close_session(Agent, Session)        *
 * propose(Agent, Motion)      		*
 * second(Agent, Motion) 		*
 * open_ballot(Agent, Motion)           *
 * close_ballot(Agent, Motion)          *
 * vote(Agent, Motion, aye)      	*
 * vote(Agent, Motion, nay)      	*
 * declare(Agent, Motion, carried)      *
 * declare(Agent, Motion, not_carried)	*
 ***************************************/                          


/*****************
 * INITIAL STATE *
 *****************/

% ----- We specify the value of every simple fluent at the initial state 

% ----- No motion has any status or votes to start off with
% ----- may not need these
initially( status(_) = null ).
%initially( votes(_) = (0,0) ).
%initially( voted(_,_) = nil ).
initially( sitting(_) = false ).
% ----- who qualifies to do what...
initially( qualifies(cAgent,chair) = true ).	
initially( qualifies(pAgent,proposer) = true ).	
initially( qualifies(sAgent,proposer) = true ).	
initially( qualifies(pAgent,seconder) = true ).	
initially( qualifies(sAgent,seconder) = true ).	
initially( qualifies(cAgent,voter) = true ).	
initially( qualifies(pAgent,voter) = true ).	
initially( qualifies(sAgent,voter) = true ).	
initially( qualifies(vAgent,voter) = true ).	
initially( qualifies(vAgent1,voter) = true ).	
initially( qualifies(vAgent2,voter) = true ).	
% ----- agents are assigned to roles...
% ----- assume a role-assignement protocol has operated on the qualifies...

initially( role_of(cAgent,chair) = true ).	% chair agent
%initially( role_of(pAgent,proposer) = true ).	% chair agent
%initially( role_of(sAgent,proposer) = true ).	% chair agent
initially( role_of(cAgent,voter) = true ).	% chair agent
initially( role_of(pAgent,voter) = true ).	% proposer agent
initially( role_of(sAgent,voter) = true ).	% seconder agent
initially( role_of(vAgent,voter) = true ).	% ordinary voter agent
initially( role_of(vAgent1,voter) = true ).	% ordinary voter agent
initially( role_of(vAgent2,voter) = true ).	% ordinary voter agent
% ----- initially no agent is sanctioned
initially( sanction(cAgent) = [] ).
initially( sanction(pAgent) = [] ).
initially( sanction(sAgent) = [] ).
initially( sanction(vAgent) = [] ).
initially( sanction(vAgent1) = [] ).
initially( sanction(vAgent2) = [] ).
% ----- otherwise initially every other boolean valued fluent is false
% ----- the value of 'pow', 'per', `obl' and sanction is determined by state constraints                     
initially( Fluent = false ) :-
	\+ ( Fluent = status(_) ),
	\+ ( Fluent = votes(_,_) ),
	\+ ( Fluent = sitting(_) ),
	\+ ( Fluent = voted(_,_) ),
	\+ ( Fluent = role_of(_,_) ),
	\+ ( Fluent = pow(_, _) ),
	\+ ( Fluent = per(_, _) ),
	\+ ( Fluent = obl(_, _) ),
	\+ ( Fluent = sanction(_) ),
	\+ initially( Fluent = true ).
/************
 * SESSIONS *
 ***********/

initiates( open_session(C,S), sitting(S)=true, T ) :-
	holdsAt( pow(C, open_session(C,S))=true, T ).
initiates( open_session(C,S), resolutions=([],[]), T ) :-
	holdsAt( pow(C, open_session(C,S))=true, T ).
initiates( close_session(C,S), sitting(_)=false, T ) :-
	holdsAt( pow(C, close_session(C,S))=true, T ).

/********************
 * STATE of MOTIONS *
 *******************/
% -----      pAgent       sAgent       chair      chair      chair
% -----     propose       second   open_ballot close_ballot declare
% ----- (null) --> proposed --> seconded --> voting --> voted --> {carried | not_carried}

initiates( propose(A,M), status(M)=proposed, T ) :-
	holdsAt( pow(A, propose(A,M))=true, T ).
initiates( second(B,M), status(M)=seconded, T ) :-
	holdsAt( pow(B, second(B,M))=true, T ).
initiates( open_ballot(C,M), status(M)=voting(T), T ) :-
	holdsAt( pow(C, open_ballot(C,M))=true, T ).
initiates( close_ballot(C,M), status(M)=voted, T ) :-
	holdsAt( pow(C, close_ballot(C,M))=true, T ).
initiates( declare(C,M,carried), status(_)=null, T ) :-
	holdsAt( pow(C, declare(C,M,_))=true, T ).
initiates( declare(C,M,not_carried), status(_)=null, T ) :-
	holdsAt( pow(C, declare(C,M,_))=true, T ).
initiates( declare(C,M,carried), resolutions=([M|Ms],Ns), T ) :-
	holdsAt( pow(C, declare(C,M,_))=true, T ),
	holdsAt( resolutions=(Ms,Ns), T ).
initiates( declare(C,M,not_carried), resolutions=(Ms,[M|Ns]), T ) :-
	holdsAt( pow(C, declare(C,M,_))=true, T ),
	holdsAt( resolutions=(Ms,Ns), T ).
/***********************
 * INSTITUTIONAL POWER *
 ***********************/

holdsAt( pow(C, open_session(C,S))=true, T ) :-
	holdsAt( sitting(S)=false, T ),
	holdsAt( role_of(C,chair)=true, T ).
holdsAt( pow(A, propose(A,M))=true, T ) :-
	holdsAt( status(M)=null, T ),
	holdsAt( role_of(A,proposer)=true, T ).
holdsAt( pow(B, second(B,M))=true, T ) :-
	holdsAt( status(M)=proposed, T ),
	holdsAt( role_of(B,seconder)=true, T ).
holdsAt( pow(C, open_ballot(C,M))=true, T ) :-
	holdsAt( status(M)=seconded, T ),
	holdsAt( role_of(C,chair)=true, T ).

holdsAt( pow(V, vote(V,M,_))=true, T ) :-
	holdsAt( status(M)=voting(_), T ),
	holdsAt( role_of(V,voter)=true, T ),
	\+ holdsAt( role_of(V,chair)=true, T ),
	holdsAt( voted(V,M)=nil, T ).
holdsAt( pow(C, close_ballot(C,M))=true, T ) :-
	holdsAt( status(M)=voting(Te), T ), Te < T,
	holdsAt( role_of(C,chair)=true, T ).
holdsAt( pow(C, declare(C,M,_))=true, T ) :-
	holdsAt( status(M)=voted, T ),
	holdsAt( role_of(C,chair)=true, T ).
holdsAt( pow(C, close_session(C,S))=true, T ) :-
	holdsAt( sitting(S)=true, T ),
	holdsAt( role_of(C,chair)=true, T ).
holdsAt( pow(Agent, Action) = false, T ) :-
	\+ holdsAt( pow(Agent, Action) = true, T ).


/*****************************
 * ROLE ASSIGNMENT (SORT OF) *
 ****************************/

initiates( propose(A,M), role_of(B,seconder)=true, T ) :-
	holdsAt( pow(A, propose(A,M))=true, T ),
	holdsAt( qualifies(B,seconder)=true, T ),
	A \= B.
initiates( second(B1,M), role_of(B2,seconder)=false, T ) :-
	holdsAt( pow(B1, second(B1,M))=true, T ),
        holdsAt( qualifies(B2,seconder)=true, T ).
initiates( open_session(C,M), role_of(A,proposer)=true, T ) :-
	holdsAt( pow(C, open_session(C,M))=true, T ),
	holdsAt( qualifies(A,proposer)=true, T ).
initiates( close_session(C,M), role_of(A,proposer)=false, T ) :-
	holdsAt( pow(C, close_session(C,M))=true, T ),
	holdsAt( qualifies(A,proposer)=true, T ).

/*****************************
 * VOTING and COUNTING VOTES *
 ****************************/
% ----- open ballot and initiate votes to (0,0)
% ----- vote for (F,A) --> (F1,A)
% ----- vote against (F,A) --> (F,A1)
% ----- power to vote removed by either act of voting or chair closing the ballot

initiates( open_ballot(C,M), votes(M)=(0,0), T ) :-
	holdsAt( pow(C, open_ballot(C,M))=true, T ).
initiates( open_ballot(C,M), voted(V,M)=nil, T ) :-
        holdsAt( pow(C, open_ballot(C,M))=true, T ),
	holdsAt( role_of(V,voter)=true, T ).
initiates( vote(V,M,aye), votes(M)=(F1,A), T ) :-
	holdsAt( pow(V, vote(V,M,_))=true, T ),
	holdsAt( votes(M)=(F,A), T ),
	F1 is F + 1.
initiates( vote(V,M,aye), voted(V,M)=aye, T ) :-
	holdsAt( pow(V, vote(V,M,_))=true, T ).
initiates( vote(V,M,nay), votes(M)=(F,A1), T ) :-
	holdsAt( pow(V, vote(V,M,_))=true, T ),
	holdsAt( votes(M)=(F,A), T ),
	A1 is A + 1.
initiates( vote(V,M,nay), voted(V,M)=nay, T ) :-
	holdsAt( pow(V, vote(V,M,_))=true, T ).
% ----- revocation of vote
initiates( revoke(V,M), votes(M)=(F,A), T ) :-
	holdsAt( voted(V,M)=aye, T ),
	holdsAt( votes(M)=(F1,A), T ),
	F is F1 - 1.
initiates( revoke(V,M), voted(V,M)=nil, T ) :-
	holdsAt( voted(V,M)=aye, T ).
initiates( revoke(V,M), votes(M)=(F,A), T ) :-
	holdsAt( voted(V,M)=nay, T ),
	holdsAt( votes(M)=(F,A1), T ),
	A is A1 - 1.
initiates( revoke(V,M), voted(V,M)=nil, T ) :-
	holdsAt( voted(V,M)=nay, T ).


/**************
 * PERMISSION *
 **************/

holdsAt( per(A, propose(A,M))=true, T ) :-
        holdsAt( pow(A, propose(A,M))=true, T ).
holdsAt( per(B, second(B,M))=true, T ) :-
        holdsAt( pow(B, second(B,M))=true, T ).
holdsAt( per(C, open_session(C,S))=true, T ) :-
        holdsAt( pow(C, open_session(C,S))=true, T ).
holdsAt( per(C, open_ballot(C,M))=true, T ) :-
        holdsAt( pow(C, open_ballot(C,M))=true, T ).
/*
holdsAt( per(C,close_ballot(C,M))=true, T ) :-
        holdsAt( pow(C, close_ballot(C,M))=true, T ),
	holdsAt( status(M)=voting(Te), T ),
	Te4 is Te + 4,
	T >= Te4.
*/
holdsAt( per(C,close_ballot(C,M))=true, T ) :-
        holdsAt( pow(C, close_ballot(C,M))=true, T ),
	%holdsAt( status(M)=voting(Te), T ),
	holdsAt( votes(M)=(F,A), T ),
	All is F + A, All > 1.5.
holdsAt( per(C, declare(C,M,_))=true, T ) :-
        holdsAt( pow(C, declare(C,M,_))=true, T ).
holdsAt( per(C, close_session(C,S))=true, T ) :-
        holdsAt( pow(C, close_session(C,S))=true, T ),
	\+ holdsAt( status(_) = proposed, T ),
	\+ holdsAt( status(_) = seconded, T ),
	\+ holdsAt( status(_) = voting(_), T ),
	\+ holdsAt( status(_) = voted, T ).
holdsAt( per(V, vote(V,M,_))=true, T ) :-
        holdsAt( pow(V, vote(V,M,_))=true, T ).
holdsAt( per(Agent, Action) = false, T ) :-
	\+ holdsAt( per(Agent, Action) = true, T ).

/**************
 * OBLIGATION *
 **************/
holdsAt( obl(C, open_ballot(C,M))=true, T ) :-
        holdsAt( pow(C, open_ballot(C,M))=true, T ).
holdsAt( obl(C, close_ballot(C,M))=true, T ) :-
        holdsAt( pow(C, close_ballot(C,M))=true, T ),
	%holdsAt( status(M)=voting(Te), T ),
	holdsAt( votes(M)=(F,A), T ),
	All is F + A, All = 3.
/*
	holdsAt( role_of(C,chair)=true, T ),
	holdsAt( status(M)=voting(Te), T ),
	Te8 is Te + 5,
	T >= Te8.
*/
holdsAt( obl(C, declare(C,M,carried))=true, T ) :-
	holdsAt( role_of(C,chair)=true, T ),
	holdsAt( status(M)=voted, T ),
	holdsAt( votes(M)=(F,A), T ),
	F > A, !.
holdsAt( obl(C, declare(C,M,not_carried))=true, T ) :-
	holdsAt( role_of(C,chair)=true, T ),
	holdsAt( status(M)=voted, T ),
	holdsAt( votes(M)=(F,A), T ),
	F < A, !.

holdsAt( obl(Agent, Action) = false, T ) :-
	\+ holdsAt( obl(Agent, Action) = true, T ).
/************
 * SANCTION *
 ************/

/**********************************************************************
 *								      *
 **********************************************************************/

% ----- Sanctions on the chair

initiates( declare(Chair,Motion,carried), sanction(Chair)=[101|S], T ) :-
	holdsAt( role_of(Chair,chair) = true, T ),
	holdsAt( obl(Chair, declare(Chair, Motion, not_carried)) = true, T ),
	holdsAt( sanction(Chair) = S, T ).
initiates( declare(Chair,Motion,not_carried), sanction(Chair)=[102|S], T ) :-
        holdsAt( role_of(Chair,chair) = true, T ),
        holdsAt( obl(Chair, declare(Chair, Motion, carried)) = true, T ),
        holdsAt( sanction(Chair) = S, T ).
/*
initiates( close_ballot(Chair,Motion), sanction(Chair)=[103|S], T ) :-
        holdsAt( role_of(Chair,chair) = true, T ),
        \+ holdsAt( per(Chair, close_ballot(Chair, Motion)) = true, T ),
        holdsAt( sanction(Chair) = S, T ).
initiates( close_session(Chair,Session), sanction(Chair)=[104|S], T ) :-
        holdsAt( role_of(Chair,chair) = true, T ),
        \+ holdsAt( per(Chair, close_session(Chair, Session)) = true, T ),
        holdsAt( sanction(Chair) = S, T ).

% ----- Sanctions on the proposer

initiates( second(Agent,Motion), sanction(Agent)=[201|S], T ) :-
        holdsAt( status(Motion) = proposed(P,_,_), T ),
	Agent = P,
        holdsAt( sanction(Agent) = S, T ).

% ----- Sanctions on a voter: note voting turns off pwoere to vote so first vote
% ----- would cause a sanction, so we have to check for an earlier vote with happens

initiates( vote(Agent,Motion,_), sanction(Agent)=[301|S], T ) :-
        holdsAt( status(Motion) = voting(_,_,_), T ),
        holdsAt( entitled(Agent,voter) = true, T ),
	%\+ holdsAt( pow(vote(Agent,Motion)) = true, T ),
	happens( vote(Agent,Motion,_), Te ), Te < T,
        holdsAt( sanction(Agent) = S, T ).
*/



/************************ 
 * AUXILIARY PREDICATES *
 ************************/


% ----- retrieve information about each agent in a coherent manner

holdsAt(description_of(Agent, State), T) :-
	findall(Role,      holdsAt(   role_of(Agent,Role) = true, T ), Roles),
	findall(PAction,   holdsAt( pow(Agent, PAction) = true,   T ), PActions),
	findall(PerAction, holdsAt( per(Agent, PerAction) = true, T ), PerActions),
	findall(OAction,   holdsAt( obl(Agent, OAction) = true,   T ), OActions),
	%SList = [],
	%findall(Agent,     holdsAt( sanction(Agent) = ,     T ), SList),
	holdsAt( sanction(Agent) = SList, T ),
	append([Agent,roles(Roles)],     [permissions(PerActions)], Temp1),
	append([powers(PActions)], [obligations(OActions)],   Temp2),
	append([], [sanctions(SList)],      Temp3), 
	append( Temp1, Temp2, Temp12 ),
	append( Temp12, Temp3, State ).
	%append(Temp1, Temp2, Temp12),
	%append(Temp12, [sanctions(SList)], State).
/*************
 * NARRATIVE *
 *************/
% ----- this is an example narrative, that is, a list of externally observable
% ----- events of a run of a Voting Protocol

% ----- cAgent opens the session 

/*
happens( open_session(cAgent, sesh),     1).
happens( propose(pAgent, m1),            2).
happens( second(sAgent, m1),             3).
happens( open_ballot(cAgent, m1),        4).
happens( vote(cAgent, m1, aye),          5).
happens( vote(pAgent, m1, aye),          6).
happens( vote(sAgent, m1, nay),          7).
happens( vote(vAgent1, m1, nay),         8).
happens( vote(vAgent2, m1, nay),         9).
happens( close_ballot(cAgent, m1),      10).
happens( declare(cAgent, m1, carried),  11).
happens( close_session(cAgent, sesh),  12).
*/
/*
happens( open_session(cAgent, sesh),     1).
happens( propose(pAgent, m1),            2).
happens( second(sAgent, m1),             3).
happens( open_ballot(cAgent, m1),        4).
happens( vote(pAgent, m1, aye),          5).
happens( vote(sAgent, m1, nay),          6).
happens( vote(vAgent1, m1, nay),         7).
happens( revoke(sAgent,m1),              8).
happens( vote(sAgent, m1, aye),          9).
happens( close_ballot(cAgent, m1),      10).
happens( declare(cAgent, m1, not_carried),  11).
happens( close_session(cAgent, sesh),   12).
*/
happens( open_session(cAgent, sesh),     1).
happens( propose(pAgent, m1),            2).
happens( second(sAgent, m1),             3).
happens( open_ballot(cAgent, m1),        4).
happens( vote(pAgent, m1, aye),          5).
happens( vote(sAgent, m1, nay),          6).
happens( vote(vAgent, m1, nay),          7).
happens( revoke(sAgent,m1),              8).
happens( vote(sAgent, m1, aye),          9).
happens( close_ballot(cAgent, m1),      10).
happens( declare(cAgent, m1, not_carried),  11).
happens( close_session(cAgent, sesh),   12).
/*
happens( open_session(cAgent, sesh),     1).
happens( propose(pAgent, m1),            2).
happens( second(sAgent, m1),             3).
happens( open_ballot(cAgent, m1),        4).
happens( vote(pAgent, m1, aye),          5).
happens( vote(sAgent, m1, nay),          6).
happens( vote(vAgent1, m1, nay),         7).
happens( close_ballot(cAgent, m1),       8).
happens( declare(cAgent, m1, carried),   9).
happens( close_session(cAgent, sesh),   10).
*/
/*
happens( open_session(cAgent, sesh),     1).
happens( propose(pAgent, m1),            2).
happens( second(sAgent, m1),             3).
happens( open_ballot(cAgent, m1),        4).
happens( vote(cAgent, m1, nay),          5).
happens( vote(cAgent, m1, aye),          6).
happens( close_ballot(cAgent, m1),       7).
happens( declare(cAgent, m1, carried),   8).
happens( propose(pAgent, m2),            9).
happens( close_session(cAgent, sesh),   10).
happens( start, 0 ).
happens( end, 13 ).
*/


/******************
 * SAMPLE QUERIES *
 *****************/

dump_fromto( _, StartClock, EndClock ) :-
	StartClock > EndClock.
dump_fromto( Agents, StartClock, EndClock ) :-
	write( 'Clock Time ' ), write( StartClock ), nl,
	dump_list( Agents, StartClock ),
	nl, happens( Event, StartClock ), write( Event ), nl,
	NextClock is StartClock + 1, nl,
	dump_fromto( Agents, NextClock, EndClock ).

dump_list( [], _ ).
dump_list( [Agent|T], Clock ) :-
	dump( Agent, Clock, State ),
	write( State ), nl,
	dump_list( T, Clock ).

dump( Agent, Clock, State ) :-
	holdsAt( description_of( Agent, State ), Clock ).
	
d :-
	dump_fromto( [cAgent,pAgent,sAgent,vAgent], 1, 13 ).
/*
	dump_fromto( [cAgent,pAgent,sAgent,vAgent1,vAgent2], 1, 13 ).
*/

/*
dump_fromto( [cAgent,pAgent,sAgent,vAgent1,vAgent2], 0, 12 ).

holdsAt( description_of( cAgent, State ), 0 ).
holdsAt( description_of( cAgent, State ), 1 ).
holdsAt( description_of( pAgent, State ), 0 ).
holdsAt( description_of( pAgent, State ), 1 ).
holdsAt( description_of( sAgent, State ), 0 ).
holdsAt( description_of( sAgent, State ), 1 ).
holdsAt( description_of( vAgent, State ), 0 ).
holdsAt( description_of( vAgent, State ), 1 ).
*/
