:- dynamic person/1, person_pair/2.

initiatedAt(quote(_110,_112,_114)=true, _148, _80, _154) :-
     happensAtIE(present_quote(_110,_112,_114,_124),_80),_148=<_80,_80<_154,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(contract(_110,_112,_114)=true, _222, _80, _228) :-
     happensAtIE(accept_quote(_112,_110,_114),_80),_222=<_80,_80<_228,
     holdsAtProcessedSimpleFluent(_110,quote(_110,_112,_114)=true,_80),
     \+holdsAtCyclic(_110,suspended(_110,merchant)=true,_80),
     \+holdsAtCyclic(_112,suspended(_112,consumer)=true,_80).

initiatedAt(per(present_quote(_114,_116))=false, _150, _80, _156) :-
     happensAtIE(present_quote(_114,_116,_124,_126),_80),_150=<_80,_80<_156,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(per(present_quote(_114,_116))=true, _148, _80, _154) :-
     happensAtIE(request_quote(_116,_114,_124),_80),_148=<_80,_80<_154,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(obl(send_EPO(_114,iServer,_118))=false, _152, _80, _158) :-
     happensAtIE(send_EPO(_114,iServer,_118,_128),_80),_152=<_80,_80<_158,
     price(_118,_128).

initiatedAt(obl(send_goods(_114,iServer,_118))=false, _168, _80, _174) :-
     happensAtIE(send_goods(_114,iServer,_118,_128,_130),_80),_168=<_80,_80<_174,
     decrypt(_128,_130,_144),
     meets(_144,_118).

initiatedAt(suspended(_110,merchant)=true, _180, _80, _186) :-
     happensAtIE(present_quote(_110,_118,_120,_122),_80),_180=<_80,_80<_186,
     updateVariableTemp(rule_evaluations,1),
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
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_118,obl(send_goods(_118,iServer,_134))=true,_82).

initiatedAt(suspended(_118,consumer)=true, _80, _82, _84) :-
     initiatedAt(contract(_130,_118,_134)=false,_80,_82,_84),
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_118,obl(send_EPO(_118,iServer,_134))=true,_82).

terminatedAt(quote(_110,_112,_114)=true, _146, _80, _152) :-
     happensAtIE(accept_quote(_112,_110,_114),_80),_146=<_80,_80<_152,
     updateVariableTemp(rule_evaluations,1).

holdsForSDFluent(pow(accept_quote(_114,_116,_118))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,quote(_116,_114,_118)=true,_138),
     holdsForProcessedSimpleFluent(_114,suspended(_114,consumer)=true,_156),
     holdsForProcessedSimpleFluent(_116,suspended(_116,merchant)=true,_174),
     relative_complement_all(_138,[_156,_174],_80).

fi(quote(_114,_116,_118)=true,quote(_114,_116,_118)=false,10):-
     grounding(quote(_114,_116,_118)=true),
     grounding(quote(_114,_116,_118)=false).

fi(contract(_114,_116,_118)=true,contract(_114,_116,_118)=false,10):-
     grounding(contract(_114,_116,_118)=true),
     grounding(contract(_114,_116,_118)=false).

fi(per(present_quote(_118,_120))=false,per(present_quote(_118,_120))=true,20):-
     grounding(per(present_quote(_118,_120))=false),
     grounding(per(present_quote(_118,_120))=true).

fi(suspended(_114,_116)=true,suspended(_114,_116)=false,6):-
     grounding(suspended(_114,_116)=true),
     grounding(suspended(_114,_116)=false).

grounding(request_quote(_422,_424,_426)) :- 
     person_pair(_424,_422).

grounding(present_quote(_422,_424,_426,_428)) :- 
     person_pair(_422,_424).

grounding(accept_quote(_422,_424,_426)) :- 
     person_pair(_424,_422).

grounding(send_EPO(_422,_424,_426,_428)) :- 
     person(_422).

grounding(send_goods(_422,_424,_426,_428,_430)) :- 
     person(_422).

grounding(suspended(_428,_430)=true) :- 
     person(_428),role_of(_428,_430).

grounding(suspended(_428,_430)=false) :- 
     person(_428),role_of(_428,_430).

grounding(quote(_428,_430,_432)=true) :- 
     person_pair(_428,_430),role_of(_430,consumer),role_of(_428,merchant),\+_428=_430,queryGoodsDescription(_432).

grounding(quote(_428,_430,_432)=false) :- 
     person_pair(_428,_430),role_of(_430,consumer),role_of(_428,merchant),\+_428=_430,queryGoodsDescription(_432).

grounding(contract(_428,_430,_432)=true) :- 
     person_pair(_428,_430),role_of(_428,merchant),role_of(_430,consumer),\+_428=_430,queryGoodsDescription(_432).

