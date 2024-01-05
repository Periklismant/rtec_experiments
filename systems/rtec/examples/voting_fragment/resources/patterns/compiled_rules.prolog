initiatedAt(voting_in_progress(_2004)=true, _2022, _1974, _2028) :-
     happensAtIE(open_ballot(_2008,_2004),_1974),
     _2022=<_1974,
     _1974<_2028.

terminatedAt(voting_in_progress(_2004)=false, _2022, _1974, _2028) :-
     happensAtIE(close_ballot(_2008,_2004),_1974),
     _2022=<_1974,
     _1974<_2028.

fi(voting_in_progress(_2008)=true,voting_in_progress(_2008)=false,5):-
     grounding(voting_in_progress(_2008)=true),
     grounding(voting_in_progress(_2008)=false).

grounding(open_ballot(_2272,_2274)) :- 
     agent(_2272),motion(_2274).

grounding(close_ballot(_2272,_2274)) :- 
     agent(_2272),motion(_2274).

grounding(voting_in_progress(_2278)=true) :- 
     motion(_2278).

grounding(voting_in_progress(_2278)=false) :- 
     motion(_2278).

inputEntity(open_ballot(_2028,_2030)).
inputEntity(close_ballot(_2028,_2030)).

outputEntity(voting_in_progress(_2102)=true).
outputEntity(voting_in_progress(_2102)=false).

event(open_ballot(_2164,_2166)).
event(close_ballot(_2164,_2166)).

simpleFluent(voting_in_progress(_2238)=true).
simpleFluent(voting_in_progress(_2238)=false).


index(open_ballot(_2308,_2362),_2308).
index(close_ballot(_2308,_2362),_2308).
index(voting_in_progress(_2308)=true,_2308).
index(voting_in_progress(_2308)=false,_2308).


cachingOrder2(_2566, voting_in_progress(_2566)=true) :- % level in dependency graph: 1, processing order in component: 1
     motion(_2566).

cachingOrder2(_2566, voting_in_progress(_2566)=false) :- % level in dependency graph: 1, processing order in component: 2
     motion(_2566).

