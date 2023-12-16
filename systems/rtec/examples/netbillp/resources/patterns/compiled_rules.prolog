:- dynamic person/1, person_pair/2.

initiatedAt(quote(_2006,_2008,_2010)=true, _2044, _1976, _2050) :-
     happensAtIE(present_quote(_2006,_2008,_2010,_2020),_1976),_2044=<_1976,_1976<_2050,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(contract(_2006,_2008,_2010)=true, _2118, _1976, _2124) :-
     happensAtIE(accept_quote(_2008,_2006,_2010),_1976),_2118=<_1976,_1976<_2124,
     holdsAtProcessedSimpleFluent(_2006,quote(_2006,_2008,_2010)=true,_1976),
     \+holdsAtCyclic(_2006,suspended(_2006,merchant)=true,_1976),
     \+holdsAtCyclic(_2008,suspended(_2008,consumer)=true,_1976).

initiatedAt(per(present_quote(_2010,_2012))=false, _2046, _1976, _2052) :-
     happensAtIE(present_quote(_2010,_2012,_2020,_2022),_1976),_2046=<_1976,_1976<_2052,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(per(present_quote(_2010,_2012))=true, _2044, _1976, _2050) :-
     happensAtIE(request_quote(_2012,_2010,_2020),_1976),_2044=<_1976,_1976<_2050,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(obl(send_EPO(_2010,iServer,_2014))=false, _2048, _1976, _2054) :-
     happensAtIE(send_EPO(_2010,iServer,_2014,_2024),_1976),_2048=<_1976,_1976<_2054,
     price(_2014,_2024).

initiatedAt(obl(send_goods(_2010,iServer,_2014))=false, _2064, _1976, _2070) :-
     happensAtIE(send_goods(_2010,iServer,_2014,_2024,_2026),_1976),_2064=<_1976,_1976<_2070,
     decrypt(_2024,_2026,_2040),
     meets(_2040,_2014).

initiatedAt(suspended(_2006,merchant)=true, _2076, _1976, _2082) :-
     happensAtIE(present_quote(_2006,_2014,_2016,_2018),_1976),_2076=<_1976,_1976<_2082,
     updateVariableTemp(rule_evaluations,1),
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
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_2014,obl(send_goods(_2014,iServer,_2030))=true,_1978).

initiatedAt(suspended(_2014,consumer)=true, _1976, _1978, _1980) :-
     initiatedAt(contract(_2026,_2014,_2030)=false,_1976,_1978,_1980),
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_2014,obl(send_EPO(_2014,iServer,_2030))=true,_1978).

terminatedAt(quote(_2006,_2008,_2010)=true, _2042, _1976, _2048) :-
     happensAtIE(accept_quote(_2008,_2006,_2010),_1976),_2042=<_1976,_1976<_2048,
     updateVariableTemp(rule_evaluations,1).

holdsForSDFluent(pow(accept_quote(_2010,_2012,_2014))=true,_1976) :-
     holdsForProcessedSimpleFluent(_2012,quote(_2012,_2010,_2014)=true,_2034),
     holdsForProcessedSimpleFluent(_2010,suspended(_2010,consumer)=true,_2052),
     holdsForProcessedSimpleFluent(_2012,suspended(_2012,merchant)=true,_2070),
     relative_complement_all(_2034,[_2052,_2070],_1976).

fi(quote(_2016,_2018,_2020)=true,quote(_2016,_2018,_2020)=false,_1978):-
     quote_deadline(_1978),
     grounding(quote(_2016,_2018,_2020)=true),
     grounding(quote(_2016,_2018,_2020)=false).

fi(contract(_2010,_2012,_2014)=true,contract(_2010,_2012,_2014)=false,10):-
     grounding(contract(_2010,_2012,_2014)=true),
     grounding(contract(_2010,_2012,_2014)=false).

fi(per(present_quote(_2014,_2016))=false,per(present_quote(_2014,_2016))=true,20):-
     grounding(per(present_quote(_2014,_2016))=false),
     grounding(per(present_quote(_2014,_2016))=true).

fi(suspended(_2010,_2012)=true,suspended(_2010,_2012)=false,6):-
     grounding(suspended(_2010,_2012)=true),
     grounding(suspended(_2010,_2012)=false).

grounding(request_quote(_2346,_2348,_2350)) :- 
     person_pair(_2348,_2346).

grounding(present_quote(_2346,_2348,_2350,_2352)) :- 
     person_pair(_2346,_2348).

grounding(accept_quote(_2346,_2348,_2350)) :- 
     person_pair(_2348,_2346).

grounding(send_EPO(_2346,_2348,_2350,_2352)) :- 
     person(_2346).

grounding(send_goods(_2346,_2348,_2350,_2352,_2354)) :- 
     person(_2346).

grounding(suspended(_2352,_2354)=true) :- 
     person(_2352),role_of(_2352,_2354).

grounding(suspended(_2352,_2354)=false) :- 
     person(_2352),role_of(_2352,_2354).

grounding(quote(_2352,_2354,_2356)=true) :- 
     person_pair(_2352,_2354),role_of(_2354,consumer),role_of(_2352,merchant),\+_2352=_2354,queryGoodsDescription(_2356).

grounding(quote(_2352,_2354,_2356)=false) :- 
     person_pair(_2352,_2354),role_of(_2354,consumer),role_of(_2352,merchant),\+_2352=_2354,queryGoodsDescription(_2356).