grounding(contract(_428,_430,_432)=false) :- 
     person_pair(_428,_430),role_of(_428,merchant),role_of(_430,consumer),\+_428=_430,queryGoodsDescription(_432).

grounding(pow(accept_quote(_432,_434,_436))=true) :- 
     person_pair(_434,_432),role_of(_434,merchant),role_of(_432,consumer),\+_432=_434,queryGoodsDescription(_436).

grounding(per(present_quote(_432,_434))=false) :- 
     person_pair(_432,_434),role_of(_432,merchant),role_of(_434,consumer),\+_434=_432.

grounding(per(present_quote(_432,_434))=true) :- 
     person_pair(_432,_434),role_of(_432,merchant),role_of(_434,consumer),\+_434=_432.

grounding(obl(send_EPO(_432,iServer,_436))=true) :- 
     person(_432),role_of(_432,consumer),queryGoodsDescription(_436).

grounding(obl(send_goods(_432,iServer,_436))=true) :- 
     person(_432),role_of(_432,merchant),queryGoodsDescription(_436).

grounding(obl(send_EPO(_432,iServer,_436))=false) :- 
     person(_432),role_of(_432,consumer),queryGoodsDescription(_436).

grounding(obl(send_goods(_432,iServer,_436))=false) :- 
     person(_432),role_of(_432,merchant),queryGoodsDescription(_436).

p(quote(_422,_424,_426)=true).

p(per(present_quote(_426,_428))=false).

p(suspended(_422,_424)=true).

inputEntity(present_quote(_140,_142,_144,_146)).
inputEntity(accept_quote(_140,_142,_144)).
inputEntity(request_quote(_140,_142,_144)).
inputEntity(send_EPO(_140,_142,_144,_146)).
inputEntity(send_goods(_140,_142,_144,_146,_148)).

outputEntity(quote(_238,_240,_242)=true).
outputEntity(contract(_238,_240,_242)=true).
outputEntity(per(present_quote(_242,_244))=false).
outputEntity(per(present_quote(_242,_244))=true).
outputEntity(obl(send_EPO(_242,_244,_246))=false).
outputEntity(obl(send_goods(_242,_244,_246))=false).
outputEntity(suspended(_238,_240)=true).
outputEntity(obl(send_EPO(_242,_244,_246))=true).
outputEntity(obl(send_goods(_242,_244,_246))=true).
outputEntity(quote(_238,_240,_242)=false).
outputEntity(contract(_238,_240,_242)=false).
outputEntity(suspended(_238,_240)=false).
outputEntity(pow(accept_quote(_242,_244,_246))=true).

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

cachingOrder2(_2946, obl(send_EPO(_2946,_3082,_2950))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2946),role_of(_2946,consumer),queryGoodsDescription(_2950).

cachingOrder2(_2916, obl(send_goods(_2916,_3240,_2920))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2916),role_of(_2916,merchant),queryGoodsDescription(_2920).

cachingOrder2(_2886, pow(accept_quote(_2886,_2888,_2890))=true) :- % level in dependency graph: 3, processing order in component: 1
     person_pair(_2888,_2886),role_of(_2888,merchant),role_of(_2886,consumer),\+_2886=_2888,queryGoodsDescription(_2890).

collectGrounds([send_EPO(_394,_408,_410,_412), send_goods(_394,_408,_410,_412,_414)],person(_394)).

collectGrounds([present_quote(_382,_384,_410,_412), accept_quote(_384,_382,_410), request_quote(_384,_382,_410)],person_pair(_382,_384)).

dgrounded(quote(_1346,_1348,_1350)=true, person_pair(_1346,_1348)).
dgrounded(contract(_1258,_1260,_1262)=true, person_pair(_1258,_1260)).
dgrounded(per(present_quote(_1182,_1184))=false, person_pair(_1182,_1184)).
dgrounded(per(present_quote(_1102,_1104))=true, person_pair(_1102,_1104)).
dgrounded(obl(send_EPO(_1040,iServer,_1044))=false, person(_1040)).
dgrounded(obl(send_goods(_978,iServer,_982))=false, person(_978)).
dgrounded(suspended(_928,_930)=true, person(_928)).
dgrounded(obl(send_EPO(_870,iServer,_874))=true, person(_870)).
dgrounded(obl(send_goods(_808,iServer,_812))=true, person(_808)).
dgrounded(quote(_716,_718,_720)=false, person_pair(_716,_718)).
dgrounded(contract(_628,_630,_632)=false, person_pair(_628,_630)).
dgrounded(suspended(_582,_584)=false, person(_582)).
dgrounded(pow(accept_quote(_494,_496,_498))=true, person_pair(_496,_494)).
