:- dynamic person/1, person_pair/2.

initiatedAt(quote(_2002,_2004,_2006)=true, _2040, _1972, _2046) :-
     happensAtIE(present_quote(_2002,_2004,_2006,_2016),_1972),_2040=<_1972,_1972<_2046,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(contract(_2002,_2004,_2006)=true, _2114, _1972, _2120) :-
     happensAtIE(accept_quote(_2004,_2002,_2006),_1972),_2114=<_1972,_1972<_2120,
     holdsAtProcessedSimpleFluent(_2002,quote(_2002,_2004,_2006)=true,_1972),
     \+holdsAtCyclic(_2002,suspended(_2002,merchant)=true,_1972),
     \+holdsAtCyclic(_2004,suspended(_2004,consumer)=true,_1972).

initiatedAt(per(present_quote(_2006,_2008))=false, _2042, _1972, _2048) :-
     happensAtIE(present_quote(_2006,_2008,_2016,_2018),_1972),_2042=<_1972,_1972<_2048,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(per(present_quote(_2006,_2008))=true, _2040, _1972, _2046) :-
     happensAtIE(request_quote(_2008,_2006,_2016),_1972),_2040=<_1972,_1972<_2046,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(obl(send_EPO(_2006,iServer,_2010))=false, _2044, _1972, _2050) :-
     happensAtIE(send_EPO(_2006,iServer,_2010,_2020),_1972),_2044=<_1972,_1972<_2050,
     price(_2010,_2020).

initiatedAt(obl(send_goods(_2006,iServer,_2010))=false, _2060, _1972, _2066) :-
     happensAtIE(send_goods(_2006,iServer,_2010,_2020,_2022),_1972),_2060=<_1972,_1972<_2066,
     decrypt(_2020,_2022,_2036),
     meets(_2036,_2010).

initiatedAt(suspended(_2002,merchant)=true, _2072, _1972, _2078) :-
     happensAtIE(present_quote(_2002,_2010,_2012,_2014),_1972),_2072=<_1972,_1972<_2078,
     updateVariableTemp(rule_evaluations,1),
     holdsAtProcessedSimpleFluent(_2002,per(present_quote(_2002,_2010))=false,_1972).

initiatedAt(obl(send_EPO(_2014,iServer,_2018))=true, _1972, _1974, _1976) :-
     initiatedAt(contract(_2028,_2014,_2018)=true,_1972,_1974,_1976).

initiatedAt(obl(send_goods(_2014,iServer,_2018))=true, _1972, _1974, _1976) :-
     initiatedAt(contract(_2014,_2030,_2018)=true,_1972,_1974,_1976).

initiatedAt(obl(send_EPO(_2014,iServer,_2018))=false, _1972, _1974, _1976) :-
     initiatedAt(contract(_2028,_2014,_2018)=false,_1972,_1974,_1976).

initiatedAt(obl(send_goods(_2014,iServer,_2018))=false, _1972, _1974, _1976) :-
     initiatedAt(contract(_2014,_2030,_2018)=false,_1972,_1974,_1976).

initiatedAt(suspended(_2010,merchant)=true, _1972, _1974, _1976) :-
     initiatedAt(contract(_2010,_2024,_2026)=false,_1972,_1974,_1976),
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_2010,obl(send_goods(_2010,iServer,_2026))=true,_1974).

initiatedAt(suspended(_2010,consumer)=true, _1972, _1974, _1976) :-
     initiatedAt(contract(_2022,_2010,_2026)=false,_1972,_1974,_1976),
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_2010,obl(send_EPO(_2010,iServer,_2026))=true,_1974).

terminatedAt(quote(_2002,_2004,_2006)=true, _2038, _1972, _2044) :-
     happensAtIE(accept_quote(_2004,_2002,_2006),_1972),_2038=<_1972,_1972<_2044,
     updateVariableTemp(rule_evaluations,1).

holdsForSDFluent(pow(accept_quote(_2006,_2008,_2010))=true,_1972) :-
     holdsForProcessedSimpleFluent(_2008,quote(_2008,_2006,_2010)=true,_2030),
     holdsForProcessedSimpleFluent(_2006,suspended(_2006,consumer)=true,_2048),
     holdsForProcessedSimpleFluent(_2008,suspended(_2008,merchant)=true,_2066),
     relative_complement_all(_2030,[_2048,_2066],_1972).

