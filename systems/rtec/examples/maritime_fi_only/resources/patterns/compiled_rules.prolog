:- dynamic vessel/1, vpair/2.

initiatedAt(withinArea(_106,_108)=true, _138, _76, _144) :-
     happensAtIE(entersArea(_106,_114),_76),_138=<_76,_76<_144,
     areaType(_114,_108).

initiatedAt(gap(_106)=nearPorts, _146, _76, _152) :-
     happensAtIE(gap_start(_106),_76),_146=<_76,_76<_152,
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,nearPorts)=true,_76).

initiatedAt(gap(_106)=farFromPorts, _150, _76, _156) :-
     happensAtIE(gap_start(_106),_76),_150=<_76,_76<_156,
     \+holdsAtProcessedSimpleFluent(_106,withinArea(_106,nearPorts)=true,_76).

initiatedAt(changingSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(change_in_speed_start(_106),_76),
     _122=<_76,
     _76<_128.

initiatedAt(trawlSpeed(_106)=true, _190, _76, _196) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_190=<_76,_76<_196,
     thresholds(trawlspeedMin,_128),
     thresholds(trawlspeedMax,_134),
     inRange(_112,_128,_134),
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,fishing)=true,_76).

initiatedAt(trawlingMovement(_106)=true, _146, _76, _152) :-
     happensAtIE(change_in_heading(_106),_76),_146=<_76,_76<_152,
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,fishing)=true,_76).

initiatedAt(sarSpeed(_106)=true, _154, _76, _160) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_154=<_76,_76<_160,
     thresholds(sarMinSpeed,_128),
     inRange(_112,_128,inf).

initiatedAt(sarMovement(_106)=true, _122, _76, _128) :-
     happensAtIE(change_in_heading(_106),_76),
     _122=<_76,
     _76<_128.

