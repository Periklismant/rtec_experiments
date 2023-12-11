:- dynamic person/1, person_pair/2.

initiatedAt(quote(_110,_112,_114)=true, _136, _80, _142) :-
     happensAtIE(present_quote(_110,_112,_114,_124),_80),
     _136=<_80,
     _80<_142.

initiatedAt(contract(_110,_112,_114)=true, _234, _80, _240) :-
     happensAtIE(accept_quote(_112,_110,_114),_80),_234=<_80,_80<_240,
     holdsAtProcessedSimpleFluent(_110,quote(_110,_112,_114)=true,_80),
     \+holdsAtCyclic(_110,suspended(_110,merchant)=true,_80),
     \+holdsAtCyclic(_112,suspended(_112,consumer)=true,_80),
     updateVariableTemp(rule_evaluations,1).

initiatedAt(per(present_quote(_114,_116))=false, _138, _80, _144) :-
     happensAtIE(present_quote(_114,_116,_124,_126),_80),
     _138=<_80,
     _80<_144.

initiatedAt(per(present_quote(_114,_116))=true, _136, _80, _142) :-
     happensAtIE(request_quote(_116,_114,_124),_80),
     _136=<_80,
     _80<_142.

initiatedAt(obl(send_EPO(_114,iServer,_118))=false, _152, _80, _158) :-
     happensAtIE(send_EPO(_114,iServer,_118,_128),_80),_152=<_80,_80<_158,
     price(_118,_128).

initiatedAt(obl(send_goods(_114,iServer,_118))=false, _168, _80, _174) :-
     happensAtIE(send_goods(_114,iServer,_118,_128,_130),_80),_168=<_80,_80<_174,
     decrypt(_128,_130,_144),
     meets(_144,_118).

initiatedAt(suspended(_110,merchant)=true, _168, _80, _174) :-
     happensAtIE(present_quote(_110,_118,_120,_122),_80),_168=<_80,_80<_174,
     holdsAtProcessedSimpleFluent(_110,per(present_quote(_110,_118))=false,_80).

initiatedAt(obl(send_EPO(_122,iServer,_126))=true, _80, _82, _84) :-
     initiatedAt(contract(_136,_122,_126)=true,_80,_82,_84).

initiatedAt(obl(send_goods(_122,iServer,_126))=true, _80, _82, _84) :-
     initiatedAt(contract(_122,_138,_126)=true,_80,_82,_84).

initiatedAt(obl(send_EPO(_122,iServer,_126))=false, _80, _82, _84) :-
     initiatedAt(contract(_136,_122,_126)=false,_80,_82,_84).

initiatedAt(obl(send_goods(_122,iServer,_126))=false, _80, _82, _84) :-
     initiatedAt(contract(_122,_138,_126)=false,_80,_82,_84).

initiatedAt(suspended(_118,merchant)=true, _80, _82, _84) :-
     initiatedAt(contract(_118,_132,_134)=false,_80,_82,_84),
     holdsAtCyclic(_118,obl(send_goods(_118,iServer,_134))=true,_82).

initiatedAt(suspended(_118,consumer)=true, _80, _82, _84) :-
     initiatedAt(contract(_130,_118,_134)=false,_80,_82,_84),
     holdsAtCyclic(_118,obl(send_EPO(_118,iServer,_134))=true,_82).

terminatedAt(quote(_110,_112,_114)=true, _134, _80, _140) :-
     happensAtIE(accept_quote(_112,_110,_114),_80),
     _134=<_80,
     _80<_140.

fi(quote(_114,_116,_118)=true,quote(_114,_116,_118)=false,5):-
     grounding(quote(_114,_116,_118)=true),
     grounding(quote(_114,_116,_118)=false).

fi(contract(_114,_116,_118)=true,contract(_114,_116,_118)=false,5):-
     grounding(contract(_114,_116,_118)=true),
     grounding(contract(_114,_116,_118)=false).

fi(per(present_quote(_118,_120))=false,per(present_quote(_118,_120))=true,10):-
     grounding(per(present_quote(_118,_120))=false),
     grounding(per(present_quote(_118,_120))=true).

fi(suspended(_114,_116)=true,suspended(_114,_116)=false,3):-
     grounding(suspended(_114,_116)=true),
     grounding(suspended(_114,_116)=false).

grounding(request_quote(_404,_406,_408)) :- 
     person_pair(_406,_404).

grounding(present_quote(_404,_406,_408,_410)) :- 
     person_pair(_404,_406).

grounding(accept_quote(_404,_406,_408)) :- 
     person_pair(_406,_404).

grounding(send_EPO(_404,_406,_408,_410)) :- 
     person(_404).

grounding(send_goods(_404,_406,_408,_410,_412)) :- 
     person(_404).

grounding(suspended(_410,_412)=true) :- 
     person(_410),role_of(_410,_412).

