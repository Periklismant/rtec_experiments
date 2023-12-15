:- dynamic person/1, person_pair/2.

initiatedAt(quote(_2006,_2008,_2010)=true, _2032, _1976, _2038) :-
     happensAtIE(present_quote(_2006,_2008,_2010,_2020),_1976),
     _2032=<_1976,
     _1976<_2038.

initiatedAt(contract(_2006,_2008,_2010)=true, _2130, _1976, _2136) :-
     happensAtIE(accept_quote(_2008,_2006,_2010),_1976),_2130=<_1976,_1976<_2136,
     updateVariableTemp(rule_evaluations,1),
     holdsAtProcessedSimpleFluent(_2006,quote(_2006,_2008,_2010)=true,_1976),
     \+holdsAtCyclic(_2006,suspended(_2006,merchant)=true,_1976),
     \+holdsAtCyclic(_2008,suspended(_2008,consumer)=true,_1976).

initiatedAt(per(present_quote(_2010,_2012))=false, _2034, _1976, _2040) :-
     happensAtIE(present_quote(_2010,_2012,_2020,_2022),_1976),
     _2034=<_1976,
     _1976<_2040.

initiatedAt(per(present_quote(_2010,_2012))=true, _2032, _1976, _2038) :-
     happensAtIE(request_quote(_2012,_2010,_2020),_1976),
     _2032=<_1976,
     _1976<_2038.

initiatedAt(obl(send_EPO(_2010,iServer,_2014))=false, _2048, _1976, _2054) :-
     happensAtIE(send_EPO(_2010,iServer,_2014,_2024),_1976),_2048=<_1976,_1976<_2054,
     price(_2014,_2024).

initiatedAt(obl(send_goods(_2010,iServer,_2014))=false, _2064, _1976, _2070) :-
     happensAtIE(send_goods(_2010,iServer,_2014,_2024,_2026),_1976),_2064=<_1976,_1976<_2070,
     decrypt(_2024,_2026,_2040),
     meets(_2040,_2014).

initiatedAt(suspended(_2006,merchant)=true, _2064, _1976, _2070) :-
     happensAtIE(present_quote(_2006,_2014,_2016,_2018),_1976),_2064=<_1976,_1976<_2070,
     holdsAtProcessedSimpleFluent(_2006,per(present_quote(_2006,_2014))=false,_1976).

initiatedAt(obl(send_EPO(_2018,iServer,_2022))=true, _1976, _1978, _1980) :-
     initiatedAt(contract(_2032,_2018,_2022)=true,_1976,_1978,_1980).

initiatedAt(obl(send_goods(_2018,iServer,_2022))=true, _1976, _1978, _1980) :-
     initiatedAt(contract(_2018,_2034,_2022)=true,_1976,_1978,_1980).

initiatedAt(obl(send_EPO(_2018,iServer,_2022))=false, _1976, _1978, _1980) :-
     initiatedAt(contract(_2032,_2018,_2022)=false,_1976,_1978,_1980).

initiatedAt(obl(send_goods(_2018,iServer,_2022))=false, _1976, _1978, _1980) :-
     initiatedAt(contract(_2018,_2034,_2022)=false,_1976,_1978,_1980).

initiatedAt(suspended(_2014,merchant)=true, _1976, _1978, _1980) :-
     initiatedAt(contract(_2014,_2028,_2030)=false,_1976,_1978,_1980),
     holdsAtCyclic(_2014,obl(send_goods(_2014,iServer,_2030))=true,_1978).

initiatedAt(suspended(_2014,consumer)=true, _1976, _1978, _1980) :-
     initiatedAt(contract(_2026,_2014,_2030)=false,_1976,_1978,_1980),
     holdsAtCyclic(_2014,obl(send_EPO(_2014,iServer,_2030))=true,_1978).

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

fi(per(present_quote(_2014,_2016))=false,per(present_quote(_2014,_2016))=true,20):-
     grounding(per(present_quote(_2014,_2016))=false),
     grounding(per(present_quote(_2014,_2016))=true).

fi(suspended(_2010,_2012)=true,suspended(_2010,_2012)=false,6):-
     grounding(suspended(_2010,_2012)=true),
     grounding(suspended(_2010,_2012)=false).

grounding(request_quote(_2328,_2330,_2332)) :- 
     person_pair(_2330,_2328).

grounding(present_quote(_2328,_2330,_2332,_2334)) :- 
     person_pair(_2328,_2330).

grounding(accept_quote(_2328,_2330,_2332)) :- 
     person_pair(_2330,_2328).

grounding(send_EPO(_2328,_2330,_2332,_2334)) :- 
     person(_2328).

grounding(send_goods(_2328,_2330,_2332,_2334,_2336)) :- 
     person(_2328).

grounding(suspended(_2334,_2336)=true) :- 
     person(_2334),role_of(_2334,_2336).

grounding(suspended(_2334,_2336)=false) :- 
     person(_2334),role_of(_2334,_2336).

grounding(quote(_2334,_2336,_2338)=true) :- 
     person_pair(_2334,_2336),role_of(_2336,consumer),role_of(_2334,merchant),\+_2334=_2336,queryGoodsDescription(_2338).