fi(quote(_2012,_2014,_2016)=true,quote(_2012,_2014,_2016)=false,_1974):-
     quote_deadline(_1974),
     grounding(quote(_2012,_2014,_2016)=true),
     grounding(quote(_2012,_2014,_2016)=false).

fi(contract(_2006,_2008,_2010)=true,contract(_2006,_2008,_2010)=false,10):-
     grounding(contract(_2006,_2008,_2010)=true),
     grounding(contract(_2006,_2008,_2010)=false).

fi(per(present_quote(_2010,_2012))=false,per(present_quote(_2010,_2012))=true,20):-
     grounding(per(present_quote(_2010,_2012))=false),
     grounding(per(present_quote(_2010,_2012))=true).

fi(suspended(_2006,_2008)=true,suspended(_2006,_2008)=false,6):-
     grounding(suspended(_2006,_2008)=true),
     grounding(suspended(_2006,_2008)=false).

grounding(request_quote(_2342,_2344,_2346)) :- 
     person_pair(_2344,_2342).

grounding(present_quote(_2342,_2344,_2346,_2348)) :- 
     person_pair(_2342,_2344).

grounding(accept_quote(_2342,_2344,_2346)) :- 
     person_pair(_2344,_2342).

grounding(send_EPO(_2342,_2344,_2346,_2348)) :- 
     person(_2342).

grounding(send_goods(_2342,_2344,_2346,_2348,_2350)) :- 
     person(_2342).

grounding(suspended(_2348,_2350)=true) :- 
     person(_2348),role_of(_2348,_2350).

grounding(suspended(_2348,_2350)=false) :- 
     person(_2348),role_of(_2348,_2350).

grounding(quote(_2348,_2350,_2352)=true) :- 
     person_pair(_2348,_2350),role_of(_2350,consumer),role_of(_2348,merchant),\+_2348=_2350,queryGoodsDescription(_2352).

grounding(quote(_2348,_2350,_2352)=false) :- 
     person_pair(_2348,_2350),role_of(_2350,consumer),role_of(_2348,merchant),\+_2348=_2350,queryGoodsDescription(_2352).

grounding(contract(_2348,_2350,_2352)=true) :- 
     person_pair(_2348,_2350),role_of(_2348,merchant),role_of(_2350,consumer),\+_2348=_2350,queryGoodsDescription(_2352).

grounding(contract(_2348,_2350,_2352)=false) :- 
     person_pair(_2348,_2350),role_of(_2348,merchant),role_of(_2350,consumer),\+_2348=_2350,queryGoodsDescription(_2352).

grounding(pow(accept_quote(_2352,_2354,_2356))=true) :- 
     person_pair(_2354,_2352),role_of(_2354,merchant),role_of(_2352,consumer),\+_2352=_2354,queryGoodsDescription(_2356).

grounding(per(present_quote(_2352,_2354))=false) :- 
     person_pair(_2352,_2354),role_of(_2352,merchant),role_of(_2354,consumer),\+_2354=_2352.

grounding(per(present_quote(_2352,_2354))=true) :- 
     person_pair(_2352,_2354),role_of(_2352,merchant),role_of(_2354,consumer),\+_2354=_2352.

grounding(obl(send_EPO(_2352,iServer,_2356))=true) :- 
     person(_2352),role_of(_2352,consumer),queryGoodsDescription(_2356).

grounding(obl(send_goods(_2352,iServer,_2356))=true) :- 
     person(_2352),role_of(_2352,merchant),queryGoodsDescription(_2356).

grounding(obl(send_EPO(_2352,iServer,_2356))=false) :- 
     person(_2352),role_of(_2352,consumer),queryGoodsDescription(_2356).

grounding(obl(send_goods(_2352,iServer,_2356))=false) :- 
     person(_2352),role_of(_2352,merchant),queryGoodsDescription(_2356).

p(quote(_2342,_2344,_2346)=true).

p(per(present_quote(_2346,_2348))=false).

p(suspended(_2342,_2344)=true).

