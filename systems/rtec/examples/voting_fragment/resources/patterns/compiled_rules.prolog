initiatedAt(voting_in_progress(_11384)=true, _11402, _11354, _11408) :-
     happensAtIE(open_ballot(_11388,_11384),_11354),
     _11402=<_11354,
     _11354<_11408.

terminatedAt(voting_in_progress(_11384)=false, _11402, _11354, _11408) :-
     happensAtIE(close_ballot(_11388,_11384),_11354),
     _11402=<_11354,
     _11354<_11408.

fi(voting_in_progress(_11388)=true,voting_in_progress(_11388)=false,5):-
     grounding(voting_in_progress(_11388)=true),
     grounding(voting_in_progress(_11388)=false).

grounding(open_ballot(_11624,_11626)) :- 
     agent(_11624),motion(_11626).

grounding(close_ballot(_11624,_11626)) :- 
     agent(_11624),motion(_11626).

grounding(voting_in_progress(_11630)=true) :- 
     motion(_11630).

grounding(voting_in_progress(_11630)=false) :- 
     motion(_11630).

inputEntity(open_ballot(_11414,_11416)).
inputEntity(close_ballot(_11414,_11416)).

outputEntity(voting_in_progress(_11494)=true).
outputEntity(voting_in_progress(_11494)=false).

event(open_ballot(_11562,_11564)).
event(close_ballot(_11562,_11564)).

simpleFluent(voting_in_progress(_11642)=true).
simpleFluent(voting_in_progress(_11642)=false).


index(open_ballot(_11718,_11778),_11718).
index(close_ballot(_11718,_11778),_11718).
index(voting_in_progress(_11718)=true,_11718).
index(voting_in_progress(_11718)=false,_11718).


cachingOrder2(_11994, voting_in_progress(_11994)=true) :- % level in dependency graph: 1, processing order in component: 1
     motion(_11994).

cachingOrder2(_11994, voting_in_progress(_11994)=false) :- % level in dependency graph: 1, processing order in component: 2
     motion(_11994).

