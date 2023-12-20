% Basic Event Calculus

%% Include the BASIC EVENT CALCULUS THEORY
#include 'src/bec.incl'.

%% Grounding of Entities %% 
goods(book).
price(10).

%% Domain Knowledge %%
initiates(present_quote(M,C,GD,P), quote(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD), price(P).

terminates(accept_quote(C,M,GD), quote(M,C,GD), T):-
	merchant(M), consumer(C), goods(GD).

