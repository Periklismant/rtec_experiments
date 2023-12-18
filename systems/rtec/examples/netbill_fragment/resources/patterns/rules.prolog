% ----- a quote enables the consumer to create a contract by accepting it
initiatedAt(quote(Merch,Cons,GD)=true, T) :-
	happensAt(present_quote(Merch,Cons,GD,_Price), T).
terminatedAt(quote(Merch,Cons,GD)=true, T) :-
	happensAt(accept_quote(Cons,Merch,GD), T).

% Grounding of input entities:
grounding(present_quote(M,C,GD,_)):-
	person_pair(M,C), goods(GD).
grounding(accept_quote(C,M,GD)):-
	person_pair(M,C), goods(GD).

% The elements of these domains are derived from the ground arguments of input entitites
dynamicDomain(person_pair(_,_)).

% Grounding of output entities:
grounding(quote(M,C,GD)=true):- 
    person_pair(M,C), goods(GD).
grounding(quote(M,C,GD)=false):- 
    person_pair(M,C), goods(GD).