grounding(quote(_2334,_2336,_2338)=false) :- 
     person_pair(_2334,_2336),role_of(_2336,consumer),role_of(_2334,merchant),\+_2334=_2336,queryGoodsDescription(_2338).

grounding(contract(_2334,_2336,_2338)=true) :- 
     person_pair(_2334,_2336),role_of(_2334,merchant),role_of(_2336,consumer),\+_2334=_2336,queryGoodsDescription(_2338).

grounding(contract(_2334,_2336,_2338)=false) :- 
     person_pair(_2334,_2336),role_of(_2334,merchant),role_of(_2336,consumer),\+_2334=_2336,queryGoodsDescription(_2338).

grounding(pow(accept_quote(_2338,_2340,_2342))=true) :- 
     person_pair(_2340,_2338),role_of(_2340,merchant),role_of(_2338,consumer),\+_2338=_2340,queryGoodsDescription(_2342).

grounding(per(present_quote(_2338,_2340))=false) :- 
     person_pair(_2338,_2340),role_of(_2338,merchant),role_of(_2340,consumer),\+_2340=_2338.

grounding(per(present_quote(_2338,_2340))=true) :- 
     person_pair(_2338,_2340),role_of(_2338,merchant),role_of(_2340,consumer),\+_2340=_2338.

grounding(obl(send_EPO(_2338,iServer,_2342))=true) :- 
     person(_2338),role_of(_2338,consumer),queryGoodsDescription(_2342).

grounding(obl(send_goods(_2338,iServer,_2342))=true) :- 
     person(_2338),role_of(_2338,merchant),queryGoodsDescription(_2342).

grounding(obl(send_EPO(_2338,iServer,_2342))=false) :- 
     person(_2338),role_of(_2338,consumer),queryGoodsDescription(_2342).

grounding(obl(send_goods(_2338,iServer,_2342))=false) :- 
     person(_2338),role_of(_2338,merchant),queryGoodsDescription(_2342).

p(quote(_2328,_2330,_2332)=true).

p(per(present_quote(_2332,_2334))=false).

p(suspended(_2328,_2330)=true).

inputEntity(present_quote(_2030,_2032,_2034,_2036)).
inputEntity(accept_quote(_2030,_2032,_2034)).
inputEntity(request_quote(_2030,_2032,_2034)).
inputEntity(send_EPO(_2030,_2032,_2034,_2036)).
inputEntity(send_goods(_2030,_2032,_2034,_2036,_2038)).
inputEntity(pow(accept_quote(_2040,_2042,_2044))=true).

outputEntity(quote(_2128,_2130,_2132)=true).
outputEntity(contract(_2128,_2130,_2132)=true).
outputEntity(per(present_quote(_2132,_2134))=false).
outputEntity(per(present_quote(_2132,_2134))=true).
outputEntity(obl(send_EPO(_2132,_2134,_2136))=false).
outputEntity(obl(send_goods(_2132,_2134,_2136))=false).
outputEntity(suspended(_2128,_2130)=true).
outputEntity(obl(send_EPO(_2132,_2134,_2136))=true).
outputEntity(obl(send_goods(_2132,_2134,_2136))=true).
outputEntity(quote(_2128,_2130,_2132)=false).
outputEntity(contract(_2128,_2130,_2132)=false).
outputEntity(suspended(_2128,_2130)=false).

event(present_quote(_2250,_2252,_2254,_2256)).
event(accept_quote(_2250,_2252,_2254)).
event(request_quote(_2250,_2252,_2254)).
event(send_EPO(_2250,_2252,_2254,_2256)).
event(send_goods(_2250,_2252,_2254,_2256,_2258)).

simpleFluent(quote(_2342,_2344,_2346)=true).
simpleFluent(contract(_2342,_2344,_2346)=true).
simpleFluent(per(present_quote(_2346,_2348))=false).
simpleFluent(per(present_quote(_2346,_2348))=true).
simpleFluent(obl(send_EPO(_2346,_2348,_2350))=false).
simpleFluent(obl(send_goods(_2346,_2348,_2350))=false).
simpleFluent(suspended(_2342,_2344)=true).
simpleFluent(obl(send_EPO(_2346,_2348,_2350))=true).
simpleFluent(obl(send_goods(_2346,_2348,_2350))=true).
simpleFluent(quote(_2342,_2344,_2346)=false).
simpleFluent(contract(_2342,_2344,_2346)=false).
simpleFluent(suspended(_2342,_2344)=false).

sDFluent(pow(accept_quote(_2474,_2476,_2478))=true).

