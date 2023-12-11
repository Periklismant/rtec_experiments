:- dynamic person/1, person_pair/2.

initiatedAt(quote(_110,_112,_114)=true, _136, _80, _142) :-
     happensAtIE(present_quote(_110,_112,_114,_124),_80),
     _136=<_80,
     _80<_142.

initiatedAt(contract(_110,_112,_114)=true, _222, _80, _228) :-
     happensAtIE(accept_quote(_112,_110,_114),_80),_222=<_80,_80<_228,
     holdsAtProcessedSimpleFluent(_110,quote(_110,_112,_114)=true,_80),
     \+holdsAtCyclic(_110,suspended(_110,merchant)=true,_80),
     \+holdsAtCyclic(_112,suspended(_112,consumer)=true,_80).

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

holdsForSDFluent(pow(accept_quote(_114,_116,_118))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,quote(_116,_114,_118)=true,_138),
     holdsForProcessedSimpleFluent(_114,suspended(_114,consumer)=true,_156),
     holdsForProcessedSimpleFluent(_116,suspended(_116,merchant)=true,_174),
     relative_complement_all(_138,[_156,_174],_80).

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

grounding(request_quote(_450,_452,_454)) :- 
     person_pair(_452,_450).

grounding(present_quote(_450,_452,_454,_456)) :- 
     person_pair(_450,_452).

grounding(accept_quote(_450,_452,_454)) :- 
     person_pair(_452,_450).

grounding(send_EPO(_450,_452,_454,_456)) :- 
     person(_450).

grounding(send_goods(_450,_452,_454,_456,_458)) :- 
     person(_450).

grounding(suspended(_456,_458)=true) :- 
     person(_456),role_of(_456,_458).

grounding(suspended(_456,_458)=false) :- 
     person(_456),role_of(_456,_458).

grounding(quote(_456,_458,_460)=true) :- 
     person_pair(_456,_458),role_of(_458,consumer),role_of(_456,merchant),\+_456=_458,queryGoodsDescription(_460).

grounding(quote(_456,_458,_460)=false) :- 
     person_pair(_456,_458),role_of(_458,consumer),role_of(_456,merchant),\+_456=_458,queryGoodsDescription(_460).

grounding(contract(_456,_458,_460)=true) :- 
     person_pair(_456,_458),role_of(_456,merchant),role_of(_458,consumer),\+_456=_458,queryGoodsDescription(_460).

grounding(contract(_456,_458,_460)=false) :- 
     person_pair(_456,_458),role_of(_456,merchant),role_of(_458,consumer),\+_456=_458,queryGoodsDescription(_460).

grounding(pow(accept_quote(_460,_462,_464))=true) :- 
     person_pair(_462,_460),role_of(_462,merchant),role_of(_460,consumer),\+_460=_462,queryGoodsDescription(_464).

grounding(per(present_quote(_460,_462))=false) :- 
     person_pair(_460,_462),role_of(_460,merchant),role_of(_462,consumer),\+_462=_460.

grounding(per(present_quote(_460,_462))=true) :- 
     person_pair(_460,_462),role_of(_460,merchant),role_of(_462,consumer),\+_462=_460.

grounding(obl(send_EPO(_460,iServer,_464))=true) :- 
     person(_460),role_of(_460,consumer),queryGoodsDescription(_464).

grounding(obl(send_goods(_460,iServer,_464))=true) :- 
     person(_460),role_of(_460,merchant),queryGoodsDescription(_464).

grounding(obl(send_EPO(_460,iServer,_464))=false) :- 
     person(_460),role_of(_460,consumer),queryGoodsDescription(_464).

grounding(obl(send_goods(_460,iServer,_464))=false) :- 
     person(_460),role_of(_460,merchant),queryGoodsDescription(_464).

p(quote(_450,_452,_454)=true).

p(per(present_quote(_454,_456))=false).

p(suspended(_450,_452)=true).

