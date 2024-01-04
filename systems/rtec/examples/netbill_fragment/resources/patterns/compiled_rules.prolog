:- dynamic person_pair/2.

initiatedAt(quote(_2004,_2006,_2008)=true, _2030, _1974, _2036) :-
     happensAtIE(present_quote(_2004,_2006,_2008,_2018),_1974),
     _2030=<_1974,
     _1974<_2036.

terminatedAt(quote(_2004,_2006,_2008)=true, _2028, _1974, _2034) :-
     happensAtIE(accept_quote(_2006,_2004,_2008),_1974),
     _2028=<_1974,
     _1974<_2034.

grounding(present_quote(_2268,_2270,_2272,_2274)) :- 
     person_pair(_2268,_2270),goods(_2272).

grounding(accept_quote(_2268,_2270,_2272)) :- 
     person_pair(_2270,_2268),goods(_2272).

grounding(quote(_2274,_2276,_2278)=true) :- 
     person_pair(_2274,_2276),goods(_2278).

grounding(quote(_2274,_2276,_2278)=false) :- 
     person_pair(_2274,_2276),goods(_2278).

inputEntity(present_quote(_2028,_2030,_2032,_2034)).
inputEntity(accept_quote(_2028,_2030,_2032)).
inputEntity(quote(_2034,_2036,_2038)=false).

outputEntity(quote(_2108,_2110,_2112)=true).

event(present_quote(_2164,_2166,_2168,_2170)).
event(accept_quote(_2164,_2166,_2168)).

simpleFluent(quote(_2238,_2240,_2242)=true).

sDFluent(quote(_2300,_2302,_2304)=false).

index(present_quote(_2308,_2362,_2364,_2366),_2308).
index(accept_quote(_2308,_2362,_2364),_2308).
index(quote(_2308,_2368,_2370)=true,_2308).
index(quote(_2308,_2368,_2370)=false,_2308).


cachingOrder2(_2566, quote(_2566,_2568,_2570)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2566,_2568),goods(_2570).

collectGrounds([present_quote(_2222,_2224,_2240,_2242), accept_quote(_2224,_2222,_2240), quote(_2222,_2224,_2246)=false],person_pair(_2222,_2224)).

dgrounded(quote(_2314,_2316,_2318)=true, person_pair(_2314,_2316)).
