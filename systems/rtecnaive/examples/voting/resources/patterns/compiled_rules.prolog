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

grounding(propose(_446,_448)) :- 
     person(_446),motion(_448).

grounding(second(_446,_448)) :- 
     person(_446),motion(_448).

grounding(vote(_446,_448,_450)) :- 
     person(_446),motion(_448).

grounding(close_ballot(_446,_448)) :- 
     person(_446),motion(_448).

grounding(declare(_446,_448,_450)) :- 
     person(_446),motion(_448).

grounding(status(_452)=null) :- 
     queryMotion(_452).

grounding(status(_452)=proposed) :- 
     queryMotion(_452).

grounding(status(_452)=voting) :- 
     queryMotion(_452).

grounding(status(_452)=voted) :- 
     queryMotion(_452).

grounding(voted(_452,_454)=aye) :- 
     person(_452),role_of(_452,voter),queryMotion(_454).

grounding(voted(_452,_454)=nay) :- 
     person(_452),role_of(_452,voter),queryMotion(_454).

grounding(auxMotionOutcomeEvent(_446,_448)) :- 
     queryMotion(_446).

grounding(outcome(_452)=carried) :- 
     queryMotion(_452).

grounding(outcome(_452)=not_carried) :- 
     queryMotion(_452).

grounding(auxPerCloseBallot(_452)=true) :- 
     queryMotion(_452).

grounding(per(close_ballot(_456,_458))=true) :- 
     person(_456),role_of(_456,chair),queryMotion(_458).

grounding(obl(declare(_456,_458,carried))=true) :- 
     person(_456),role_of(_456,chair),queryMotion(_458).

grounding(sanctioned(_452)=true) :- 
     person(_452),role_of(_452,chair).

grounding(auxPerCloseBallot(_452)=false) :- 
     queryMotion(_452).

grounding(per(close_ballot(_456,_458))=false) :- 
     person(_456),role_of(_456,chair),queryMotion(_458).

grounding(obl(declare(_456,_458,carried))=false) :- 
     person(_456),role_of(_456,chair),queryMotion(_458).

grounding(sanctioned(_452)=false) :- 
     person(_452),role_of(_452,chair).

inputEntity(propose(_134,_136)).
inputEntity(second(_134,_136)).
inputEntity(close_ballot(_134,_136)).
inputEntity(declare(_134,_136,_138)).
inputEntity(vote(_134,_136,_138)).

outputEntity(status(_226)=proposed).
outputEntity(status(_226)=voting).
outputEntity(status(_226)=voted).
outputEntity(status(_226)=null).
outputEntity(voted(_226,_228)=aye).
outputEntity(voted(_226,_228)=nay).
outputEntity(voted(_226,_228)=null).
outputEntity(outcome(_226)=carried).
outputEntity(outcome(_226)=not_carried).
outputEntity(auxPerCloseBallot(_226)=true).
outputEntity(auxPerCloseBallot(_226)=false).
outputEntity(per(close_ballot(_230,_232))=true).
outputEntity(per(close_ballot(_230,_232))=false).
outputEntity(obl(declare(_230,_232,_234))=true).
outputEntity(obl(declare(_230,_232,_234))=false).
outputEntity(sanctioned(_226)=true).
outputEntity(sanctioned(_226)=false).
outputEntity(pow(propose(_230,_232))=true).
outputEntity(pow(second(_230,_232))=true).
outputEntity(pow(vote(_230,_232))=true).
outputEntity(pow(close_ballot(_230,_232))=true).
outputEntity(pow(declare(_230,_232))=true).
outputEntity(auxMotionOutcomeEvent(_220,_222)).

event(auxMotionOutcomeEvent(_414,_416)).
event(propose(_414,_416)).
event(second(_414,_416)).
event(close_ballot(_414,_416)).
event(declare(_414,_416,_418)).
event(vote(_414,_416,_418)).

simpleFluent(status(_512)=proposed).
simpleFluent(status(_512)=voting).
simpleFluent(status(_512)=voted).
simpleFluent(status(_512)=null).
simpleFluent(voted(_512,_514)=aye).
simpleFluent(voted(_512,_514)=nay).
simpleFluent(voted(_512,_514)=null).
simpleFluent(outcome(_512)=carried).
simpleFluent(outcome(_512)=not_carried).
simpleFluent(auxPerCloseBallot(_512)=true).
simpleFluent(auxPerCloseBallot(_512)=false).
simpleFluent(per(close_ballot(_516,_518))=true).
simpleFluent(per(close_ballot(_516,_518))=false).
simpleFluent(obl(declare(_516,_518,_520))=true).
simpleFluent(obl(declare(_516,_518,_520))=false).
simpleFluent(sanctioned(_512)=true).
simpleFluent(sanctioned(_512)=false).

sDFluent(pow(propose(_674,_676))=true).
sDFluent(pow(second(_674,_676))=true).
sDFluent(pow(vote(_674,_676))=true).
sDFluent(pow(close_ballot(_674,_676))=true).
sDFluent(pow(declare(_674,_676))=true).

