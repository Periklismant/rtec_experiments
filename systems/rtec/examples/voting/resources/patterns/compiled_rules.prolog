:- dynamic person/1.

initiatedAt(status(_96)=null, _106, -1, _114) :-
     _106=< -1,
     -1<_114.

initiatedAt(status(_106)=proposed, _164, _76, _170) :-
     happensAtIE(propose(_110,_106),_76),_164=<_76,_76<_170,
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_106,status(_106)=null,_76).

initiatedAt(status(_106)=voting, _164, _76, _170) :-
     happensAtIE(second(_110,_106),_76),_164=<_76,_76<_170,
     updateVariableTemp(rule_evaluations,1),
     holdsAtCyclic(_106,status(_106)=proposed,_76).

initiatedAt(status(_106)=voted, _176, _76, _182) :-
     happensAtIE(close_ballot(_110,_106),_76),_176=<_76,_76<_182,
     updateVariableTemp(rule_evaluations,1),
     role_of(_110,chair),
     holdsAtCyclic(_106,status(_106)=voting,_76).

initiatedAt(status(_106)=null, _178, _76, _184) :-
     happensAtIE(declare(_110,_106,_114),_76),_178=<_76,_76<_184,
     updateVariableTemp(rule_evaluations,1),
     role_of(_110,chair),
     holdsAtCyclic(_106,status(_106)=voted,_76).

initiatedAt(voted(_106,_108)=_82, _150, _76, _156) :-
     happensAtIE(vote(_106,_108,_82),_76),_150=<_76,_76<_156,
     holdsAtProcessedSimpleFluent(_108,status(_108)=voting,_76).

initiatedAt(voted(_106,_108)=null, _134, _76, _140) :-
     happensAtProcessedSimpleFluent(_108,start(status(_108)=null),_76),
     _134=<_76,
     _76<_140.

initiatedAt(outcome(_106)=_82, _160, _76, _166) :-
     happensAtIE(declare(_110,_106,_82),_76),_160=<_76,_76<_166,
     holdsAtProcessedSimpleFluent(_106,status(_106)=voted,_76),
     role_of(_110,chair).

initiatedAt(auxPerCloseBallot(_106)=true, _144, _76, _150) :-
     happensAtProcessedSimpleFluent(_106,start(status(_106)=voting),_76),_144=<_76,_76<_150,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(auxPerCloseBallot(_106)=false, _144, _76, _150) :-
     happensAtProcessedSimpleFluent(_106,start(status(_106)=proposed),_76),_144=<_76,_76<_150,
     updateVariableTemp(rule_evaluations,1).

initiatedAt(per(close_ballot(_110,_112))=true, _160, _76, _166) :-
     happensAtProcessedSimpleFluent(_112,end(auxPerCloseBallot(_112)=true),_76),_160=<_76,_76<_166,
     holdsAtProcessedSimpleFluent(_112,status(_112)=voting,_76).

initiatedAt(per(close_ballot(_110,_112))=false, _138, _76, _144) :-
     happensAtProcessedSimpleFluent(_112,start(status(_112)=voted),_76),
     _138=<_76,
     _76<_144.

initiatedAt(obl(declare(_110,_112,carried))=true, _132, _76, _138) :-
     happensAtProcessed(_112,auxMotionOutcomeEvent(_112,carried),_76),
     _132=<_76,
     _76<_138.

initiatedAt(obl(declare(_110,_112,carried))=false, _140, _76, _146) :-
     happensAtProcessedSimpleFluent(_112,start(status(_112)=null),_76),
     _140=<_76,
     _76<_146.

initiatedAt(sanctioned(_106)=true, _168, _76, _174) :-
     happensAtIE(close_ballot(_106,_112),_76),_168=<_76,_76<_174,
     updateVariableTemp(rule_evaluations,1),
     \+holdsAtProcessedSimpleFluent(_106,per(close_ballot(_106,_112))=true,_76).

initiatedAt(sanctioned(_106)=true, _198, _76, _204) :-
     happensAtProcessedSimpleFluent(_120,end(status(_120)=voted),_76),_198=<_76,_76<_204,
     updateVariableTemp(rule_evaluations,1),
     \+happensAtIE(declare(_106,_120,carried),_76),
     holdsAtProcessedSimpleFluent(_106,obl(declare(_106,_120,carried))=true,_76).

