
initiates(propose(_,M), motionStatus(M, proposed),T):-
	holds_at(motionStatus(M, null),T).

terminates(propose(_,M),motionStatus(M, null),T).

initiates(second(_,M),motionStatus(M, voting),T):-
	holds_at(motionStatus(M, proposed),T).

terminates(second(_,M),motionStatus(M, proposed),T).

initiates(close_ballot(_,M), motionStatus(M, voted),T):-
	holds_at(motionStatus(M, voting),T).

terminates(close_ballot(_,M),motionStatus(M, voting),T).

initiates(declare(_,M,_),motionStatus(M, null),T):-
	holds_at(motionStatus(M,voted),T).

terminates(declare(_,M,_),motionStatus(M, voted),T).

initially(motionStatus(1, null)).
initially(motionStatus(2, null)).
initially(motionStatus(3, null)).
initially(motionStatus(4, null)).
initially(motionStatus(5, null)).
initially(motionStatus(6, null)).
initially(motionStatus(7, null)).
initially(motionStatus(8, null)).
initially(motionStatus(9, null)).
initially(motionStatus(10, null)).