inputEntity(present_quote(_2026,_2028,_2030,_2032)).
inputEntity(accept_quote(_2026,_2028,_2030)).
inputEntity(request_quote(_2026,_2028,_2030)).
inputEntity(send_EPO(_2026,_2028,_2030,_2032)).
inputEntity(send_goods(_2026,_2028,_2030,_2032,_2034)).

outputEntity(quote(_2118,_2120,_2122)=true).
outputEntity(contract(_2118,_2120,_2122)=true).
outputEntity(per(present_quote(_2122,_2124))=false).
outputEntity(per(present_quote(_2122,_2124))=true).
outputEntity(obl(send_EPO(_2122,_2124,_2126))=false).
outputEntity(obl(send_goods(_2122,_2124,_2126))=false).
outputEntity(suspended(_2118,_2120)=true).
outputEntity(obl(send_EPO(_2122,_2124,_2126))=true).
outputEntity(obl(send_goods(_2122,_2124,_2126))=true).
outputEntity(quote(_2118,_2120,_2122)=false).
outputEntity(contract(_2118,_2120,_2122)=false).
outputEntity(suspended(_2118,_2120)=false).
outputEntity(pow(accept_quote(_2122,_2124,_2126))=true).

event(present_quote(_2246,_2248,_2250,_2252)).
event(accept_quote(_2246,_2248,_2250)).
event(request_quote(_2246,_2248,_2250)).
event(send_EPO(_2246,_2248,_2250,_2252)).
event(send_goods(_2246,_2248,_2250,_2252,_2254)).

simpleFluent(quote(_2338,_2340,_2342)=true).
simpleFluent(contract(_2338,_2340,_2342)=true).
simpleFluent(per(present_quote(_2342,_2344))=false).
simpleFluent(per(present_quote(_2342,_2344))=true).
simpleFluent(obl(send_EPO(_2342,_2344,_2346))=false).
simpleFluent(obl(send_goods(_2342,_2344,_2346))=false).
simpleFluent(suspended(_2338,_2340)=true).
simpleFluent(obl(send_EPO(_2342,_2344,_2346))=true).
simpleFluent(obl(send_goods(_2342,_2344,_2346))=true).
simpleFluent(quote(_2338,_2340,_2342)=false).
simpleFluent(contract(_2338,_2340,_2342)=false).
simpleFluent(suspended(_2338,_2340)=false).

sDFluent(pow(accept_quote(_2470,_2472,_2474))=true).

index(present_quote(_2474,_2528,_2530,_2532),_2474).
index(accept_quote(_2474,_2528,_2530),_2474).
index(request_quote(_2474,_2528,_2530),_2474).
index(send_EPO(_2474,_2528,_2530,_2532),_2474).
index(send_goods(_2474,_2528,_2530,_2532,_2534),_2474).
index(quote(_2474,_2534,_2536)=true,_2474).
index(contract(_2474,_2534,_2536)=true,_2474).
index(per(present_quote(_2474,_2538))=false,_2474).
index(per(present_quote(_2474,_2538))=true,_2474).
index(obl(send_EPO(_2474,_2538,_2540))=false,_2474).
index(obl(send_goods(_2474,_2538,_2540))=false,_2474).
index(suspended(_2474,_2534)=true,_2474).
index(obl(send_EPO(_2474,_2538,_2540))=true,_2474).
index(obl(send_goods(_2474,_2538,_2540))=true,_2474).
index(quote(_2474,_2534,_2536)=false,_2474).
index(contract(_2474,_2534,_2536)=false,_2474).
index(suspended(_2474,_2534)=false,_2474).
index(pow(accept_quote(_2474,_2538,_2540))=true,_2474).

cyclic(contract(_2756,_2758,_2760)=true).
cyclic(suspended(_2756,_2758)=true).
cyclic(obl(send_EPO(_2760,_2762,_2764))=true).
cyclic(obl(send_goods(_2760,_2762,_2764))=true).
cyclic(contract(_2756,_2758,_2760)=false).
cyclic(suspended(_2756,_2758)=false).

cachingOrder2(_2990, quote(_2990,_2992,_2994)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2990,_2992),role_of(_2992,consumer),role_of(_2990,merchant),\+_2990=_2992,queryGoodsDescription(_2994).

