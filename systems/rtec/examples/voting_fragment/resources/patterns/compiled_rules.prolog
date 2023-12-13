initiatedAt(voting_in_progress(_2008)=true, _2026, _1978, _2032) :-
     happensAtIE(open_ballot(_2012,_2008),_1978),
     _2026=<_1978,
     _1978<_2032.

terminatedAt(voting_in_progress(_2008)=false, _2026, _1978, _2032) :-
     happensAtIE(close_ballot(_2012,_2008),_1978),
     _2026=<_1978,
     _1978<_2032.

fi(voting_in_progress(_2012)=true,voting_in_progress(_2012)=false,5):-
     grounding(voting_in_progress(_2012)=true),
     grounding(voting_in_progress(_2012)=false).

grounding(open_ballot(_2276,_2278)) :- 
     agent(_2276),motion(_2278).

grounding(close_ballot(_2276,_2278)) :- 
     agent(_2276),motion(_2278).

grounding(voting_in_progress(_2282)=true) :- 
     motion(_2282).

grounding(voting_in_progress(_2282)=false) :- 
     motion(_2282).

inputEntity(open_ballot(_2032,_2034)).
inputEntity(close_ballot(_2032,_2034)).

outputEntity(voting_in_progress(_2106)=true).
outputEntity(voting_in_progress(_2106)=false).

event(open_ballot(_2168,_2170)).
event(close_ballot(_2168,_2170)).

simpleFluent(voting_in_progress(_2242)=true).
simpleFluent(voting_in_progress(_2242)=false).


index(open_ballot(_2312,_2366),_2312).
index(close_ballot(_2312,_2366),_2312).
index(voting_in_progress(_2312)=true,_2312).
index(voting_in_progress(_2312)=false,_2312).


cachingOrder2(_2570, voting_in_progress(_2570)=true) :- % level in dependency graph: 1, processing order in component: 1
     motion(_2570).

cachingOrder2(_2570, voting_in_progress(_2570)=false) :- % level in dependency graph: 1, processing order in component: 2
     motion(_2570).

