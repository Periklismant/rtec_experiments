initiatedAt(quote(_2008,_2010,_2012)=true, _2034, _1978, _2040) :-
     happensAtIE(present_quote(_2008,_2010,_2012,_2022),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(quote(_2008,_2010,_2012)=true, _2032, _1978, _2038) :-
     happensAtIE(accept_quote(_2010,_2008,_2012),_1978),
     _2032=<_1978,
     _1978<_2038.

grounding(present_quote(_2256,_2258,_2260,_2262)) :- 
     merchant(_2256),consumer(_2258),goods(_2260).

grounding(accept_quote(_2256,_2258,_2260)) :- 
     merchant(_2258),consumer(_2256),goods(_2260).

grounding(quote(_2262,_2264,_2266)=true) :- 
     merchant(_2262),consumer(_2264),goods(_2266).

grounding(quote(_2262,_2264,_2266)=false) :- 
     merchant(_2262),consumer(_2264),goods(_2266).

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
     merchant(_2570),consumer(_2572),goods(_2574).

