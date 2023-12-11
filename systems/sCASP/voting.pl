% Basic Event Calculus

%% Include the BASIC EVENT CALCULUS THEORY
#include 'bec_theory2.incl'.

%% Load event narrative

#include 'input/voting-30-5.pl'.

%% Grounding of Entities %% 
%merchant(agentM).
%consumer(agentC).
delay(5).
%merchant(M) :- Temp is M mod 10, TempM=0.
%consumer(C) :- TempC is C mod 3, TempC>0.

%% Domain Knowledge %%

%releases(open_ballot(C, M), permitted_to_close(M), T).

initiates(open_ballot(C,M), voting_in_progress(M), T):-
    motion(M), agent(C).

terminates(close_ballot(C,M), voting_in_progress(M), T):- 
    motion(M), agent(C).

%initiates(close_ballot(C,M), voting_ended(M), T):- 
%    motion(M), agent(C). 

trajectory(voting_in_progress(M), T1, permitted_to_close(M), T2) :- delay(R), T2 .>=. T1 + R.

%terminates(tick, quote(M,C,GD), T):-
%	merchant(M), consumer(C), goods(GD), holdsAt(quote_deadline(M,C,GD), T).	

% After a light is turned on, it will emit red for up to two seconds
% and green after at least two seconds:
%trajectory(quote(M,C,GD), T1, quote_deadline(M,C,GD), T2) :- T1 + 3 #< T2.

%% Actions
%happens(tick, _).
%happens(present_quote(agentM,agentC,goods1), 2).
%happens(accept_quote(agentM,agentC,goods1), 4).
%happens(present_quote(agentM,agentC,goods1), 6).
%happens(tick, 10).

%?- holdsAt(quote(agentM,agentC,goods1), T).
%?- holdsAt(quote_deadline(agentM,agentC,goods1), T).
