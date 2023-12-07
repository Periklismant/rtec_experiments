

processEvent(Index, E) :-
	%fetchKey(E, Key),
	%recorded(Key, evTList(E, _L), RevTList), !,
	evTList(Index, E, L), !,
	%erase(RevTList),
	retract(evTList(Index, E, L)),
	findall(T, happensAtEv(E,T), ListofTimePoints),
	updateevTList(Index, E, ListofTimePoints). 

% this predicate deals with the case where no time-points for E were computed at the previous query time
processEvent(Index, E) :-
	findall(T, happensAtEv(E,T), ListofTimePoints),
	updateevTList(Index, E, ListofTimePoints). 


updateevTList(_Index, _E, []) :- !.

updateevTList(Index, E, ListofTimePoints) :- 
	%fetchKey(E, Key),
	%recordz(Key, evTList(E, ListofTimePoints), _).
	assert(evTList(Index, E, ListofTimePoints)).
