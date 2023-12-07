

initiatedAt(status(_M)=null, T1, -1, T2) :- T1=<(-1), -1<T2.

% in the 2 rules below we do not have a constraint on the role of the agents
% ie anyone may propose or second a motion
initiatedAt(status(M)=proposed, T1, T, T2) :-
     happensAtIE(propose(_P,M), T), 
     T1 =< T, T< T2,
     holdsAtCyclic(M, status(M)=null, T).
initiatedAt(status(M)=voting, T1, T, T2) :-
     happensAtIE(second(_S,M), T),
     T1 =< T, T< T2,
     holdsAtCyclic(M, status(M)=proposed, T).
initiatedAt(status(M)=voted, T1, T, T2) :-
     happensAtIE(close_ballot(C,M), T), 
     T1 =< T, T< T2,
     role_of(C,chair),
     holdsAtCyclic(M, status(M)=voting, T).
initiatedAt(status(M)=null, T1, T, T2) :-
     happensAtIE(declare(C,M,_), T), 
     T1 =< T, T< T2,
     role_of(C,chair),
     holdsAtCyclic(M, status(M)=voted, T).


initiatedAt(outcome(M)=Outcome, T1, T, T2) :-
     happensAtIE(declare(C,M,Outcome), T), 
     T1 =< T, T< T2,
     holdsAtProcessedSimpleFluent(M, status(M)=voted, T),   
     role_of(C,chair).
terminatedAt(outcome(M)=_O, T1, T, T2) :-
     happensAtProcessedSimpleFluent(M, start(status(M)=proposed), T),
     T1 =< T, T< T2.

holdsForSDFluent(pow(propose(M))=true, I) :-
     holdsForProcessedSimpleFluent(M, status(M)=null, I).
holdsForSDFluent(pow(second(M))=true, I) :-
     holdsForProcessedSimpleFluent(M, status(M)=proposed, I).
% a voter is empowered to vote many times until the ballot is closed;
% only the most recent vote counts
% the fluent below is ground only for voters
holdsForSDFluent(pow(vote(M))=true, I) :-
     holdsForProcessedSimpleFluent(M, status(M)=voting, I).
% the fluent below is ground only for chairs
holdsForSDFluent(pow(close_ballot(M))=true, I) :-
     holdsForProcessedSimpleFluent(M, status(M)=voting, I).
% the chair is empowered to declare the outcome of the result either way
% the fluent below is ground only for chairs
holdsForSDFluent(pow(declare(M))=true, I) :-
     holdsForProcessedSimpleFluent(M, status(M)=voted, I).


cachingOrder2(_131248, status(_131248)=null) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=proposed) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=voting) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=voted) :-
     queryMotion(_131248).

cachingOrder2(_131142, pow(propose(_131142))=true) :-
     queryMotion(_131142).

cachingOrder2(_131142, pow(second(_131142))=true) :-
     queryMotion(_131142).

cachingOrder2(_131142, pow(vote(_131142))=true) :-
     queryMotion(_131142).

cachingOrder2(_131142, pow(close_ballot(_131142))=true) :-
     queryMotion(_131142).

cachingOrder2(_131142, pow(declare(_131142))=true) :-
     queryMotion(_131142).

cachingOrder2(_131248, outcome(_131248)=carried) :-
     queryMotion(_131248).

cachingOrder2(_131248, outcome(_131248)=not_carried) :-
     queryMotion(_131248).

initDeadlines(Mult) :- 
     StatusDeadline is Mult * 10,
     nb_setval(statusDeadline, StatusDeadline),
     AuxPerDeadline is Mult * 8,
     nb_setval(auxPerDeadline, AuxPerDeadline),
     SanctionedDeadline is Mult * 4,
     nb_setval(sanctionedDeadline, SanctionedDeadline).