grounding(contract(_2352,_2354,_2356)=true) :- 
     person_pair(_2352,_2354),role_of(_2352,merchant),role_of(_2354,consumer),\+_2352=_2354,queryGoodsDescription(_2356).

grounding(contract(_2352,_2354,_2356)=false) :- 
     person_pair(_2352,_2354),role_of(_2352,merchant),role_of(_2354,consumer),\+_2352=_2354,queryGoodsDescription(_2356).

grounding(pow(accept_quote(_2356,_2358,_2360))=true) :- 
     person_pair(_2358,_2356),role_of(_2358,merchant),role_of(_2356,consumer),\+_2356=_2358,queryGoodsDescription(_2360).

grounding(per(present_quote(_2356,_2358))=false) :- 
     person_pair(_2356,_2358),role_of(_2356,merchant),role_of(_2358,consumer),\+_2358=_2356.

grounding(per(present_quote(_2356,_2358))=true) :- 
     person_pair(_2356,_2358),role_of(_2356,merchant),role_of(_2358,consumer),\+_2358=_2356.

grounding(obl(send_EPO(_2356,iServer,_2360))=true) :- 
     person(_2356),role_of(_2356,consumer),queryGoodsDescription(_2360).

grounding(obl(send_goods(_2356,iServer,_2360))=true) :- 
     person(_2356),role_of(_2356,merchant),queryGoodsDescription(_2360).

grounding(obl(send_EPO(_2356,iServer,_2360))=false) :- 
     person(_2356),role_of(_2356,consumer),queryGoodsDescription(_2360).

grounding(obl(send_goods(_2356,iServer,_2360))=false) :- 
     person(_2356),role_of(_2356,merchant),queryGoodsDescription(_2360).

p(quote(_2346,_2348,_2350)=true).

p(per(present_quote(_2350,_2352))=false).

p(suspended(_2346,_2348)=true).

inputEntity(present_quote(_2030,_2032,_2034,_2036)).
inputEntity(accept_quote(_2030,_2032,_2034)).
inputEntity(request_quote(_2030,_2032,_2034)).
inputEntity(send_EPO(_2030,_2032,_2034,_2036)).
inputEntity(send_goods(_2030,_2032,_2034,_2036,_2038)).

outputEntity(quote(_2122,_2124,_2126)=true).
outputEntity(contract(_2122,_2124,_2126)=true).
outputEntity(per(present_quote(_2126,_2128))=false).
outputEntity(per(present_quote(_2126,_2128))=true).
outputEntity(obl(send_EPO(_2126,_2128,_2130))=false).
outputEntity(obl(send_goods(_2126,_2128,_2130))=false).
outputEntity(suspended(_2122,_2124)=true).
outputEntity(obl(send_EPO(_2126,_2128,_2130))=true).
outputEntity(obl(send_goods(_2126,_2128,_2130))=true).
outputEntity(quote(_2122,_2124,_2126)=false).
outputEntity(contract(_2122,_2124,_2126)=false).
outputEntity(suspended(_2122,_2124)=false).
outputEntity(pow(accept_quote(_2126,_2128,_2130))=true).

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

cachingOrder2(_4782, obl(send_EPO(_4782,_4918,_4786))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4782),role_of(_4782,consumer),queryGoodsDescription(_4786).

cachingOrder2(_4752, obl(send_goods(_4752,_5076,_4756))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4752),role_of(_4752,merchant),queryGoodsDescription(_4756).

cachingOrder2(_4722, pow(accept_quote(_4722,_4724,_4726))=true) :- % level in dependency graph: 3, processing order in component: 1
     person_pair(_4724,_4722),role_of(_4724,merchant),role_of(_4722,consumer),\+_4722=_4724,queryGoodsDescription(_4726).

collectGrounds([send_EPO(_2278,_2292,_2294,_2296), send_goods(_2278,_2292,_2294,_2296,_2298)],person(_2278)).

collectGrounds([present_quote(_2266,_2268,_2294,_2296), accept_quote(_2268,_2266,_2294), request_quote(_2268,_2266,_2294)],person_pair(_2266,_2268)).

dgrounded(quote(_3224,_3226,_3228)=true, person_pair(_3224,_3226)).
dgrounded(contract(_3136,_3138,_3140)=true, person_pair(_3136,_3138)).
dgrounded(per(present_quote(_3060,_3062))=false, person_pair(_3060,_3062)).
dgrounded(per(present_quote(_2980,_2982))=true, person_pair(_2980,_2982)).
dgrounded(obl(send_EPO(_2918,iServer,_2922))=false, person(_2918)).
dgrounded(obl(send_goods(_2856,iServer,_2860))=false, person(_2856)).
dgrounded(suspended(_2806,_2808)=true, person(_2806)).
dgrounded(obl(send_EPO(_2748,iServer,_2752))=true, person(_2748)).
dgrounded(obl(send_goods(_2686,iServer,_2690))=true, person(_2686)).
dgrounded(quote(_2594,_2596,_2598)=false, person_pair(_2594,_2596)).
dgrounded(contract(_2506,_2508,_2510)=false, person_pair(_2506,_2508)).
dgrounded(suspended(_2460,_2462)=false, person(_2460)).
dgrounded(pow(accept_quote(_2372,_2374,_2376))=true, person_pair(_2374,_2372)).