inputEntity(present_quote(_134,_136,_138,_140)).
inputEntity(accept_quote(_134,_136,_138)).
inputEntity(request_quote(_134,_136,_138)).
inputEntity(send_EPO(_134,_136,_138,_140)).
inputEntity(send_goods(_134,_136,_138,_140,_142)).

outputEntity(quote(_226,_228,_230)=true).
outputEntity(contract(_226,_228,_230)=true).
outputEntity(per(present_quote(_230,_232))=false).
outputEntity(per(present_quote(_230,_232))=true).
outputEntity(obl(send_EPO(_230,_232,_234))=false).
outputEntity(obl(send_goods(_230,_232,_234))=false).
outputEntity(suspended(_226,_228)=true).
outputEntity(obl(send_EPO(_230,_232,_234))=true).
outputEntity(obl(send_goods(_230,_232,_234))=true).
outputEntity(quote(_226,_228,_230)=false).
outputEntity(contract(_226,_228,_230)=false).
outputEntity(suspended(_226,_228)=false).
outputEntity(pow(accept_quote(_230,_232,_234))=true).

event(present_quote(_354,_356,_358,_360)).
event(accept_quote(_354,_356,_358)).
event(request_quote(_354,_356,_358)).
event(send_EPO(_354,_356,_358,_360)).
event(send_goods(_354,_356,_358,_360,_362)).

simpleFluent(quote(_446,_448,_450)=true).
simpleFluent(contract(_446,_448,_450)=true).
simpleFluent(per(present_quote(_450,_452))=false).
simpleFluent(per(present_quote(_450,_452))=true).
simpleFluent(obl(send_EPO(_450,_452,_454))=false).
simpleFluent(obl(send_goods(_450,_452,_454))=false).
simpleFluent(suspended(_446,_448)=true).
simpleFluent(obl(send_EPO(_450,_452,_454))=true).
simpleFluent(obl(send_goods(_450,_452,_454))=true).
simpleFluent(quote(_446,_448,_450)=false).
simpleFluent(contract(_446,_448,_450)=false).
simpleFluent(suspended(_446,_448)=false).

sDFluent(pow(accept_quote(_578,_580,_582))=true).

index(present_quote(_582,_636,_638,_640),_582).
index(accept_quote(_582,_636,_638),_582).
index(request_quote(_582,_636,_638),_582).
index(send_EPO(_582,_636,_638,_640),_582).
index(send_goods(_582,_636,_638,_640,_642),_582).
index(quote(_582,_642,_644)=true,_582).
index(contract(_582,_642,_644)=true,_582).
index(per(present_quote(_582,_646))=false,_582).
index(per(present_quote(_582,_646))=true,_582).
index(obl(send_EPO(_582,_646,_648))=false,_582).
index(obl(send_goods(_582,_646,_648))=false,_582).
index(suspended(_582,_642)=true,_582).
index(obl(send_EPO(_582,_646,_648))=true,_582).
index(obl(send_goods(_582,_646,_648))=true,_582).
index(quote(_582,_642,_644)=false,_582).
index(contract(_582,_642,_644)=false,_582).
index(suspended(_582,_642)=false,_582).
index(pow(accept_quote(_582,_646,_648))=true,_582).

cyclic(contract(_864,_866,_868)=true).
cyclic(suspended(_864,_866)=true).
cyclic(obl(send_EPO(_868,_870,_872))=true).
cyclic(obl(send_goods(_868,_870,_872))=true).
cyclic(contract(_864,_866,_868)=false).
cyclic(suspended(_864,_866)=false).

cachingOrder2(_1098, quote(_1098,_1100,_1102)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_1098,_1100),role_of(_1100,consumer),role_of(_1098,merchant),\+_1098=_1100,queryGoodsDescription(_1102).

cachingOrder2(_1098, quote(_1098,_1100,_1102)=false) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_1098,_1100),role_of(_1100,consumer),role_of(_1098,merchant),\+_1098=_1100,queryGoodsDescription(_1102).

