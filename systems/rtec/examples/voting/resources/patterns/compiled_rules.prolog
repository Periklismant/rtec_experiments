:- dynamic person/1.

initiatedAt(status(_100)=null, _110, -1, _118) :-
     _110=< -1,
     -1<_118.

initiatedAt(status(_110)=proposed, _156, _80, _162) :-
     happensAtIE(propose(_114,_110),_80),_156=<_80,_80<_162,
     holdsAtCyclic(_110,status(_110)=null,_80).

initiatedAt(status(_110)=voting, _156, _80, _162) :-
     happensAtIE(second(_114,_110),_80),_156=<_80,_80<_162,
     holdsAtCyclic(_110,status(_110)=proposed,_80).

initiatedAt(status(_110)=voted, _168, _80, _174) :-
     happensAtIE(close_ballot(_114,_110),_80),_168=<_80,_80<_174,
     role_of(_114,chair),
     holdsAtCyclic(_110,status(_110)=voting,_80).

initiatedAt(status(_110)=null, _170, _80, _176) :-
     happensAtIE(declare(_114,_110,_118),_80),_170=<_80,_80<_176,
     role_of(_114,chair),
     holdsAtCyclic(_110,status(_110)=voted,_80).

initiatedAt(voted(_110,_112)=_86, _154, _80, _160) :-
     happensAtIE(vote(_110,_112,_86),_80),_154=<_80,_80<_160,
     holdsAtProcessedSimpleFluent(_112,status(_112)=voting,_80).

initiatedAt(voted(_110,_112)=null, _138, _80, _144) :-
     happensAtProcessedSimpleFluent(_112,start(status(_112)=null),_80),
     _138=<_80,
     _80<_144.

initiatedAt(outcome(_110)=_86, _164, _80, _170) :-
     happensAtIE(declare(_114,_110,_86),_80),_164=<_80,_80<_170,
     holdsAtProcessedSimpleFluent(_110,status(_110)=voted,_80),
     role_of(_114,chair).

