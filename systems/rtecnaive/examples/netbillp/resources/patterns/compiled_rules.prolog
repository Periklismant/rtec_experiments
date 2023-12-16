:- dynamic person/1, person_pair/2.

initiatedAt(quote(_11382,_11384,_11386)=true, _11420, _11352, _11426) :-
     happensAtIE(present_quote(_11382,_11384,_11386,_11396),_11352),_11420=<_11352,_11352<_11426,
     updateVariableTemp(rule_evaluations,1).

terminatedAt(quote(_11382,_11384,_11386)=true, _11418, _11352, _11424) :-
     happensAtIE(accept_quote(_11384,_11382,_11386),_11352),_11418=<_11352,_11352<_11424,
     updateVariableTemp(rule_evaluations,1).

fi(quote(_11386,_11388,_11390)=true,quote(_11386,_11388,_11390)=false,5):-
     grounding(quote(_11386,_11388,_11390)=true),
     grounding(quote(_11386,_11388,_11390)=false).

grounding(request_quote(_11654,_11656,_11658)) :- 
     person_pair(_11656,_11654).

grounding(present_quote(_11654,_11656,_11658,_11660)) :- 
     person_pair(_11654,_11656).

grounding(accept_quote(_11654,_11656,_11658)) :- 
     person_pair(_11656,_11654).

grounding(send_EPO(_11654,_11656,_11658,_11660)) :- 
     person(_11654).

grounding(send_goods(_11654,_11656,_11658,_11660,_11662)) :- 
     person(_11654).

grounding(quote(_11660,_11662,_11664)=true) :- 
     person_pair(_11660,_11662),role_of(_11662,consumer),role_of(_11660,merchant),\+_11660=_11662,queryGoodsDescription(_11664).

grounding(quote(_11660,_11662,_11664)=false) :- 
     person_pair(_11660,_11662),role_of(_11662,consumer),role_of(_11660,merchant),\+_11660=_11662,queryGoodsDescription(_11664).

p(quote(_11654,_11656,_11658)=true).

inputEntity(present_quote(_11412,_11414,_11416,_11418)).
inputEntity(accept_quote(_11412,_11414,_11416)).
inputEntity(request_quote(_11412,_11414,_11416)).
inputEntity(send_EPO(_11412,_11414,_11416,_11418)).
inputEntity(send_goods(_11412,_11414,_11416,_11418,_11420)).

outputEntity(quote(_11510,_11512,_11514)=true).
outputEntity(quote(_11510,_11512,_11514)=false).

event(present_quote(_11578,_11580,_11582,_11584)).
event(accept_quote(_11578,_11580,_11582)).
event(request_quote(_11578,_11580,_11582)).
event(send_EPO(_11578,_11580,_11582,_11584)).
event(send_goods(_11578,_11580,_11582,_11584,_11586)).

simpleFluent(quote(_11676,_11678,_11680)=true).
simpleFluent(quote(_11676,_11678,_11680)=false).


index(present_quote(_11752,_11812,_11814,_11816),_11752).
index(accept_quote(_11752,_11812,_11814),_11752).
index(request_quote(_11752,_11812,_11814),_11752).
index(send_EPO(_11752,_11812,_11814,_11816),_11752).
index(send_goods(_11752,_11812,_11814,_11816,_11818),_11752).
index(quote(_11752,_11818,_11820)=true,_11752).
index(quote(_11752,_11818,_11820)=false,_11752).


cachingOrder2(_12046, quote(_12046,_12048,_12050)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_12046,_12048),role_of(_12048,consumer),role_of(_12046,merchant),\+_12046=_12048,queryGoodsDescription(_12050).

cachingOrder2(_12046, quote(_12046,_12048,_12050)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_12046,_12048),role_of(_12048,consumer),role_of(_12046,merchant),\+_12046=_12048,queryGoodsDescription(_12050).

collectGrounds([send_EPO(_11666,_11680,_11682,_11684), send_goods(_11666,_11680,_11682,_11684,_11686)],person(_11666)).

collectGrounds([present_quote(_11654,_11656,_11682,_11684), accept_quote(_11656,_11654,_11682), request_quote(_11656,_11654,_11682)],person_pair(_11654,_11656)).

dgrounded(quote(_11850,_11852,_11854)=true, person_pair(_11850,_11852)).
dgrounded(quote(_11762,_11764,_11766)=false, person_pair(_11762,_11764)).