initiatedAt(sanctioned(_106)=true, _202, _76, _208) :-
     happensAtProcessedSimpleFluent(_120,end(status(_120)=voted),_76),_202=<_76,_76<_208,
     updateVariableTemp(rule_evaluations,1),
     \+happensAtIE(declare(_106,_120,not_carried),_76),
     \+holdsAtProcessedSimpleFluent(_106,obl(declare(_106,_120,carried))=true,_76).

terminatedAt(outcome(_106)=_82, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(status(_106)=proposed),_76),
     _132=<_76,
     _76<_138.

holdsForSDFluent(pow(propose(_110,_112))=true,_76) :-
     holdsForProcessedSimpleFluent(_112,status(_112)=null,_76).

holdsForSDFluent(pow(second(_110,_112))=true,_76) :-
     holdsForProcessedSimpleFluent(_112,status(_112)=proposed,_76).

holdsForSDFluent(pow(vote(_110,_112))=true,_76) :-
     holdsForProcessedSimpleFluent(_112,status(_112)=voting,_76).

holdsForSDFluent(pow(close_ballot(_110,_112))=true,_76) :-
     holdsForProcessedSimpleFluent(_112,status(_112)=voting,_76).

holdsForSDFluent(pow(declare(_110,_112))=true,_76) :-
     holdsForProcessedSimpleFluent(_112,status(_112)=voted,_76).

happensAtEv(auxMotionOutcomeEvent(_94,carried),_76) :-
     happensAtProcessedSimpleFluent(_94,start(status(_94)=voted),_76),
     findall(_132,holdsAtProcessedSimpleFluent(_132,voted(_132,_94)=aye,_76),_142),
     length(_142,_148),
     findall(_132,holdsAtProcessedSimpleFluent(_132,voted(_132,_94)=nay,_76),_174),
     length(_174,_180),
     _148>=_180.

fi(status(_116)=proposed,status(_116)=null,_78):-
     status_deadline(_78),
     grounding(status(_116)=proposed),
     grounding(status(_116)=null).

fi(status(_116)=voting,status(_116)=voted,_78):-
     status_deadline(_78),
     grounding(status(_116)=voting),
     grounding(status(_116)=voted).

fi(status(_116)=voted,status(_116)=null,_78):-
     status_deadline(_78),
     grounding(status(_116)=voted),
     grounding(status(_116)=null).

fi(auxPerCloseBallot(_116)=true,auxPerCloseBallot(_116)=false,_78):-
     permission_deadline(_78),
     grounding(auxPerCloseBallot(_116)=true),
     grounding(auxPerCloseBallot(_116)=false).

fi(sanctioned(_116)=true,sanctioned(_116)=false,_78):-
     sanctioned_deadline(_78),
     grounding(sanctioned(_116)=true),
     grounding(sanctioned(_116)=false).

grounding(propose(_414,_416)) :- 
     person(_414),motion(_416).

grounding(second(_414,_416)) :- 
     person(_414),motion(_416).

grounding(vote(_414,_416,_418)) :- 
     person(_414),motion(_416).

grounding(close_ballot(_414,_416)) :- 
     person(_414),motion(_416).

grounding(declare(_414,_416,_418)) :- 
     person(_414),motion(_416).

grounding(status(_420)=null) :- 
     queryMotion(_420).

grounding(status(_420)=proposed) :- 
     queryMotion(_420).

grounding(status(_420)=voting) :- 
     queryMotion(_420).

grounding(status(_420)=voted) :- 
     queryMotion(_420).

grounding(voted(_420,_422)=aye) :- 
     person(_420),role_of(_420,voter),queryMotion(_422).

grounding(voted(_420,_422)=nay) :- 
     person(_420),role_of(_420,voter),queryMotion(_422).

grounding(auxMotionOutcomeEvent(_414,_416)) :- 
     queryMotion(_414).

grounding(outcome(_420)=carried) :- 
     queryMotion(_420).

grounding(outcome(_420)=not_carried) :- 
     queryMotion(_420).

grounding(auxPerCloseBallot(_420)=true) :- 
     queryMotion(_420).