initiatedAt(auxPerCloseBallot(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(status(_110)=voting),_80),
     _136=<_80,
     _80<_142.

initiatedAt(auxPerCloseBallot(_110)=false, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(status(_110)=proposed),_80),
     _136=<_80,
     _80<_142.

initiatedAt(per(close_ballot(_114,_116))=true, _164, _80, _170) :-
     happensAtProcessedSimpleFluent(_116,end(auxPerCloseBallot(_116)=true),_80),_164=<_80,_80<_170,
     holdsAtProcessedSimpleFluent(_116,status(_116)=voting,_80).

initiatedAt(per(close_ballot(_114,_116))=false, _142, _80, _148) :-
     happensAtProcessedSimpleFluent(_116,start(status(_116)=voted),_80),
     _142=<_80,
     _80<_148.

initiatedAt(obl(declare(_114,_116,carried))=true, _136, _80, _142) :-
     happensAtProcessed(_116,auxMotionOutcomeEvent(_116,carried),_80),
     _136=<_80,
     _80<_142.

initiatedAt(obl(declare(_114,_116,carried))=false, _144, _80, _150) :-
     happensAtProcessedSimpleFluent(_116,start(status(_116)=null),_80),
     _144=<_80,
     _80<_150.

initiatedAt(sanctioned(_110)=true, _160, _80, _166) :-
     happensAtIE(close_ballot(_110,_116),_80),_160=<_80,_80<_166,
     \+holdsAtProcessedSimpleFluent(_110,per(close_ballot(_110,_116))=true,_80).

initiatedAt(sanctioned(_110)=true, _190, _80, _196) :-
     happensAtProcessedSimpleFluent(_124,end(status(_124)=voted),_80),_190=<_80,_80<_196,
     \+happensAtIE(declare(_110,_124,carried),_80),
     holdsAtProcessedSimpleFluent(_110,obl(declare(_110,_124,carried))=true,_80).

initiatedAt(sanctioned(_110)=true, _194, _80, _200) :-
     happensAtProcessedSimpleFluent(_124,end(status(_124)=voted),_80),_194=<_80,_80<_200,
     \+happensAtIE(declare(_110,_124,not_carried),_80),
     \+holdsAtProcessedSimpleFluent(_110,obl(declare(_110,_124,carried))=true,_80).

terminatedAt(outcome(_110)=_86, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(status(_110)=proposed),_80),
     _136=<_80,
     _80<_142.

holdsForSDFluent(pow(propose(_114,_116))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,status(_116)=null,_80).

holdsForSDFluent(pow(second(_114,_116))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,status(_116)=proposed,_80).

holdsForSDFluent(pow(vote(_114,_116))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,status(_116)=voting,_80).

holdsForSDFluent(pow(close_ballot(_114,_116))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,status(_116)=voting,_80).

holdsForSDFluent(pow(declare(_114,_116))=true,_80) :-
     holdsForProcessedSimpleFluent(_116,status(_116)=voted,_80).

happensAtEv(auxMotionOutcomeEvent(_98,carried),_80) :-
     happensAtProcessedSimpleFluent(_98,start(status(_98)=voted),_80),
     findall(_136,holdsAtProcessedSimpleFluent(_136,voted(_136,_98)=aye,_80),_146),
     length(_146,_152),
     findall(_136,holdsAtProcessedSimpleFluent(_136,voted(_136,_98)=nay,_80),_178),
     length(_178,_184),
     _152>=_184.

fi(status(_114)=proposed,status(_114)=null,10):-
     grounding(status(_114)=proposed),
     grounding(status(_114)=null).

fi(status(_114)=voting,status(_114)=voted,10):-
     grounding(status(_114)=voting),
     grounding(status(_114)=voted).

fi(status(_114)=voted,status(_114)=null,10):-
     grounding(status(_114)=voted),
     grounding(status(_114)=null).

fi(auxPerCloseBallot(_114)=true,auxPerCloseBallot(_114)=false,8):-
     grounding(auxPerCloseBallot(_114)=true),
     grounding(auxPerCloseBallot(_114)=false).

fi(sanctioned(_114)=true,sanctioned(_114)=false,4):-
     grounding(sanctioned(_114)=true),
     grounding(sanctioned(_114)=false).

grounding(propose(_418,_420)) :- 
     person(_418),motion(_420).

grounding(second(_418,_420)) :- 
     person(_418),motion(_420).

grounding(vote(_418,_420,_422)) :- 
     person(_418),motion(_420).

grounding(close_ballot(_418,_420)) :- 
     person(_418),motion(_420).

grounding(declare(_418,_420,_422)) :- 
     person(_418),motion(_420).

grounding(status(_424)=null) :- 
     queryMotion(_424).

grounding(status(_424)=proposed) :- 
     queryMotion(_424).

grounding(status(_424)=voting) :- 
     queryMotion(_424).

grounding(status(_424)=voted) :- 
     queryMotion(_424).

grounding(voted(_424,_426)=aye) :- 
     person(_424),role_of(_424,voter),queryMotion(_426).

grounding(voted(_424,_426)=nay) :- 
     person(_424),role_of(_424,voter),queryMotion(_426).

grounding(auxMotionOutcomeEvent(_418,_420)) :- 
     queryMotion(_418).

grounding(outcome(_424)=carried) :- 
     queryMotion(_424).

grounding(outcome(_424)=not_carried) :- 
     queryMotion(_424).

grounding(auxPerCloseBallot(_424)=true) :- 
     queryMotion(_424).

grounding(per(close_ballot(_428,_430))=true) :- 
     person(_428),role_of(_428,chair),queryMotion(_430).

grounding(obl(declare(_428,_430,carried))=true) :- 
     person(_428),role_of(_428,chair),queryMotion(_430).

grounding(sanctioned(_424)=true) :- 
     person(_424),role_of(_424,chair).

grounding(auxPerCloseBallot(_424)=false) :- 
     queryMotion(_424).

grounding(per(close_ballot(_428,_430))=false) :- 
     person(_428),role_of(_428,chair),queryMotion(_430).

grounding(obl(declare(_428,_430,carried))=false) :- 
     person(_428),role_of(_428,chair),queryMotion(_430).

grounding(sanctioned(_424)=false) :- 
     person(_424),role_of(_424,chair).

inputEntity(propose(_140,_142)).
inputEntity(second(_140,_142)).
inputEntity(close_ballot(_140,_142)).
inputEntity(declare(_140,_142,_144)).
inputEntity(vote(_140,_142,_144)).

outputEntity(status(_238)=proposed).
outputEntity(status(_238)=voting).
outputEntity(status(_238)=voted).
outputEntity(status(_238)=null).
outputEntity(voted(_238,_240)=aye).
outputEntity(voted(_238,_240)=nay).
outputEntity(voted(_238,_240)=null).
outputEntity(outcome(_238)=carried).
outputEntity(outcome(_238)=not_carried).
outputEntity(auxPerCloseBallot(_238)=true).
outputEntity(auxPerCloseBallot(_238)=false).
outputEntity(per(close_ballot(_242,_244))=true).
outputEntity(per(close_ballot(_242,_244))=false).
outputEntity(obl(declare(_242,_244,_246))=true).
outputEntity(obl(declare(_242,_244,_246))=false).
outputEntity(sanctioned(_238)=true).
outputEntity(sanctioned(_238)=false).
outputEntity(pow(propose(_242,_244))=true).
outputEntity(pow(second(_242,_244))=true).
outputEntity(pow(vote(_242,_244))=true).
outputEntity(pow(close_ballot(_242,_244))=true).
outputEntity(pow(declare(_242,_244))=true).
outputEntity(auxMotionOutcomeEvent(_232,_234)).

event(auxMotionOutcomeEvent(_432,_434)).
event(propose(_432,_434)).
event(second(_432,_434)).
event(close_ballot(_432,_434)).
event(declare(_432,_434,_436)).
event(vote(_432,_434,_436)).

simpleFluent(status(_536)=proposed).
simpleFluent(status(_536)=voting).
simpleFluent(status(_536)=voted).
simpleFluent(status(_536)=null).
simpleFluent(voted(_536,_538)=aye).
simpleFluent(voted(_536,_538)=nay).
simpleFluent(voted(_536,_538)=null).
simpleFluent(outcome(_536)=carried).
simpleFluent(outcome(_536)=not_carried).
simpleFluent(auxPerCloseBallot(_536)=true).
simpleFluent(auxPerCloseBallot(_536)=false).
simpleFluent(per(close_ballot(_540,_542))=true).
simpleFluent(per(close_ballot(_540,_542))=false).
simpleFluent(obl(declare(_540,_542,_544))=true).
simpleFluent(obl(declare(_540,_542,_544))=false).
simpleFluent(sanctioned(_536)=true).
simpleFluent(sanctioned(_536)=false).

sDFluent(pow(propose(_704,_706))=true).
sDFluent(pow(second(_704,_706))=true).
sDFluent(pow(vote(_704,_706))=true).
sDFluent(pow(close_ballot(_704,_706))=true).
sDFluent(pow(declare(_704,_706))=true).

index(auxMotionOutcomeEvent(_732,_792),_732).
index(propose(_732,_792),_732).
index(second(_732,_792),_732).
index(close_ballot(_732,_792),_732).
index(declare(_732,_792,_794),_732).
index(vote(_732,_792,_794),_732).
index(status(_732)=proposed,_732).
index(status(_732)=voting,_732).
index(status(_732)=voted,_732).
index(status(_732)=null,_732).
index(voted(_732,_798)=aye,_732).
index(voted(_732,_798)=nay,_732).
index(voted(_732,_798)=null,_732).
index(outcome(_732)=carried,_732).
index(outcome(_732)=not_carried,_732).
index(auxPerCloseBallot(_732)=true,_732).
index(auxPerCloseBallot(_732)=false,_732).
index(per(close_ballot(_732,_802))=true,_732).
index(per(close_ballot(_732,_802))=false,_732).
index(obl(declare(_732,_802,_804))=true,_732).
index(obl(declare(_732,_802,_804))=false,_732).
index(sanctioned(_732)=true,_732).
index(sanctioned(_732)=false,_732).
index(pow(propose(_732,_802))=true,_732).
index(pow(second(_732,_802))=true,_732).
index(pow(vote(_732,_802))=true,_732).
index(pow(close_ballot(_732,_802))=true,_732).
index(pow(declare(_732,_802))=true,_732).

cyclic(status(_1086)=proposed).
cyclic(status(_1086)=voting).
cyclic(status(_1086)=voted).
cyclic(status(_1086)=null).

cachingOrder2(_1216, status(_1216)=voting) :- % level in dependency graph: 1, processing order in component: 1
     queryMotion(_1216).

cachingOrder2(_1232, status(_1232)=voted) :- % level in dependency graph: 1, processing order in component: 2
     queryMotion(_1232).

cachingOrder2(_1248, status(_1248)=proposed) :- % level in dependency graph: 1, processing order in component: 3
     queryMotion(_1248).

cachingOrder2(_1264, status(_1264)=null) :- % level in dependency graph: 1, processing order in component: 4
     queryMotion(_1264).

cachingOrder2(_1948, voted(_1948,_1950)=aye) :- % level in dependency graph: 2, processing order in component: 1
     person(_1948),role_of(_1948,voter),queryMotion(_1950).

cachingOrder2(_1924, voted(_1924,_1926)=nay) :- % level in dependency graph: 2, processing order in component: 1
     person(_1924),role_of(_1924,voter),queryMotion(_1926).

cachingOrder2(_1878, outcome(_1878)=carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1878).

cachingOrder2(_1856, outcome(_1856)=not_carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1856).

cachingOrder2(_1818, auxPerCloseBallot(_1818)=true) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1818).

