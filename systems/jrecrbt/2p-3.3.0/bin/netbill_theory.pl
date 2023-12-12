
initiates(presentQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).

terminates(acceptQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).
