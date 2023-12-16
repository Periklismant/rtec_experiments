:- dynamic person/1, person_pair/2.

initiatedAt(quote(_11382,_11384,_11386)=true, _11408, _11352, _11414) :-
     happensAtIE(present_quote(_11382,_11384,_11386,_11396),_11352),
     _11408=<_11352,
     _11352<_11414.

initiatedAt(contract(_11382,_11384,_11386)=true, _11444, _11352, _11450) :-
     happensAtIE(accept_quote(_11384,_11382,_11386),_11352),_11444=<_11352,_11352<_11450,
     updateVariableTemp(rule_evaluations,1),
     holdsAtProcessedSimpleFluent(_11382,quote(_11382,_11384,_11386)=true,_11352).

terminatedAt(quote(_11382,_11384,_11386)=true, _11406, _11352, _11412) :-
     happensAtIE(accept_quote(_11384,_11382,_11386),_11352),
     _11406=<_11352,
     _11352<_11412.

fi(quote(_11386,_11388,_11390)=true,quote(_11386,_11388,_11390)=false,15):-
     grounding(quote(_11386,_11388,_11390)=true),
     grounding(quote(_11386,_11388,_11390)=false).

fi(contract(_11386,_11388,_11390)=true,contract(_11386,_11388,_11390)=false,15):-
     grounding(contract(_11386,_11388,_11390)=true),
     grounding(contract(_11386,_11388,_11390)=false).

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

grounding(contract(_11660,_11662,_11664)=true) :- 
     person_pair(_11660,_11662),role_of(_11660,merchant),role_of(_11662,consumer),\+_11660=_11662,queryGoodsDescription(_11664).

grounding(contract(_11660,_11662,_11664)=false) :- 
     person_pair(_11660,_11662),role_of(_11660,merchant),role_of(_11662,consumer),\+_11660=_11662,queryGoodsDescription(_11664).

p(quote(_11654,_11656,_11658)=true).

inputEntity(present_quote(_11412,_11414,_11416,_11418)).
inputEntity(accept_quote(_11412,_11414,_11416)).
inputEntity(request_quote(_11412,_11414,_11416)).
inputEntity(send_EPO(_11412,_11414,_11416,_11418)).
inputEntity(send_goods(_11412,_11414,_11416,_11418,_11420)).

outputEntity(quote(_11510,_11512,_11514)=true).
outputEntity(contract(_11510,_11512,_11514)=true).
outputEntity(quote(_11510,_11512,_11514)=false).
outputEntity(contract(_11510,_11512,_11514)=false).

event(present_quote(_11590,_11592,_11594,_11596)).
event(accept_quote(_11590,_11592,_11594)).
event(request_quote(_11590,_11592,_11594)).
event(send_EPO(_11590,_11592,_11594,_11596)).
event(send_goods(_11590,_11592,_11594,_11596,_11598)).

simpleFluent(quote(_11688,_11690,_11692)=true).
simpleFluent(contract(_11688,_11690,_11692)=true).
simpleFluent(quote(_11688,_11690,_11692)=false).
simpleFluent(contract(_11688,_11690,_11692)=false).


index(present_quote(_11776,_11836,_11838,_11840),_11776).
index(accept_quote(_11776,_11836,_11838),_11776).
index(request_quote(_11776,_11836,_11838),_11776).
index(send_EPO(_11776,_11836,_11838,_11840),_11776).
index(send_goods(_11776,_11836,_11838,_11840,_11842),_11776).
index(quote(_11776,_11842,_11844)=true,_11776).
index(contract(_11776,_11842,_11844)=true,_11776).
index(quote(_11776,_11842,_11844)=false,_11776).
index(contract(_11776,_11842,_11844)=false,_11776).


cachingOrder2(_12082, quote(_12082,_12084,_12086)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_12082,_12084),role_of(_12084,consumer),role_of(_12082,merchant),\+_12082=_12084,queryGoodsDescription(_12086).

cachingOrder2(_12082, quote(_12082,_12084,_12086)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_12082,_12084),role_of(_12084,consumer),role_of(_12082,merchant),\+_12082=_12084,queryGoodsDescription(_12086).

cachingOrder2(_12490, contract(_12490,_12492,_12494)=true) :- % level in dependency graph: 2, processing order in component: 1
     person_pair(_12490,_12492),role_of(_12490,merchant),role_of(_12492,consumer),\+_12490=_12492,queryGoodsDescription(_12494).

cachingOrder2(_12490, contract(_12490,_12492,_12494)=false) :- % level in dependency graph: 2, processing order in component: 2
     person_pair(_12490,_12492),role_of(_12490,merchant),role_of(_12492,consumer),\+_12490=_12492,queryGoodsDescription(_12494).

collectGrounds([send_EPO(_11666,_11680,_11682,_11684), send_goods(_11666,_11680,_11682,_11684,_11686)],person(_11666)).

collectGrounds([present_quote(_11654,_11656,_11682,_11684), accept_quote(_11656,_11654,_11682), request_quote(_11656,_11654,_11682)],person_pair(_11654,_11656)).

dgrounded(quote(_12026,_12028,_12030)=true, person_pair(_12026,_12028)).
dgrounded(contract(_11938,_11940,_11942)=true, person_pair(_11938,_11940)).
dgrounded(quote(_11850,_11852,_11854)=false, person_pair(_11850,_11852)).
dgrounded(contract(_11762,_11764,_11766)=false, person_pair(_11762,_11764)).