cachingOrder2(_1052, per(present_quote(_1052,_1054))=false) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_1052,_1054),role_of(_1052,merchant),role_of(_1054,consumer),\+_1054=_1052.

cachingOrder2(_1052, per(present_quote(_1052,_1054))=true) :- % level in dependency graph: 1, processing order in component: 2
     person_pair(_1052,_1054),role_of(_1052,merchant),role_of(_1054,consumer),\+_1054=_1052.

cachingOrder2(_1828, obl(send_goods(_1828,_2064,_1832))=true) :- % level in dependency graph: 2, processing order in component: 1
     person(_1828),role_of(_1828,merchant),queryGoodsDescription(_1832).

cachingOrder2(_1852, obl(send_EPO(_1852,_2222,_1856))=true) :- % level in dependency graph: 2, processing order in component: 2
     person(_1852),role_of(_1852,consumer),queryGoodsDescription(_1856).

cachingOrder2(_1872, suspended(_1872,_1874)=true) :- % level in dependency graph: 2, processing order in component: 3
     person(_1872),role_of(_1872,_1874).

cachingOrder2(_1890, suspended(_1890,_1892)=false) :- % level in dependency graph: 2, processing order in component: 4
     person(_1890),role_of(_1890,_1892).

cachingOrder2(_1908, contract(_1908,_1910,_1912)=true) :- % level in dependency graph: 2, processing order in component: 5
     person_pair(_1908,_1910),role_of(_1908,merchant),role_of(_1910,consumer),\+_1908=_1910,queryGoodsDescription(_1912).

cachingOrder2(_1928, contract(_1928,_1930,_1932)=false) :- % level in dependency graph: 2, processing order in component: 6
     person_pair(_1928,_1930),role_of(_1928,merchant),role_of(_1930,consumer),\+_1928=_1930,queryGoodsDescription(_1932).

cachingOrder2(_2886, obl(send_EPO(_2886,_3022,_2890))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2886),role_of(_2886,consumer),queryGoodsDescription(_2890).

cachingOrder2(_2856, obl(send_goods(_2856,_3180,_2860))=false) :- % level in dependency graph: 3, processing order in component: 1
     person(_2856),role_of(_2856,merchant),queryGoodsDescription(_2860).

cachingOrder2(_2826, pow(accept_quote(_2826,_2828,_2830))=true) :- % level in dependency graph: 3, processing order in component: 1
     person_pair(_2828,_2826),role_of(_2828,merchant),role_of(_2826,consumer),\+_2826=_2828,queryGoodsDescription(_2830).

collectGrounds([send_EPO(_382,_396,_398,_400), send_goods(_382,_396,_398,_400,_402)],person(_382)).

collectGrounds([present_quote(_370,_372,_398,_400), accept_quote(_372,_370,_398), request_quote(_372,_370,_398)],person_pair(_370,_372)).

dgrounded(quote(_1328,_1330,_1332)=true, person_pair(_1328,_1330)).
dgrounded(contract(_1240,_1242,_1244)=true, person_pair(_1240,_1242)).
dgrounded(per(present_quote(_1164,_1166))=false, person_pair(_1164,_1166)).
dgrounded(per(present_quote(_1084,_1086))=true, person_pair(_1084,_1086)).
dgrounded(obl(send_EPO(_1022,iServer,_1026))=false, person(_1022)).
dgrounded(obl(send_goods(_960,iServer,_964))=false, person(_960)).
dgrounded(suspended(_910,_912)=true, person(_910)).
dgrounded(obl(send_EPO(_852,iServer,_856))=true, person(_852)).
dgrounded(obl(send_goods(_790,iServer,_794))=true, person(_790)).
dgrounded(quote(_698,_700,_702)=false, person_pair(_698,_700)).
dgrounded(contract(_610,_612,_614)=false, person_pair(_610,_612)).
dgrounded(suspended(_564,_566)=false, person(_564)).
dgrounded(pow(accept_quote(_476,_478,_480))=true, person_pair(_478,_476)).
