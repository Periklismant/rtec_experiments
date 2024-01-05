:- dynamic person/1, person_pair/2.

initiatedAt(quote(_2002,_2004,_2006)=true, _2028, _1972, _2034) :-
     happensAtIE(present_quote(_2002,_2004,_2006,_2016),_1972),
     _2028=<_1972,
     _1972<_2034.

initiatedAt(contract(_2002,_2004,_2006)=true, _2064, _1972, _2070) :-
     happensAtIE(accept_quote(_2004,_2002,_2006),_1972),_2064=<_1972,_1972<_2070,
     updateVariableTemp(rule_evaluations,1),
     holdsAtProcessedSimpleFluent(_2002,quote(_2002,_2004,_2006)=true,_1972).

terminatedAt(quote(_2002,_2004,_2006)=true, _2026, _1972, _2032) :-
     happensAtIE(accept_quote(_2004,_2002,_2006),_1972),
     _2026=<_1972,
     _1972<_2032.

fi(quote(_2006,_2008,_2010)=true,quote(_2006,_2008,_2010)=false,5):-
     grounding(quote(_2006,_2008,_2010)=true),
     grounding(quote(_2006,_2008,_2010)=false).

fi(contract(_2006,_2008,_2010)=true,contract(_2006,_2008,_2010)=false,6):-
     grounding(contract(_2006,_2008,_2010)=true),
     grounding(contract(_2006,_2008,_2010)=false).

grounding(request_quote(_2302,_2304,_2306)) :- 
     person_pair(_2304,_2302).

grounding(present_quote(_2302,_2304,_2306,_2308)) :- 
     person_pair(_2302,_2304).

grounding(accept_quote(_2302,_2304,_2306)) :- 
     person_pair(_2304,_2302).

grounding(send_EPO(_2302,_2304,_2306,_2308)) :- 
     person(_2302).

grounding(send_goods(_2302,_2304,_2306,_2308,_2310)) :- 
     person(_2302).

grounding(quote(_2308,_2310,_2312)=true) :- 
     person_pair(_2308,_2310),role_of(_2310,consumer),role_of(_2308,merchant),\+_2308=_2310,queryGoodsDescription(_2312).

grounding(quote(_2308,_2310,_2312)=false) :- 
     person_pair(_2308,_2310),role_of(_2310,consumer),role_of(_2308,merchant),\+_2308=_2310,queryGoodsDescription(_2312).

grounding(contract(_2308,_2310,_2312)=true) :- 
     person_pair(_2308,_2310),role_of(_2308,merchant),role_of(_2310,consumer),\+_2308=_2310,queryGoodsDescription(_2312).

grounding(contract(_2308,_2310,_2312)=false) :- 
     person_pair(_2308,_2310),role_of(_2308,merchant),role_of(_2310,consumer),\+_2308=_2310,queryGoodsDescription(_2312).

p(quote(_2302,_2304,_2306)=true).

inputEntity(present_quote(_2026,_2028,_2030,_2032)).
inputEntity(accept_quote(_2026,_2028,_2030)).
inputEntity(request_quote(_2026,_2028,_2030)).
inputEntity(send_EPO(_2026,_2028,_2030,_2032)).
inputEntity(send_goods(_2026,_2028,_2030,_2032,_2034)).

outputEntity(quote(_2118,_2120,_2122)=true).
outputEntity(contract(_2118,_2120,_2122)=true).
outputEntity(quote(_2118,_2120,_2122)=false).
outputEntity(contract(_2118,_2120,_2122)=false).

event(present_quote(_2192,_2194,_2196,_2198)).
event(accept_quote(_2192,_2194,_2196)).
event(request_quote(_2192,_2194,_2196)).
event(send_EPO(_2192,_2194,_2196,_2198)).
event(send_goods(_2192,_2194,_2196,_2198,_2200)).

simpleFluent(quote(_2284,_2286,_2288)=true).
simpleFluent(contract(_2284,_2286,_2288)=true).
simpleFluent(quote(_2284,_2286,_2288)=false).
simpleFluent(contract(_2284,_2286,_2288)=false).


index(present_quote(_2366,_2420,_2422,_2424),_2366).
index(accept_quote(_2366,_2420,_2422),_2366).
index(request_quote(_2366,_2420,_2422),_2366).
index(send_EPO(_2366,_2420,_2422,_2424),_2366).
index(send_goods(_2366,_2420,_2422,_2424,_2426),_2366).
index(quote(_2366,_2426,_2428)=true,_2366).
index(contract(_2366,_2426,_2428)=true,_2366).
index(quote(_2366,_2426,_2428)=false,_2366).
index(contract(_2366,_2426,_2428)=false,_2366).


cachingOrder2(_2654, quote(_2654,_2656,_2658)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2654,_2656),role_of(_2656,consumer),role_of(_2654,merchant),\+_2654=_2656,queryGoodsDescription(_2658).

cachingOrder2(_2654, quote(_2654,_2656,_2658)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2654,_2656),role_of(_2656,consumer),role_of(_2654,merchant),\+_2654=_2656,queryGoodsDescription(_2658).

cachingOrder2(_3056, contract(_3056,_3058,_3060)=true) :- % level in dependency graph: 2, processing order in component: 1
     person_pair(_3056,_3058),role_of(_3056,merchant),role_of(_3058,consumer),\+_3056=_3058,queryGoodsDescription(_3060).

cachingOrder2(_3056, contract(_3056,_3058,_3060)=false) :- % level in dependency graph: 2, processing order in component: 2
     person_pair(_3056,_3058),role_of(_3056,merchant),role_of(_3058,consumer),\+_3056=_3058,queryGoodsDescription(_3060).

collectGrounds([send_EPO(_2274,_2288,_2290,_2292), send_goods(_2274,_2288,_2290,_2292,_2294)],person(_2274)).

collectGrounds([present_quote(_2262,_2264,_2290,_2292), accept_quote(_2264,_2262,_2290), request_quote(_2264,_2262,_2290)],person_pair(_2262,_2264)).

dgrounded(quote(_2628,_2630,_2632)=true, person_pair(_2628,_2630)).
dgrounded(contract(_2540,_2542,_2544)=true, person_pair(_2540,_2542)).
dgrounded(quote(_2452,_2454,_2456)=false, person_pair(_2452,_2454)).
dgrounded(contract(_2364,_2366,_2368)=false, person_pair(_2364,_2366)).
