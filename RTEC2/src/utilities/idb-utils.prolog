% These predicates are useful for storing predicates concerning the intervals of entities, 
% such as simpleFPList, sdFPList and evTList, in the internal database.

% numberOfKeys(X) should be asserted beforehand. 
% X is the number of bins in the internal db Prolog will use to store the current predicate.

:- dynamic indexID/2.

indextoKey(Index, Key):-
	indexID(Index, IndexCounter), !,
	numberOfKeys(NumberOfKeys),
	Key is IndexCounter mod NumberOfKeys.

indextoKey(Index, Key):-
	nb_getval(index_counter, IndexCounter),
	assert(indexID(Index, IndexCounter)),
	numberOfKeys(NumberOfKeys), 
	Key is IndexCounter mod NumberOfKeys,
	NewIndexCounter is IndexCounter + 1, 
	nb_setval(index_counter, NewIndexCounter).

fetchKey(attempt(F=V), Key):-
	!, index(F=V, Index), indextoKey(Index, Key).

fetchKey(Entity, Key):-
	ground(Entity), !, 
	index(Entity, Index), indextoKey(Index, Key).
	
fetchKey(_Entity, Key):-
	current_prolog_flag(dialect, yap), !,
	current_key(_Atom, Key).

fetchKey(_Entity, Key):-
	current_prolog_flag(dialect, swi), !,
	current_key(Key).