cachingOrder2(_1818, auxPerCloseBallot(_1818)=false) :- % level in dependency graph: 2, processing order in component: 2
     queryMotion(_1818).

cachingOrder2(_1794, per(close_ballot(_1794,_1796))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1794),role_of(_1794,chair),queryMotion(_1796).

cachingOrder2(_1764, obl(declare(_1764,_1766,_2726))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1764),role_of(_1764,chair),queryMotion(_1766).

cachingOrder2(_2844, per(close_ballot(_2844,_2846))=true) :- % level in dependency graph: 3, processing order in component: 1
     person(_2844),role_of(_2844,chair),queryMotion(_2846).

cachingOrder2(_2816, auxMotionOutcomeEvent(_2816,_2818)) :- % level in dependency graph: 3, processing order in component: 1
     queryMotion(_2816).

cachingOrder2(_3142, obl(declare(_3142,_3144,_3284))=true) :- % level in dependency graph: 4, processing order in component: 1
     person(_3142),role_of(_3142,chair),queryMotion(_3144).

cachingOrder2(_3380, sanctioned(_3380)=true) :- % level in dependency graph: 5, processing order in component: 1
     person(_3380),role_of(_3380,chair).

cachingOrder2(_3380, sanctioned(_3380)=false) :- % level in dependency graph: 5, processing order in component: 2
     person(_3380),role_of(_3380,chair).

collectGrounds([propose(_412,_426), second(_412,_426), close_ballot(_412,_426), declare(_412,_426,_428), vote(_412,_426,_428)],person(_412)).

dgrounded(voted(_1052,_1054)=aye, person(_1052)).
dgrounded(voted(_996,_998)=nay, person(_996)).
dgrounded(per(close_ballot(_812,_814))=true, person(_812)).
dgrounded(per(close_ballot(_752,_754))=false, person(_752)).
dgrounded(obl(declare(_690,_692,carried))=true, person(_690)).
dgrounded(obl(declare(_628,_630,carried))=false, person(_628)).
dgrounded(sanctioned(_580)=true, person(_580)).
dgrounded(sanctioned(_536)=false, person(_536)).
