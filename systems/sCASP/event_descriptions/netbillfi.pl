% Basic Event Calculus

%% Include the BASIC EVENT CALCULUS THEORY
#include '../src/bec.incl'.

%% Grounding of Entities %% 
goods(book).
price(10).
delay(5).

%% Domain Knowledge %%
initiates(present_quote(M,C,GD,P), quote_true(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD), price(P).
terminates(present_quote(M,C,GD,P), quote_false(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD), price(P).

terminates(accept_quote(C,M,GD), quote_false(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD).
terminates(accept_quote(C,M,GD), quote_true(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD).

trajectory(quote_true(M,C,GD), T1, quote_false(M,C,GD), T2) :- delay(R), T2 .>=. T1 + R, merchant(M), consumer(C), goods(GD).