grounding(per(close_ballot(_424,_426))=true) :- 
     person(_424),role_of(_424,chair),queryMotion(_426).

grounding(obl(declare(_424,_426,carried))=true) :- 
     person(_424),role_of(_424,chair),queryMotion(_426).

grounding(sanctioned(_420)=true) :- 
     person(_420),role_of(_420,chair).

grounding(auxPerCloseBallot(_420)=false) :- 
     queryMotion(_420).

grounding(per(close_ballot(_424,_426))=false) :- 
     person(_424),role_of(_424,chair),queryMotion(_426).

grounding(obl(declare(_424,_426,carried))=false) :- 
     person(_424),role_of(_424,chair),queryMotion(_426).

grounding(sanctioned(_420)=false) :- 
     person(_420),role_of(_420,chair).

inputEntity(propose(_136,_138)).
inputEntity(second(_136,_138)).
inputEntity(close_ballot(_136,_138)).
inputEntity(declare(_136,_138,_140)).
inputEntity(vote(_136,_138,_140)).

outputEntity(status(_234)=proposed).
outputEntity(status(_234)=voting).
outputEntity(status(_234)=voted).
outputEntity(status(_234)=null).
outputEntity(voted(_234,_236)=aye).
outputEntity(voted(_234,_236)=nay).
outputEntity(voted(_234,_236)=null).
outputEntity(outcome(_234)=carried).
outputEntity(outcome(_234)=not_carried).
outputEntity(auxPerCloseBallot(_234)=true).
outputEntity(auxPerCloseBallot(_234)=false).
outputEntity(per(close_ballot(_238,_240))=true).
outputEntity(per(close_ballot(_238,_240))=false).
outputEntity(obl(declare(_238,_240,_242))=true).
outputEntity(obl(declare(_238,_240,_242))=false).
outputEntity(sanctioned(_234)=true).
outputEntity(sanctioned(_234)=false).
outputEntity(pow(propose(_238,_240))=true).
outputEntity(pow(second(_238,_240))=true).
outputEntity(pow(vote(_238,_240))=true).
outputEntity(pow(close_ballot(_238,_240))=true).
outputEntity(pow(declare(_238,_240))=true).
outputEntity(auxMotionOutcomeEvent(_228,_230)).

event(auxMotionOutcomeEvent(_428,_430)).
event(propose(_428,_430)).
event(second(_428,_430)).
event(close_ballot(_428,_430)).
event(declare(_428,_430,_432)).
event(vote(_428,_430,_432)).

simpleFluent(status(_532)=proposed).
simpleFluent(status(_532)=voting).
simpleFluent(status(_532)=voted).
simpleFluent(status(_532)=null).
simpleFluent(voted(_532,_534)=aye).
simpleFluent(voted(_532,_534)=nay).
simpleFluent(voted(_532,_534)=null).
simpleFluent(outcome(_532)=carried).
simpleFluent(outcome(_532)=not_carried).
simpleFluent(auxPerCloseBallot(_532)=true).
simpleFluent(auxPerCloseBallot(_532)=false).
simpleFluent(per(close_ballot(_536,_538))=true).
simpleFluent(per(close_ballot(_536,_538))=false).
simpleFluent(obl(declare(_536,_538,_540))=true).
simpleFluent(obl(declare(_536,_538,_540))=false).
simpleFluent(sanctioned(_532)=true).
simpleFluent(sanctioned(_532)=false).

sDFluent(pow(propose(_700,_702))=true).
sDFluent(pow(second(_700,_702))=true).
sDFluent(pow(vote(_700,_702))=true).
sDFluent(pow(close_ballot(_700,_702))=true).
sDFluent(pow(declare(_700,_702))=true).