initiatedAt(sarMovement(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(changingSpeed(_106)=true),_76),
     _132=<_76,
     _76<_138.

terminatedAt(withinArea(_106,_108)=true, _138, _76, _144) :-
     happensAtIE(leavesArea(_106,_114),_76),_138=<_76,_76<_144,
     areaType(_114,_108).

terminatedAt(withinArea(_106,_108)=true, _124, _76, _130) :-
     happensAtIE(gap_start(_106),_76),
     _124=<_76,
     _76<_130.

terminatedAt(gap(_106)=_82, _122, _76, _128) :-
     happensAtIE(gap_end(_106),_76),
     _122=<_76,
     _76<_128.

terminatedAt(changingSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(change_in_speed_end(_106),_76),
     _122=<_76,
     _76<_128.

terminatedAt(changingSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(trawlSpeed(_106)=true, _170, _76, _176) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_170=<_76,_76<_176,
     thresholds(trawlspeedMin,_128),
     thresholds(trawlspeedMax,_134),
     \+inRange(_112,_128,_134).

terminatedAt(trawlSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(trawlSpeed(_106)=true, _134, _76, _140) :-
     happensAtProcessedSimpleFluent(_106,end(withinArea(_106,fishing)=true),_76),
     _134=<_76,
     _76<_140.

terminatedAt(trawlingMovement(_106)=true, _134, _76, _140) :-
     happensAtProcessedSimpleFluent(_106,end(withinArea(_106,fishing)=true),_76),
     _134=<_76,
     _76<_140.

terminatedAt(sarSpeed(_106)=true, _154, _76, _160) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_154=<_76,_76<_160,
     thresholds(sarMinSpeed,_128),
     inRange(_112,0,_128).

terminatedAt(sarSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(sarMovement(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

holdsForSDFluent(trawling(_106)=true,_76) :-
     holdsForProcessedSimpleFluent(_106,trawlSpeed(_106)=true,_122),
     holdsForProcessedSimpleFluent(_106,trawlingMovement(_106)=true,_138),
     intersect_all([_122,_138],_156),
     thresholds(trawlingTime,_162),
     intDurGreater(_156,_162,_76).

holdsForSDFluent(inSAR(_106)=true,_76) :-
     holdsForProcessedSimpleFluent(_106,sarSpeed(_106)=true,_122),
     holdsForProcessedSimpleFluent(_106,sarMovement(_106)=true,_138),
     intersect_all([_122,_138],_156),
     intDurGreater(_156,3600,_76).

fi(trawlingMovement(_116)=true,trawlingMovement(_116)=false,_78):-
     thresholds(trawlingCrs,_78),
     grounding(trawlingMovement(_116)=true),
     grounding(trawlingMovement(_116)=false).

fi(sarMovement(_110)=true,sarMovement(_110)=false,1800):-
     grounding(sarMovement(_110)=true),
     grounding(sarMovement(_110)=false).

collectIntervals2(_80, proximity(_80,_82)=true) :-
     vpair(_80,_82).

needsGrounding(_266,_268,_270) :- 
     fail.

grounding(change_in_speed_start(_448)) :- 
     vessel(_448).

grounding(change_in_speed_end(_448)) :- 
     vessel(_448).

grounding(change_in_heading(_448)) :- 
     vessel(_448).

grounding(stop_start(_448)) :- 
     vessel(_448).

grounding(stop_end(_448)) :- 
     vessel(_448).

grounding(slow_motion_start(_448)) :- 
     vessel(_448).

grounding(slow_motion_end(_448)) :- 
     vessel(_448).

grounding(gap_start(_448)) :- 
     vessel(_448).

grounding(gap_end(_448)) :- 
     vessel(_448).

grounding(entersArea(_448,_450)) :- 
     vessel(_448),areaType(_450).

grounding(leavesArea(_448,_450)) :- 
     vessel(_448),areaType(_450).

grounding(coord(_448,_450,_452)) :- 
     vessel(_448).

grounding(velocity(_448,_450,_452,_454)) :- 
     vessel(_448).

grounding(proximity(_454,_456)=true) :- 
     vpair(_454,_456).

grounding(gap(_454)=_450) :- 
     vessel(_454),portStatus(_450).

grounding(changingSpeed(_454)=true) :- 
     vessel(_454).

grounding(withinArea(_454,_456)=true) :- 
     vessel(_454),areaType(_456).

grounding(sarSpeed(_454)=true) :- 
     vessel(_454),vesselType(_454,sar).

grounding(sarMovement(_454)=true) :- 
     vessel(_454),vesselType(_454,sar).

grounding(sarMovement(_454)=false) :- 
     vessel(_454),vesselType(_454,sar).

grounding(inSAR(_454)=true) :- 
     vessel(_454).

grounding(trawlSpeed(_454)=true) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(trawlingMovement(_454)=true) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(trawlingMovement(_454)=false) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(trawling(_454)=true) :- 
     vessel(_454).

p(trawlingMovement(_448)=true).

p(sarMovement(_448)=true).

inputEntity(entersArea(_136,_138)).
inputEntity(gap_start(_136)).
inputEntity(change_in_speed_start(_136)).
inputEntity(velocity(_136,_138,_140,_142)).
inputEntity(change_in_heading(_136)).
inputEntity(leavesArea(_136,_138)).
inputEntity(gap_end(_136)).
inputEntity(change_in_speed_end(_136)).
inputEntity(stop_start(_136)).
inputEntity(stop_end(_136)).
inputEntity(slow_motion_start(_136)).
inputEntity(slow_motion_end(_136)).
inputEntity(coord(_136,_138,_140)).
inputEntity(proximity(_142,_144)=true).

outputEntity(withinArea(_288,_290)=true).
outputEntity(gap(_288)=nearPorts).
outputEntity(gap(_288)=farFromPorts).
outputEntity(changingSpeed(_288)=true).
outputEntity(trawlSpeed(_288)=true).
outputEntity(trawlingMovement(_288)=true).
outputEntity(sarSpeed(_288)=true).
outputEntity(sarMovement(_288)=true).
outputEntity(trawlingMovement(_288)=false).
outputEntity(sarMovement(_288)=false).
outputEntity(trawling(_288)=true).
outputEntity(inSAR(_288)=true).

event(entersArea(_416,_418)).
event(gap_start(_416)).
event(change_in_speed_start(_416)).
event(velocity(_416,_418,_420,_422)).
event(change_in_heading(_416)).
event(leavesArea(_416,_418)).
event(gap_end(_416)).
event(change_in_speed_end(_416)).
event(stop_start(_416)).
event(stop_end(_416)).
event(slow_motion_start(_416)).
event(slow_motion_end(_416)).
event(coord(_416,_418,_420)).

simpleFluent(withinArea(_562,_564)=true).
simpleFluent(gap(_562)=nearPorts).
simpleFluent(gap(_562)=farFromPorts).
simpleFluent(changingSpeed(_562)=true).
simpleFluent(trawlSpeed(_562)=true).
simpleFluent(trawlingMovement(_562)=true).
simpleFluent(sarSpeed(_562)=true).
simpleFluent(sarMovement(_562)=true).
simpleFluent(trawlingMovement(_562)=false).
simpleFluent(sarMovement(_562)=false).

sDFluent(trawling(_684)=true).
sDFluent(inSAR(_684)=true).
sDFluent(proximity(_684,_686)=true).

index(entersArea(_704,_764),_704).
index(gap_start(_704),_704).
index(change_in_speed_start(_704),_704).
index(velocity(_704,_764,_766,_768),_704).
index(change_in_heading(_704),_704).
index(leavesArea(_704,_764),_704).
index(gap_end(_704),_704).
index(change_in_speed_end(_704),_704).
index(stop_start(_704),_704).
index(stop_end(_704),_704).
index(slow_motion_start(_704),_704).
index(slow_motion_end(_704),_704).
index(coord(_704,_764,_766),_704).
index(withinArea(_704,_770)=true,_704).
index(gap(_704)=nearPorts,_704).
index(gap(_704)=farFromPorts,_704).
index(changingSpeed(_704)=true,_704).
index(trawlSpeed(_704)=true,_704).
index(trawlingMovement(_704)=true,_704).
index(sarSpeed(_704)=true,_704).
index(sarMovement(_704)=true,_704).
index(trawlingMovement(_704)=false,_704).
index(sarMovement(_704)=false,_704).
index(trawling(_704)=true,_704).
index(inSAR(_704)=true,_704).
index(proximity(_704,_770)=true,_704).


cachingOrder2(_1112, withinArea(_1112,_1114)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_1112),areaType(_1114).

cachingOrder2(_1346, gap(_1346)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1346),portStatus(nearPorts).

cachingOrder2(_1324, gap(_1324)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1324),portStatus(farFromPorts).

cachingOrder2(_1286, trawlingMovement(_1286)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1286),vesselType(_1286,fishing).

cachingOrder2(_1286, trawlingMovement(_1286)=false) :- % level in dependency graph: 2, processing order in component: 2
     vessel(_1286),vesselType(_1286,fishing).

cachingOrder2(_1790, changingSpeed(_1790)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1790).

cachingOrder2(_1768, trawlSpeed(_1768)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1768),vesselType(_1768,fishing).

cachingOrder2(_1746, sarSpeed(_1746)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1746),vesselType(_1746,sar).

cachingOrder2(_2122, sarMovement(_2122)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2122),vesselType(_2122,sar).

cachingOrder2(_2122, sarMovement(_2122)=false) :- % level in dependency graph: 4, processing order in component: 2
     vessel(_2122),vesselType(_2122,sar).

cachingOrder2(_2100, trawling(_2100)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2100).

cachingOrder2(_2448, inSAR(_2448)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_2448).

collectGrounds([entersArea(_688,_702), gap_start(_688), change_in_speed_start(_688), velocity(_688,_702,_704,_706), change_in_heading(_688), leavesArea(_688,_702), gap_end(_688), change_in_speed_end(_688), stop_start(_688), stop_end(_688), slow_motion_start(_688), slow_motion_end(_688), coord(_688,_702,_704)],vessel(_688)).

collectGrounds([proximity(_676,_678)=true],vpair(_676,_678)).

dgrounded(withinArea(_1228,_1230)=true, vessel(_1228)).
dgrounded(gap(_1186)=nearPorts, vessel(_1186)).
dgrounded(gap(_1144)=farFromPorts, vessel(_1144)).
dgrounded(changingSpeed(_1112)=true, vessel(_1112)).
dgrounded(trawlSpeed(_1068)=true, vessel(_1068)).
dgrounded(trawlingMovement(_1024)=true, vessel(_1024)).
dgrounded(sarSpeed(_980)=true, vessel(_980)).
dgrounded(sarMovement(_936)=true, vessel(_936)).
dgrounded(trawlingMovement(_892)=false, vessel(_892)).
dgrounded(sarMovement(_848)=false, vessel(_848)).
dgrounded(trawling(_816)=true, vessel(_816)).
dgrounded(inSAR(_784)=true, vessel(_784)).