grounding(suspended(_410,_412)=false) :- 
     person(_410),role_of(_410,_412).

grounding(quote(_410,_412,_414)=true) :- 
     person_pair(_410,_412),role_of(_412,consumer),role_of(_410,merchant),\+_410=_412,queryGoodsDescription(_414).

grounding(quote(_410,_412,_414)=false) :- 
     person_pair(_410,_412),role_of(_412,consumer),role_of(_410,merchant),\+_410=_412,queryGoodsDescription(_414).

grounding(contract(_410,_412,_414)=true) :- 
     person_pair(_410,_412),role_of(_410,merchant),role_of(_412,consumer),\+_410=_412,queryGoodsDescription(_414).

grounding(contract(_410,_412,_414)=false) :- 
     person_pair(_410,_412),role_of(_410,merchant),role_of(_412,consumer),\+_410=_412,queryGoodsDescription(_414).

grounding(pow(accept_quote(_414,_416,_418))=true) :- 
     person_pair(_416,_414),role_of(_416,merchant),role_of(_414,consumer),\+_414=_416,queryGoodsDescription(_418).

grounding(per(present_quote(_414,_416))=false) :- 
     person_pair(_414,_416),role_of(_414,merchant),role_of(_416,consumer),\+_416=_414.

grounding(per(present_quote(_414,_416))=true) :- 
     person_pair(_414,_416),role_of(_414,merchant),role_of(_416,consumer),\+_416=_414.

grounding(obl(send_EPO(_414,iServer,_418))=true) :- 
     person(_414),role_of(_414,consumer),queryGoodsDescription(_418).

grounding(obl(send_goods(_414,iServer,_418))=true) :- 
     person(_414),role_of(_414,merchant),queryGoodsDescription(_418).

grounding(obl(send_EPO(_414,iServer,_418))=false) :- 
     person(_414),role_of(_414,consumer),queryGoodsDescription(_418).

grounding(obl(send_goods(_414,iServer,_418))=false) :- 
     person(_414),role_of(_414,merchant),queryGoodsDescription(_418).

p(quote(_404,_406,_408)=true).

p(per(present_quote(_408,_410))=false).

p(suspended(_404,_406)=true).

inputEntity(present_quote(_140,_142,_144,_146)).
inputEntity(accept_quote(_140,_142,_144)).
inputEntity(request_quote(_140,_142,_144)).
inputEntity(send_EPO(_140,_142,_144,_146)).
inputEntity(send_goods(_140,_142,_144,_146,_148)).
inputEntity(pow(accept_quote(_150,_152,_154))=true).

outputEntity(quote(_244,_246,_248)=true).
outputEntity(contract(_244,_246,_248)=true).
outputEntity(per(present_quote(_248,_250))=false).
outputEntity(per(present_quote(_248,_250))=true).
outputEntity(obl(send_EPO(_248,_250,_252))=false).
outputEntity(obl(send_goods(_248,_250,_252))=false).
outputEntity(suspended(_244,_246)=true).
outputEntity(obl(send_EPO(_248,_250,_252))=true).
outputEntity(obl(send_goods(_248,_250,_252))=true).
outputEntity(quote(_244,_246,_248)=false).
outputEntity(contract(_244,_246,_248)=false).
outputEntity(suspended(_244,_246)=false).

event(present_quote(_372,_374,_376,_378)).
event(accept_quote(_372,_374,_376)).
event(request_quote(_372,_374,_376)).
event(send_EPO(_372,_374,_376,_378)).
event(send_goods(_372,_374,_376,_378,_380)).

simpleFluent(quote(_470,_472,_474)=true).
simpleFluent(contract(_470,_472,_474)=true).
simpleFluent(per(present_quote(_474,_476))=false).
simpleFluent(per(present_quote(_474,_476))=true).
simpleFluent(obl(send_EPO(_474,_476,_478))=false).
simpleFluent(obl(send_goods(_474,_476,_478))=false).
simpleFluent(suspended(_470,_472)=true).
simpleFluent(obl(send_EPO(_474,_476,_478))=true).
simpleFluent(obl(send_goods(_474,_476,_478))=true).
simpleFluent(quote(_470,_472,_474)=false).
simpleFluent(contract(_470,_472,_474)=false).
simpleFluent(suspended(_470,_472)=false).

sDFluent(pow(accept_quote(_608,_610,_612))=true).

