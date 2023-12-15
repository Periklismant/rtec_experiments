:- dynamic person/1, person_pair/2.

initiatedAt(quote(_2006,_2008,_2010)=true, _2032, _1976, _2038) :-
     happensAtIE(present_quote(_2006,_2008,_2010,_2020),_1976),
     _2032=<_1976,
     _1976<_2038.

initiatedAt(contract(_2006,_2008,_2010)=true, _2068, _1976, _2074) :-
     happensAtIE(accept_quote(_2008,_2006,_2010),_1976),_2068=<_1976,_1976<_2074,
     updateVariableTemp(rule_evaluations,1),
     holdsAtProcessedSimpleFluent(_2006,quote(_2006,_2008,_2010)=true,_1976).

terminatedAt(quote(_2006,_2008,_2010)=true, _2030, _1976, _2036) :-
     happensAtIE(accept_quote(_2008,_2006,_2010),_1976),
     _2030=<_1976,
     _1976<_2036.

fi(quote(_2010,_2012,_2014)=true,quote(_2010,_2012,_2014)=false,10):-
     grounding(quote(_2010,_2012,_2014)=true),
     grounding(quote(_2010,_2012,_2014)=false).

fi(contract(_2010,_2012,_2014)=true,contract(_2010,_2012,_2014)=false,10):-
     grounding(contract(_2010,_2012,_2014)=true),
     grounding(contract(_2010,_2012,_2014)=false).

grounding(request_quote(_2306,_2308,_2310)) :- 
     person_pair(_2308,_2306).

grounding(present_quote(_2306,_2308,_2310,_2312)) :- 
     person_pair(_2306,_2308).

grounding(accept_quote(_2306,_2308,_2310)) :- 
     person_pair(_2308,_2306).

grounding(send_EPO(_2306,_2308,_2310,_2312)) :- 
     person(_2306).

grounding(send_goods(_2306,_2308,_2310,_2312,_2314)) :- 
     person(_2306).

grounding(quote(_2312,_2314,_2316)=true) :- 
     person_pair(_2312,_2314),role_of(_2314,consumer),role_of(_2312,merchant),\+_2312=_2314,queryGoodsDescription(_2316).

grounding(quote(_2312,_2314,_2316)=false) :- 
     person_pair(_2312,_2314),role_of(_2314,consumer),role_of(_2312,merchant),\+_2312=_2314,queryGoodsDescription(_2316).

grounding(contract(_2312,_2314,_2316)=true) :- 
     person_pair(_2312,_2314),role_of(_2312,merchant),role_of(_2314,consumer),\+_2312=_2314,queryGoodsDescription(_2316).

grounding(contract(_2312,_2314,_2316)=false) :- 
     person_pair(_2312,_2314),role_of(_2312,merchant),role_of(_2314,consumer),\+_2312=_2314,queryGoodsDescription(_2316).

p(quote(_2306,_2308,_2310)=true).

inputEntity(present_quote(_2030,_2032,_2034,_2036)).
inputEntity(accept_quote(_2030,_2032,_2034)).
inputEntity(request_quote(_2030,_2032,_2034)).
inputEntity(send_EPO(_2030,_2032,_2034,_2036)).
inputEntity(send_goods(_2030,_2032,_2034,_2036,_2038)).

outputEntity(quote(_2122,_2124,_2126)=true).
outputEntity(contract(_2122,_2124,_2126)=true).
outputEntity(quote(_2122,_2124,_2126)=false).
outputEntity(contract(_2122,_2124,_2126)=false).

event(present_quote(_2196,_2198,_2200,_2202)).
event(accept_quote(_2196,_2198,_2200)).
event(request_quote(_2196,_2198,_2200)).
event(send_EPO(_2196,_2198,_2200,_2202)).
event(send_goods(_2196,_2198,_2200,_2202,_2204)).

simpleFluent(quote(_2288,_2290,_2292)=true).
simpleFluent(contract(_2288,_2290,_2292)=true).
simpleFluent(quote(_2288,_2290,_2292)=false).
simpleFluent(contract(_2288,_2290,_2292)=false).


index(present_quote(_2370,_2424,_2426,_2428),_2370).
index(accept_quote(_2370,_2424,_2426),_2370).
index(request_quote(_2370,_2424,_2426),_2370).
index(send_EPO(_2370,_2424,_2426,_2428),_2370).
index(send_goods(_2370,_2424,_2426,_2428,_2430),_2370).
index(quote(_2370,_2430,_2432)=true,_2370).
index(contract(_2370,_2430,_2432)=true,_2370).
index(quote(_2370,_2430,_2432)=false,_2370).
index(contract(_2370,_2430,_2432)=false,_2370).


cachingOrder2(_2658, quote(_2658,_2660,_2662)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2658,_2660),role_of(_2660,consumer),role_of(_2658,merchant),\+_2658=_2660,queryGoodsDescription(_2662).

cachingOrder2(_2658, quote(_2658,_2660,_2662)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2658,_2660),role_of(_2660,consumer),role_of(_2658,merchant),\+_2658=_2660,queryGoodsDescription(_2662).

cachingOrder2(_3060, contract(_3060,_3062,_3064)=true) :- % level in dependency graph: 2, processing order in component: 1
     person_pair(_3060,_3062),role_of(_3060,merchant),role_of(_3062,consumer),\+_3060=_3062,queryGoodsDescription(_3064).

cachingOrder2(_3060, contract(_3060,_3062,_3064)=false) :- % level in dependency graph: 2, processing order in component: 2
     person_pair(_3060,_3062),role_of(_3060,merchant),role_of(_3062,consumer),\+_3060=_3062,queryGoodsDescription(_3064).

collectGrounds([send_EPO(_2278,_2292,_2294,_2296), send_goods(_2278,_2292,_2294,_2296,_2298)],person(_2278)).

collectGrounds([present_quote(_2266,_2268,_2294,_2296), accept_quote(_2268,_2266,_2294), request_quote(_2268,_2266,_2294)],person_pair(_2266,_2268)).

dgrounded(quote(_2632,_2634,_2636)=true, person_pair(_2632,_2634)).
dgrounded(contract(_2544,_2546,_2548)=true, person_pair(_2544,_2546)).
dgrounded(quote(_2456,_2458,_2460)=false, person_pair(_2456,_2458)).
dgrounded(contract(_2368,_2370,_2372)=false, person_pair(_2368,_2370)).