index(auxMotionOutcomeEvent(_702,_756),_702).
index(propose(_702,_756),_702).
index(second(_702,_756),_702).
index(close_ballot(_702,_756),_702).
index(declare(_702,_756,_758),_702).
index(vote(_702,_756,_758),_702).
index(status(_702)=proposed,_702).
index(status(_702)=voting,_702).
index(status(_702)=voted,_702).
index(status(_702)=null,_702).
index(voted(_702,_762)=aye,_702).
index(voted(_702,_762)=nay,_702).
index(voted(_702,_762)=null,_702).
index(outcome(_702)=carried,_702).
index(outcome(_702)=not_carried,_702).
index(auxPerCloseBallot(_702)=true,_702).
index(auxPerCloseBallot(_702)=false,_702).
index(per(close_ballot(_702,_766))=true,_702).
index(per(close_ballot(_702,_766))=false,_702).
index(obl(declare(_702,_766,_768))=true,_702).
index(obl(declare(_702,_766,_768))=false,_702).
index(sanctioned(_702)=true,_702).
index(sanctioned(_702)=false,_702).
index(pow(propose(_702,_766))=true,_702).
index(pow(second(_702,_766))=true,_702).
index(pow(vote(_702,_766))=true,_702).
index(pow(close_ballot(_702,_766))=true,_702).
index(pow(declare(_702,_766))=true,_702).

cyclic(status(_1044)=proposed).
cyclic(status(_1044)=voting).
cyclic(status(_1044)=voted).
cyclic(status(_1044)=null).

cachingOrder2(_1168, status(_1168)=voting) :- % level in dependency graph: 1, processing order in component: 1
     queryMotion(_1168).

cachingOrder2(_1184, status(_1184)=voted) :- % level in dependency graph: 1, processing order in component: 2
     queryMotion(_1184).

cachingOrder2(_1200, status(_1200)=proposed) :- % level in dependency graph: 1, processing order in component: 3
     queryMotion(_1200).

cachingOrder2(_1216, status(_1216)=null) :- % level in dependency graph: 1, processing order in component: 4
     queryMotion(_1216).

cachingOrder2(_1894, voted(_1894,_1896)=aye) :- % level in dependency graph: 2, processing order in component: 1
     person(_1894),role_of(_1894,voter),queryMotion(_1896).

cachingOrder2(_1870, voted(_1870,_1872)=nay) :- % level in dependency graph: 2, processing order in component: 1
     person(_1870),role_of(_1870,voter),queryMotion(_1872).

cachingOrder2(_1824, outcome(_1824)=carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1824).

cachingOrder2(_1802, outcome(_1802)=not_carried) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1802).

cachingOrder2(_1764, auxPerCloseBallot(_1764)=true) :- % level in dependency graph: 2, processing order in component: 1
     queryMotion(_1764).

cachingOrder2(_1764, auxPerCloseBallot(_1764)=false) :- % level in dependency graph: 2, processing order in component: 2
     queryMotion(_1764).

cachingOrder2(_1740, per(close_ballot(_1740,_1742))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1740),role_of(_1740,chair),queryMotion(_1742).

cachingOrder2(_1710, obl(declare(_1710,_1712,_2672))=false) :- % level in dependency graph: 2, processing order in component: 1
     person(_1710),role_of(_1710,chair),queryMotion(_1712).

cachingOrder2(_2784, per(close_ballot(_2784,_2786))=true) :- % level in dependency graph: 3, processing order in component: 1
     person(_2784),role_of(_2784,chair),queryMotion(_2786).

cachingOrder2(_2756, auxMotionOutcomeEvent(_2756,_2758)) :- % level in dependency graph: 3, processing order in component: 1
     queryMotion(_2756).

cachingOrder2(_3076, obl(declare(_3076,_3078,_3218))=true) :- % level in dependency graph: 4, processing order in component: 1
     person(_3076),role_of(_3076,chair),queryMotion(_3078).

cachingOrder2(_3308, sanctioned(_3308)=true) :- % level in dependency graph: 5, processing order in component: 1
     person(_3308),role_of(_3308,chair).

cachingOrder2(_3308, sanctioned(_3308)=false) :- % level in dependency graph: 5, processing order in component: 2
     person(_3308),role_of(_3308,chair).

collectGrounds([propose(_400,_414), second(_400,_414), close_ballot(_400,_414), declare(_400,_414,_416), vote(_400,_414,_416)],person(_400)).

dgrounded(voted(_1034,_1036)=aye, person(_1034)).
dgrounded(voted(_978,_980)=nay, person(_978)).
dgrounded(per(close_ballot(_794,_796))=true, person(_794)).
dgrounded(per(close_ballot(_734,_736))=false, person(_734)).
dgrounded(obl(declare(_672,_674,carried))=true, person(_672)).
dgrounded(obl(declare(_610,_612,carried))=false, person(_610)).
dgrounded(sanctioned(_562)=true, person(_562)).
dgrounded(sanctioned(_518)=false, person(_518)).