index(present_quote(_612,_672,_674,_676),_612).
index(accept_quote(_612,_672,_674),_612).
index(request_quote(_612,_672,_674),_612).
index(send_EPO(_612,_672,_674,_676),_612).
index(send_goods(_612,_672,_674,_676,_678),_612).
index(quote(_612,_678,_680)=true,_612).
index(contract(_612,_678,_680)=true,_612).
index(per(present_quote(_612,_682))=false,_612).
index(per(present_quote(_612,_682))=true,_612).
index(obl(send_EPO(_612,_682,_684))=false,_612).
index(obl(send_goods(_612,_682,_684))=false,_612).
index(suspended(_612,_678)=true,_612).
index(obl(send_EPO(_612,_682,_684))=true,_612).
index(obl(send_goods(_612,_682,_684))=true,_612).
index(quote(_612,_678,_680)=false,_612).
index(contract(_612,_678,_680)=false,_612).
index(suspended(_612,_678)=false,_612).
index(pow(accept_quote(_612,_682,_684))=true,_612).

cyclic(contract(_906,_908,_910)=true).
cyclic(suspended(_906,_908)=true).
cyclic(obl(send_EPO(_910,_912,_914))=true).
cyclic(obl(send_goods(_910,_912,_914))=true).
cyclic(contract(_906,_908,_910)=false).
cyclic(suspended(_906,_908)=false).

cachingOrder2(_1146, quote(_1146,_1148,_1150)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_1146,_1148),role_of(_1148,consumer),role_of(_1146,merchant),\+_1146=_1148,queryGoodsDescription(_1150).

cachingOrder2(_1146, quote(_1146,_1148,_1150)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_1146,_1148),role_of(_1148,consumer),role_of(_1146,merchant),\+_1146=_1148,queryGoodsDescription(_1150).

cachingOrder2(_1100, per(present_quote(_1100,_1102))=false) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_1100,_1102),role_of(_1100,merchant),role_of(_1102,consumer),\+_1102=_1100.

cachingOrder2(_1100, per(present_quote(_1100,_1102))=true) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_1100,_1102),role_of(_1100,merchant),role_of(_1102,consumer),\+_1102=_1100.

cachingOrder2(_1882, obl(send_goods(_1882,_2118,_1886))=true) :- % level in dependency graph: 2, processing order in component: 1
     person(_1882),role_of(_1882,merchant),queryGoodsDescription(_1886).

cachingOrder2(_1906, obl(send_EPO(_1906,_2276,_1910))=true) :- % level in dependency graph: 2, processing order in component: 2
     person(_1906),role_of(_1906,consumer),queryGoodsDescription(_1910).

cachingOrder2(_1926, suspended(_1926,_1928)=true) :- % level in dependency graph: 2, processing order in component: 3
     person(_1926),role_of(_1926,_1928).

cachingOrder2(_1944, suspended(_1944,_1946)=false) :- % level in dependency graph: 2, processing order in component: 4
     person(_1944),role_of(_1944,_1946).

cachingOrder2(_1962, contract(_1962,_1964,_1966)=true) :- % level in dependency graph: 2, processing order in component: 5
     person_pair(_1962,_1964),role_of(_1962,merchant),role_of(_1964,consumer),\+_1962=_1964,queryGoodsDescription(_1966).

cachingOrder2(_1982, contract(_1982,_1984,_1986)=false) :- % level in dependency graph: 2, processing order in component: 6
     person_pair(_1982,_1984),role_of(_1982,merchant),role_of(_1984,consumer),\+_1982=_1984,queryGoodsDescription(_1986).

cachingOrder2(_2916, obl(send_EPO(_2916,_3052,_2920))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2916),role_of(_2916,consumer),queryGoodsDescription(_2920).

cachingOrder2(_2886, obl(send_goods(_2886,_3210,_2890))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2886),role_of(_2886,merchant),queryGoodsDescription(_2890).

collectGrounds([send_EPO(_492,_506,_508,_510), send_goods(_492,_506,_508,_510,_512)],person(_492)).

collectGrounds([present_quote(_480,_482,_508,_510), accept_quote(_482,_480,_508), request_quote(_482,_480,_508), pow(accept_quote(_482,_480,_518))=true],person_pair(_480,_482)).

dgrounded(quote(_1352,_1354,_1356)=true, person_pair(_1352,_1354)).
dgrounded(contract(_1264,_1266,_1268)=true, person_pair(_1264,_1266)).
dgrounded(per(present_quote(_1188,_1190))=false, person_pair(_1188,_1190)).
dgrounded(per(present_quote(_1108,_1110))=true, person_pair(_1108,_1110)).
dgrounded(obl(send_EPO(_1046,iServer,_1050))=false, person(_1046)).
dgrounded(obl(send_goods(_984,iServer,_988))=false, person(_984)).
dgrounded(suspended(_934,_936)=true, person(_934)).
dgrounded(obl(send_EPO(_876,iServer,_880))=true, person(_876)).
dgrounded(obl(send_goods(_814,iServer,_818))=true, person(_814)).
dgrounded(quote(_722,_724,_726)=false, person_pair(_722,_724)).
dgrounded(contract(_634,_636,_638)=false, person_pair(_634,_636)).
dgrounded(suspended(_588,_590)=false, person(_588)).
