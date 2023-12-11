% Basic Event Calculus

%% Include the BASIC EVENT CALCULUS THEORY
#include 'bec_theory2.incl'.

%% Load event narrative

#include 'input/netbill-1-50.pl'.

%% Grounding of Entities %% 
%merchant(agentM).
%consumer(agentC).
goods(book).
price(10).
%merchant(M) :- Temp is M mod 10, TempM=0.
%consumer(C) :- TempC is C mod 3, TempC>0.

%% Domain Knowledge %%
initiates(present_quote(M,C,GD,P), quote(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD), price(P).

terminates(accept_quote(C,M,GD), quote(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD).

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