cachingOrder2(_2990, quote(_2990,_2992,_2994)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2990,_2992),role_of(_2992,consumer),role_of(_2990,merchant),\+_2990=_2992,queryGoodsDescription(_2994).

cachingOrder2(_2944, per(present_quote(_2944,_2946))=false) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_2944,_2946),role_of(_2944,merchant),role_of(_2946,consumer),\+_2946=_2944.

cachingOrder2(_2944, per(present_quote(_2944,_2946))=true) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_2944,_2946),role_of(_2944,merchant),role_of(_2946,consumer),\+_2946=_2944.

cachingOrder2(_3720, obl(send_goods(_3720,_3956,_3724))=true) :- % level in dependency graph: 2, processing order in component: 1
     person(_3720),role_of(_3720,merchant),queryGoodsDescription(_3724).

cachingOrder2(_3744, obl(send_EPO(_3744,_4114,_3748))=true) :- % level in dependency graph: 2, processing order in component: 2
     person(_3744),role_of(_3744,consumer),queryGoodsDescription(_3748).

cachingOrder2(_3764, suspended(_3764,_3766)=true) :- % level in dependency graph: 2, processing order in component: 3
     person(_3764),role_of(_3764,_3766).

cachingOrder2(_3782, suspended(_3782,_3784)=false) :- % level in dependency graph: 2, processing order in component: 4
     person(_3782),role_of(_3782,_3784).

cachingOrder2(_3800, contract(_3800,_3802,_3804)=true) :- % level in dependency graph: 2, processing order in component: 5
     person_pair(_3800,_3802),role_of(_3800,merchant),role_of(_3802,consumer),\+_3800=_3802,queryGoodsDescription(_3804).

cachingOrder2(_3820, contract(_3820,_3822,_3824)=false) :- % level in dependency graph: 2, processing order in component: 6
     person_pair(_3820,_3822),role_of(_3820,merchant),role_of(_3822,consumer),\+_3820=_3822,queryGoodsDescription(_3824).

cachingOrder2(_4778, obl(send_EPO(_4778,_4914,_4782))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4778),role_of(_4778,consumer),queryGoodsDescription(_4782).

cachingOrder2(_4748, obl(send_goods(_4748,_5072,_4752))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_4748),role_of(_4748,merchant),queryGoodsDescription(_4752).

cachingOrder2(_4718, pow(accept_quote(_4718,_4720,_4722))=true) :- % level in dependency graph: 3, processing order in component: 1
     person_pair(_4720,_4718),role_of(_4720,merchant),role_of(_4718,consumer),\+_4718=_4720,queryGoodsDescription(_4722).

collectGrounds([send_EPO(_2274,_2288,_2290,_2292), send_goods(_2274,_2288,_2290,_2292,_2294)],person(_2274)).

collectGrounds([present_quote(_2262,_2264,_2290,_2292), accept_quote(_2264,_2262,_2290), request_quote(_2264,_2262,_2290)],person_pair(_2262,_2264)).

dgrounded(quote(_3220,_3222,_3224)=true, person_pair(_3220,_3222)).
dgrounded(contract(_3132,_3134,_3136)=true, person_pair(_3132,_3134)).
dgrounded(per(present_quote(_3056,_3058))=false, person_pair(_3056,_3058)).
dgrounded(per(present_quote(_2976,_2978))=true, person_pair(_2976,_2978)).
dgrounded(obl(send_EPO(_2914,iServer,_2918))=false, person(_2914)).
dgrounded(obl(send_goods(_2852,iServer,_2856))=false, person(_2852)).
dgrounded(suspended(_2802,_2804)=true, person(_2802)).
dgrounded(obl(send_EPO(_2744,iServer,_2748))=true, person(_2744)).
dgrounded(obl(send_goods(_2682,iServer,_2686))=true, person(_2682)).
dgrounded(quote(_2590,_2592,_2594)=false, person_pair(_2590,_2592)).
dgrounded(contract(_2502,_2504,_2506)=false, person_pair(_2502,_2504)).
dgrounded(suspended(_2456,_2458)=false, person(_2456)).
dgrounded(pow(accept_quote(_2368,_2370,_2372))=true, person_pair(_2370,_2368)).
