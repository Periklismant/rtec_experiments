% ----- a quote enables the consumer to create a contract by accepting it
initiatedAt(quote(Merch,Cons,GD)=true, T) :-
	happensAt(present_quote(Merch,Cons,GD,_Price), T).
terminatedAt(quote(Merch,Cons,GD)=true, T) :-
	happensAt(accept_quote(Cons,Merch,GD), T).

% Grounding of input entities:
grounding(present_quote(M,C,GD,_)):-
	merchant(M), consumer(C), goods(GD).
grounding(accept_quote(C,M,_)):-
	merchant(M), consumer(C), goods(GD).

% Grounding of output entities:
grounding(quote(M,C,GD)=true):- 
    merchant(M), consumer(C), goods(GD).
grounding(quote(M,C,GD)=false):- 
    merchant(M), consumer(C), goods(GD).
