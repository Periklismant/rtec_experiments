:- dynamic person_pair/2.

initiatedAt(quote(_2008,_2010,_2012)=true, _2034, _1978, _2040) :-
     happensAtIE(present_quote(_2008,_2010,_2012,_2022),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(quote(_2008,_2010,_2012)=true, _2032, _1978, _2038) :-
     happensAtIE(accept_quote(_2010,_2008,_2012),_1978),
     _2032=<_1978,
     _1978<_2038.

grounding(present_quote(_2272,_2274,_2276,_2278)) :- 
     person_pair(_2272,_2274),goods(_2276).

grounding(accept_quote(_2272,_2274,_2276)) :- 
     person_pair(_2274,_2272),goods(_2276).

grounding(quote(_2278,_2280,_2282)=true) :- 
     person_pair(_2278,_2280),goods(_2282).

grounding(quote(_2278,_2280,_2282)=false) :- 
     person_pair(_2278,_2280),goods(_2282).

inputEntity(present_quote(_2032,_2034,_2036,_2038)).
inputEntity(accept_quote(_2032,_2034,_2036)).
inputEntity(quote(_2038,_2040,_2042)=false).

outputEntity(quote(_2112,_2114,_2116)=true).

event(present_quote(_2168,_2170,_2172,_2174)).
event(accept_quote(_2168,_2170,_2172)).

simpleFluent(quote(_2242,_2244,_2246)=true).

sDFluent(quote(_2304,_2306,_2308)=false).

index(present_quote(_2312,_2366,_2368,_2370),_2312).
index(accept_quote(_2312,_2366,_2368),_2312).
index(quote(_2312,_2372,_2374)=true,_2312).
index(quote(_2312,_2372,_2374)=false,_2312).


cachingOrder2(_2570, quote(_2570,_2572,_2574)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2570,_2572),goods(_2574).

collectGrounds([present_quote(_2226,_2228,_2244,_2246), accept_quote(_2228,_2226,_2244), quote(_2226,_2228,_2250)=false],person_pair(_2226,_2228)).

dgrounded(quote(_2318,_2320,_2322)=true, person_pair(_2318,_2320)).