index(present_quote(_2478,_2532,_2534,_2536),_2478).
index(accept_quote(_2478,_2532,_2534),_2478).
index(request_quote(_2478,_2532,_2534),_2478).
index(send_EPO(_2478,_2532,_2534,_2536),_2478).
index(send_goods(_2478,_2532,_2534,_2536,_2538),_2478).
index(quote(_2478,_2538,_2540)=true,_2478).
index(contract(_2478,_2538,_2540)=true,_2478).
index(per(present_quote(_2478,_2542))=false,_2478).
index(per(present_quote(_2478,_2542))=true,_2478).
index(obl(send_EPO(_2478,_2542,_2544))=false,_2478).
index(obl(send_goods(_2478,_2542,_2544))=false,_2478).
index(suspended(_2478,_2538)=true,_2478).
index(obl(send_EPO(_2478,_2542,_2544))=true,_2478).
index(obl(send_goods(_2478,_2542,_2544))=true,_2478).
index(quote(_2478,_2538,_2540)=false,_2478).
index(contract(_2478,_2538,_2540)=false,_2478).
index(suspended(_2478,_2538)=false,_2478).
index(pow(accept_quote(_2478,_2542,_2544))=true,_2478).

cyclic(contract(_2760,_2762,_2764)=true).
cyclic(suspended(_2760,_2762)=true).
cyclic(obl(send_EPO(_2764,_2766,_2768))=true).
cyclic(obl(send_goods(_2764,_2766,_2768))=true).
cyclic(contract(_2760,_2762,_2764)=false).
cyclic(suspended(_2760,_2762)=false).

cachingOrder2(_2994, quote(_2994,_2996,_2998)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2994,_2996),role_of(_2996,consumer),role_of(_2994,merchant),\+_2994=_2996,queryGoodsDescription(_2998).

cachingOrder2(_2994, quote(_2994,_2996,_2998)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2994,_2996),role_of(_2996,consumer),role_of(_2994,merchant),\+_2994=_2996,queryGoodsDescription(_2998).

cachingOrder2(_2948, per(present_quote(_2948,_2950))=false) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2948,_2950),role_of(_2948,merchant),role_of(_2950,consumer),\+_2950=_2948.

cachingOrder2(_2948, per(present_quote(_2948,_2950))=true) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2948,_2950),role_of(_2948,merchant),role_of(_2950,consumer),\+_2950=_2948.

cachingOrder2(_3724, obl(send_goods(_3724,_3960,_3728))=true) :- % level in dependency graph: 2, processing order in component: 1
     person(_3724),role_of(_3724,merchant),queryGoodsDescription(_3728).

cachingOrder2(_3748, obl(send_EPO(_3748,_4118,_3752))=true) :- % level in dependency graph: 2, processing order in component: 2
     person(_3748),role_of(_3748,consumer),queryGoodsDescription(_3752).

cachingOrder2(_3768, suspended(_3768,_3770)=true) :- % level in dependency graph: 2, processing order in component: 3
     person(_3768),role_of(_3768,_3770).

cachingOrder2(_3786, suspended(_3786,_3788)=false) :- % level in dependency graph: 2, processing order in component: 4
     person(_3786),role_of(_3786,_3788).

cachingOrder2(_3804, contract(_3804,_3806,_3808)=true) :- % level in dependency graph: 2, processing order in component: 5
     person_pair(_3804,_3806),role_of(_3804,merchant),role_of(_3806,consumer),\+_3804=_3806,queryGoodsDescription(_3808).

cachingOrder2(_3824, contract(_3824,_3826,_3828)=false) :- % level in dependency graph: 2, processing order in component: 6
     person_pair(_3824,_3826),role_of(_3824,merchant),role_of(_3826,consumer),\+_3824=_3826,queryGoodsDescription(_3828).

cachingOrder2(_4752, obl(send_EPO(_4752,_4888,_4756))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4752),role_of(_4752,consumer),queryGoodsDescription(_4756).

cachingOrder2(_4722, obl(send_goods(_4722,_5046,_4726))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4722),role_of(_4722,merchant),queryGoodsDescription(_4726).

collectGrounds([send_EPO(_2376,_2390,_2392,_2394), send_goods(_2376,_2390,_2392,_2394,_2396)],person(_2376)).

collectGrounds([present_quote(_2364,_2366,_2392,_2394), accept_quote(_2366,_2364,_2392), request_quote(_2366,_2364,_2392), pow(accept_quote(_2366,_2364,_2402))=true],person_pair(_2364,_2366)).

dgrounded(quote(_3230,_3232,_3234)=true, person_pair(_3230,_3232)).
dgrounded(contract(_3142,_3144,_3146)=true, person_pair(_3142,_3144)).
dgrounded(per(present_quote(_3066,_3068))=false, person_pair(_3066,_3068)).
dgrounded(per(present_quote(_2986,_2988))=true, person_pair(_2986,_2988)).
dgrounded(obl(send_EPO(_2924,iServer,_2928))=false, person(_2924)).
dgrounded(obl(send_goods(_2862,iServer,_2866))=false, person(_2862)).
dgrounded(suspended(_2812,_2814)=true, person(_2812)).
dgrounded(obl(send_EPO(_2754,iServer,_2758))=true, person(_2754)).
dgrounded(obl(send_goods(_2692,iServer,_2696))=true, person(_2692)).
dgrounded(quote(_2600,_2602,_2604)=false, person_pair(_2600,_2602)).
dgrounded(contract(_2512,_2514,_2516)=false, person_pair(_2512,_2514)).
dgrounded(suspended(_2466,_2468)=false, person(_2466)).