index(auxMotionOutcomeEvent(_728,_788),_728).
index(propose(_728,_788),_728).
index(second(_728,_788),_728).
index(close_ballot(_728,_788),_728).
index(declare(_728,_788,_790),_728).
index(vote(_728,_788,_790),_728).
index(status(_728)=proposed,_728).
index(status(_728)=voting,_728).
index(status(_728)=voted,_728).
index(status(_728)=null,_728).
index(voted(_728,_794)=aye,_728).
index(voted(_728,_794)=nay,_728).
index(voted(_728,_794)=null,_728).
index(outcome(_728)=carried,_728).
index(outcome(_728)=not_carried,_728).
index(auxPerCloseBallot(_728)=true,_728).
index(auxPerCloseBallot(_728)=false,_728).
index(per(close_ballot(_728,_798))=true,_728).
index(per(close_ballot(_728,_798))=false,_728).
index(obl(declare(_728,_798,_800))=true,_728).
index(obl(declare(_728,_798,_800))=false,_728).
index(sanctioned(_728)=true,_728).
index(sanctioned(_728)=false,_728).
index(pow(propose(_728,_798))=true,_728).
index(pow(second(_728,_798))=true,_728).
index(pow(vote(_728,_798))=true,_728).
index(pow(close_ballot(_728,_798))=true,_728).
index(pow(declare(_728,_798))=true,_728).

cyclic(status(_1082)=proposed).
cyclic(status(_1082)=voting).
cyclic(status(_1082)=voted).
cyclic(status(_1082)=null).

cachingOrder2(_1212, status(_1212)=voting) :- % level in dependency graph: 1, processing order in component: 1
     queryMotion(_1212).

cachingOrder2(_1228, status(_1228)=voted) :- % level in dependency graph: 1, processing order in component: 2
     queryMotion(_1228).

cachingOrder2(_1244, status(_1244)=proposed) :- % level in dependency graph: 1, processing order in component: 3
     queryMotion(_1244).

cachingOrder2(_1260, status(_1260)=null) :- % level in dependency graph: 1, processing order in component: 4
     queryMotion(_1260).

cachingOrder2(_1944, voted(_1944,_1946)=aye) :- % level in dependency graph: 2, processing order in component: 1
     person(_1944),role_of(_1944,voter),queryMotion(_1946).

cachingOrder2(_1920, voted(_1920,_1922)=nay) :- % level in dependency graph: 2, processing order in component: 1
     person(_1920),role_of(_1920,voter),queryMotion(_1922).

cachingOrder2(_1874, outcome(_1874)=carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1874).

cachingOrder2(_1852, outcome(_1852)=not_carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1852).

cachingOrder2(_1814, auxPerCloseBallot(_1814)=true) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1814).

cachingOrder2(_1814, auxPerCloseBallot(_1814)=false) :- % level in dependency graph: 2, processing order in component: 2
     queryMotion(_1814).

cachingOrder2(_1790, per(close_ballot(_1790,_1792))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1790),role_of(_1790,chair),queryMotion(_1792).

cachingOrder2(_1760, obl(declare(_1760,_1762,_2722))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1760),role_of(_1760,chair),queryMotion(_1762).

cachingOrder2(_2840, per(close_ballot(_2840,_2842))=true) :- % level in dependency graph: 3, processing order in component: 1
     person(_2840),role_of(_2840,chair),queryMotion(_2842).

cachingOrder2(_2812, auxMotionOutcomeEvent(_2812,_2814)) :- % level in dependency graph: 3, processing order in component: 1
     queryMotion(_2812).

cachingOrder2(_3138, obl(declare(_3138,_3140,_3280))=true) :- % level in dependency graph: 4, processing order in component: 1
     person(_3138),role_of(_3138,chair),queryMotion(_3140).

cachingOrder2(_3376, sanctioned(_3376)=true) :- % level in dependency graph: 5, processing order in component: 1
     person(_3376),role_of(_3376,chair).

cachingOrder2(_3376, sanctioned(_3376)=false) :- % level in dependency graph: 5, processing order in component: 2
     person(_3376),role_of(_3376,chair).

collectGrounds([propose(_408,_422), second(_408,_422), close_ballot(_408,_422), declare(_408,_422,_424), vote(_408,_422,_424)],person(_408)).

dgrounded(voted(_1048,_1050)=aye, person(_1048)).
dgrounded(voted(_992,_994)=nay, person(_992)).
dgrounded(per(close_ballot(_808,_810))=true, person(_808)).
dgrounded(per(close_ballot(_748,_750))=false, person(_748)).
dgrounded(obl(declare(_686,_688,carried))=true, person(_686)).
dgrounded(obl(declare(_624,_626,carried))=false, person(_624)).
dgrounded(sanctioned(_576)=true, person(_576)).
dgrounded(sanctioned(_532)=false, person(_532)).
