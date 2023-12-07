%% for netbill 
%% events: present_quote(M,C,GD,P)
%%		   accept_quote(C,M,GD)
%% fluents: quote(M,C,GD) (Val: true)

delay(quote(_, _, _), -1, 3).
delay(quote(_, _, _), 1, 0).

initially(val(quote(1,1,1),0)).
initially(val(quote(2,2,1),0)).

happens(tick, 1).
happens(tick, 2).
happens(present_quote(1,1,1,1), 2).
happens(tick, 3).
happens(present_quote(2,2,1,1), 3).
happens(tick, 4).
happens(accept_quote(2,2,1), 4).
happens(tick, 5).
happens(tick, 6).
happens(tick, 7).
happens(tick, 8).

holds(val(X,V), 0):-
	initially(val(X,V)).

holds(val(X,V), Tk):-
	happens(tick,Tk),
	Tk>0,
	initiates(val(X,V),[Ti,Tk]),
	\+ clipped(val(X,V),[Ti,Tk]).

clipped(val(X,V), [Ti,Tk]):-
	terminates(val(X,V),[Ti,Tk]).

initiates(val(quote(M,C,GD),0), [Ti,Tk]):-
	Ti is Tk - 1,
	happens(accept_quote(C,M,GD), Ti), !.

initiates(val(quote(M,C,GD),0), [Ti,Tk]):-
	delay(quote(M,C,GD), -1, D),
	Ti is Tk - D,
	happens(present_quote(M,C,GD,_), Ti),
	Tkminus1 is Tk - 1,
	holds(val(quote(M,C,GD), 1), Tkminus1), !.

initiates(val(quote(M,C,GD),1), [Ti,Tk]):-
	Ti is Tk - 1,
	happens(present_quote(M,C,GD,_), Ti), !.

initiates(val(quote(M,C,GD),V), [Ti,Tk]):-
	Ti is Tk - 1,
	happens(tick, Ti),
	holds(val(quote(M,C,GD), V), Ti).

terminates(val(quote(M,C,GD),V), [Ti,Tk]):-
	Tkminus1 is Tk-1,
	initiates(val(quote(M,C,GD), V1), [Ti,Tkminus1]), 
	V1\=V.
