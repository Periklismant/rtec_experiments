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

initiatedAt(stopped(_106)=nearPorts, _146, _76, _152) :-
     happensAtIE(stop_start(_106),_76),_146=<_76,_76<_152,
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,nearPorts)=true,_76).

initiatedAt(stopped(_106)=farFromPorts, _150, _76, _156) :-
     happensAtIE(stop_start(_106),_76),_150=<_76,_76<_156,
     \+holdsAtProcessedSimpleFluent(_106,withinArea(_106,nearPorts)=true,_76).

initiatedAt(lowSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(slow_motion_start(_106),_76),
     _122=<_76,
     _76<_128.

initiatedAt(changingSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(change_in_speed_start(_106),_76),
     _122=<_76,
     _76<_128.

initiatedAt(highSpeedNearCoast(_106)=true, _182, _76, _188) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_182=<_76,_76<_188,
     thresholds(hcNearCoastMax,_128),
     \+inRange(_112,0,_128),
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,nearCoast)=true,_76).

initiatedAt(movingSpeed(_106)=below, _182, _76, _188) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_182=<_76,_76<_188,
     vesselType(_106,_128),
     typeSpeed(_128,_134,_136,_138),
     thresholds(movingMin,_144),
     inRange(_112,_144,_134).

initiatedAt(movingSpeed(_106)=normal, _170, _76, _176) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_170=<_76,_76<_176,
     vesselType(_106,_128),
     typeSpeed(_128,_134,_136,_138),
     inRange(_112,_134,_136).

initiatedAt(movingSpeed(_106)=above, _170, _76, _176) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_170=<_76,_76<_176,
     vesselType(_106,_128),
     typeSpeed(_128,_134,_136,_138),
     inRange(_112,_136,inf).

initiatedAt(drifting(_106)=true, _206, _76, _212) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_206=<_76,_76<_212,
     _116=\=511.0,
     absoluteAngleDiff(_114,_116,_142),
     thresholds(adriftAngThr,_148),
     _142>_148,
     holdsAtProcessedSDFluent(_106,underWay(_106)=true,_76).

initiatedAt(tuggingSpeed(_106)=true, _166, _76, _172) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_166=<_76,_76<_172,
     thresholds(tuggingMin,_128),
     thresholds(tuggingMax,_134),
     inRange(_112,_128,_134).

initiatedAt(trawlSpeed(_106)=true, _190, _76, _196) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_190=<_76,_76<_196,
     thresholds(trawlspeedMin,_128),
     thresholds(trawlspeedMax,_134),
     inRange(_112,_128,_134),
     holdsAtProcessedSimpleFluent(_106,withinArea(_106,fishing)=true,_76).

initiatedAt(sarSpeed(_106)=true, _154, _76, _160) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_154=<_76,_76<_160,
     thresholds(sarMinSpeed,_128),
     inRange(_112,_128,inf).

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

terminatedAt(stopped(_106)=_82, _122, _76, _128) :-
     happensAtIE(stop_end(_106),_76),
     _122=<_76,
     _76<_128.

terminatedAt(stopped(_106)=_82, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(lowSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(slow_motion_end(_106),_76),
     _122=<_76,
     _76<_128.

terminatedAt(lowSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(changingSpeed(_106)=true, _122, _76, _128) :-
     happensAtIE(change_in_speed_end(_106),_76),
     _122=<_76,
     _76<_128.

terminatedAt(changingSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(highSpeedNearCoast(_106)=true, _154, _76, _160) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_154=<_76,_76<_160,
     thresholds(hcNearCoastMax,_128),
     inRange(_112,0,_128).

terminatedAt(highSpeedNearCoast(_106)=true, _134, _76, _140) :-
     happensAtProcessedSimpleFluent(_106,end(withinArea(_106,nearCoast)=true),_76),
     _134=<_76,
     _76<_140.

terminatedAt(movingSpeed(_106)=_82, _158, _76, _164) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_158=<_76,_76<_164,
     thresholds(movingMin,_128),
     \+inRange(_112,_128,inf).

terminatedAt(movingSpeed(_106)=_82, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

terminatedAt(drifting(_106)=true, _166, _76, _172) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_166=<_76,_76<_172,
     absoluteAngleDiff(_114,_116,_130),
     thresholds(adriftAngThr,_136),
     _130=<_136.

terminatedAt(drifting(_106)=true, _134, _76, _140) :-
     happensAtIE(velocity(_106,_112,_114,511.0),_76),
     _134=<_76,
     _76<_140.

terminatedAt(drifting(_106)=true, _132, _76, _138) :-
     happensAtProcessedSDFluent(_106,end(underWay(_106)=true),_76),
     _132=<_76,
     _76<_138.

terminatedAt(tuggingSpeed(_106)=true, _170, _76, _176) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_170=<_76,_76<_176,
     thresholds(tuggingMin,_128),
     thresholds(tuggingMax,_134),
     \+inRange(_112,_128,_134).

terminatedAt(tuggingSpeed(_106)=true, _132, _76, _138) :-
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

terminatedAt(sarSpeed(_106)=true, _154, _76, _160) :-
     happensAtIE(velocity(_106,_112,_114,_116),_76),_154=<_76,_76<_160,
     thresholds(sarMinSpeed,_128),
     inRange(_112,0,_128).

terminatedAt(sarSpeed(_106)=true, _132, _76, _138) :-
     happensAtProcessedSimpleFluent(_106,start(gap(_106)=_116),_76),
     _132=<_76,
     _76<_138.

holdsForSDFluent(underWay(_106)=true,_76) :-
     holdsForProcessedSimpleFluent(_106,movingSpeed(_106)=below,_122),
     holdsForProcessedSimpleFluent(_106,movingSpeed(_106)=normal,_138),
     holdsForProcessedSimpleFluent(_106,movingSpeed(_106)=above,_154),
     union_all([_122,_138,_154],_76).

holdsForSDFluent(anchoredOrMoored(_106)=true,_76) :-
     holdsForProcessedSimpleFluent(_106,stopped(_106)=farFromPorts,_122),
     holdsForProcessedSimpleFluent(_106,withinArea(_106,anchorage)=true,_140),
     intersect_all([_122,_140],_158),
     holdsForProcessedSimpleFluent(_106,stopped(_106)=nearPorts,_174),
     union_all([_158,_174],_192),
     thresholds(aOrMTime,_198),
     intDurGreater(_192,_198,_76).

holdsForSDFluent(tugging(_106,_108)=true,_76) :-
     holdsForProcessedIE(_106,proximity(_106,_108)=true,_126),
     oneIsTug(_106,_108),
     \+oneIsPilot(_106,_108),
     \+twoAreTugs(_106,_108),
     holdsForProcessedSimpleFluent(_106,tuggingSpeed(_106)=true,_168),
     holdsForProcessedSimpleFluent(_108,tuggingSpeed(_108)=true,_184),
     intersect_all([_126,_168,_184],_208),
     thresholds(tuggingTime,_214),
     intDurGreater(_208,_214,_76).

holdsForSDFluent(rendezVous(_106,_108)=true,_76) :-
     holdsForProcessedIE(_106,proximity(_106,_108)=true,_126),
     \+oneIsTug(_106,_108),
     \+oneIsPilot(_106,_108),
     holdsForProcessedSimpleFluent(_106,lowSpeed(_106)=true,_162),
     holdsForProcessedSimpleFluent(_108,lowSpeed(_108)=true,_178),
     holdsForProcessedSimpleFluent(_106,stopped(_106)=farFromPorts,_194),
     holdsForProcessedSimpleFluent(_108,stopped(_108)=farFromPorts,_210),
     union_all([_162,_194],_228),
     union_all([_178,_210],_246),
     intersect_all([_228,_246,_126],_270),
     _270\=[],
     holdsForProcessedSimpleFluent(_106,withinArea(_106,nearPorts)=true,_294),
     holdsForProcessedSimpleFluent(_108,withinArea(_108,nearPorts)=true,_312),
     holdsForProcessedSimpleFluent(_106,withinArea(_106,nearCoast)=true,_330),
     holdsForProcessedSimpleFluent(_108,withinArea(_108,nearCoast)=true,_348),
     relative_complement_all(_270,[_294,_312,_330,_348],_380),
     thresholds(rendezvousTime,_386),
     intDurGreater(_380,_386,_76).

holdsForSDFluent(loitering(_106)=true,_76) :-
     holdsForProcessedSimpleFluent(_106,lowSpeed(_106)=true,_122),
     holdsForProcessedSimpleFluent(_106,stopped(_106)=farFromPorts,_138),
     union_all([_122,_138],_156),
     holdsForProcessedSimpleFluent(_106,withinArea(_106,nearCoast)=true,_174),
     holdsForProcessedSDFluent(_106,anchoredOrMoored(_106)=true,_190),
     relative_complement_all(_156,[_174,_190],_210),
     thresholds(loiteringTime,_216),
     intDurGreater(_210,_216,_76).

holdsForSDFluent(pilotOps(_106,_108)=true,_76) :-
     holdsForProcessedIE(_106,proximity(_106,_108)=true,_126),
     oneIsPilot(_106,_108),
     holdsForProcessedSimpleFluent(_106,lowSpeed(_106)=true,_148),
     holdsForProcessedSimpleFluent(_108,lowSpeed(_108)=true,_164),
     holdsForProcessedSimpleFluent(_106,stopped(_106)=farFromPorts,_180),
     holdsForProcessedSimpleFluent(_108,stopped(_108)=farFromPorts,_196),
     union_all([_148,_180],_214),
     union_all([_164,_196],_232),
     intersect_all([_214,_232,_126],_256),
     _256\=[],
     holdsForProcessedSimpleFluent(_106,withinArea(_106,nearCoast)=true,_280),
     holdsForProcessedSimpleFluent(_108,withinArea(_108,nearCoast)=true,_298),
     relative_complement_all(_256,[_280,_298],_76).

collectIntervals2(_80, proximity(_80,_82)=true) :-
     vpair(_80,_82).

needsGrounding(_266,_268,_270) :- 
     fail.

grounding(change_in_speed_start(_412)) :- 
     vessel(_412).

grounding(change_in_speed_end(_412)) :- 
     vessel(_412).

grounding(change_in_heading(_412)) :- 
     vessel(_412).

grounding(stop_start(_412)) :- 
     vessel(_412).

grounding(stop_end(_412)) :- 
     vessel(_412).

grounding(slow_motion_start(_412)) :- 
     vessel(_412).

grounding(slow_motion_end(_412)) :- 
     vessel(_412).

grounding(gap_start(_412)) :- 
     vessel(_412).

grounding(gap_end(_412)) :- 
     vessel(_412).

grounding(entersArea(_412,_414)) :- 
     vessel(_412),areaType(_414).

grounding(leavesArea(_412,_414)) :- 
     vessel(_412),areaType(_414).

grounding(coord(_412,_414,_416)) :- 
     vessel(_412).

grounding(velocity(_412,_414,_416,_418)) :- 
     vessel(_412).

grounding(proximity(_418,_420)=true) :- 
     vpair(_418,_420).

grounding(gap(_418)=_414) :- 
     vessel(_418),portStatus(_414).

grounding(stopped(_418)=_414) :- 
     vessel(_418),portStatus(_414).

grounding(lowSpeed(_418)=true) :- 
     vessel(_418).

grounding(changingSpeed(_418)=true) :- 
     vessel(_418).

grounding(withinArea(_418,_420)=true) :- 
     vessel(_418),areaType(_420).

grounding(underWay(_418)=true) :- 
     vessel(_418).

grounding(sarSpeed(_418)=true) :- 
     vessel(_418),vesselType(_418,sar).

grounding(sarMovement(_418)=true) :- 
     vessel(_418),vesselType(_418,sar).

grounding(sarMovement(_418)=false) :- 
     vessel(_418),vesselType(_418,sar).

grounding(inSAR(_418)=true) :- 
     vessel(_418).

grounding(highSpeedNearCoast(_418)=true) :- 
     vessel(_418).

grounding(drifting(_418)=true) :- 
     vessel(_418).

grounding(anchoredOrMoored(_418)=true) :- 
     vessel(_418).

grounding(trawlSpeed(_418)=true) :- 
     vessel(_418),vesselType(_418,fishing).

grounding(movingSpeed(_418)=_414) :- 
     vessel(_418),movingStatus(_414).

grounding(pilotOps(_418,_420)=true) :- 
     vpair(_418,_420).

grounding(tuggingSpeed(_418)=true) :- 
     vessel(_418).

grounding(tugging(_418,_420)=true) :- 
     vpair(_418,_420).

grounding(rendezVous(_418,_420)=true) :- 
     vpair(_418,_420).

grounding(trawlingMovement(_418)=true) :- 
     vessel(_418),vesselType(_418,fishing).

grounding(trawlingMovement(_418)=false) :- 
     vessel(_418),vesselType(_418,fishing).

grounding(trawling(_418)=true) :- 
     vessel(_418).

grounding(loitering(_418)=true) :- 
     vessel(_418).

inputEntity(entersArea(_136,_138)).
inputEntity(gap_start(_136)).
inputEntity(stop_start(_136)).
inputEntity(slow_motion_start(_136)).
inputEntity(change_in_speed_start(_136)).
inputEntity(velocity(_136,_138,_140,_142)).
inputEntity(leavesArea(_136,_138)).
inputEntity(gap_end(_136)).
inputEntity(stop_end(_136)).
inputEntity(slow_motion_end(_136)).
inputEntity(change_in_speed_end(_136)).
inputEntity(proximity(_142,_144)=true).
inputEntity(change_in_heading(_136)).
inputEntity(coord(_136,_138,_140)).
inputEntity(sarMovement(_142)=true).
inputEntity(sarMovement(_142)=false).
inputEntity(inSAR(_142)=true).
inputEntity(trawlingMovement(_142)=true).
inputEntity(trawlingMovement(_142)=false).
inputEntity(trawling(_142)=true).

outputEntity(withinArea(_324,_326)=true).
outputEntity(gap(_324)=nearPorts).
outputEntity(gap(_324)=farFromPorts).
outputEntity(stopped(_324)=nearPorts).
outputEntity(stopped(_324)=farFromPorts).
outputEntity(lowSpeed(_324)=true).
outputEntity(changingSpeed(_324)=true).
outputEntity(highSpeedNearCoast(_324)=true).
outputEntity(movingSpeed(_324)=below).
outputEntity(movingSpeed(_324)=normal).
outputEntity(movingSpeed(_324)=above).
outputEntity(drifting(_324)=true).
outputEntity(tuggingSpeed(_324)=true).
outputEntity(trawlSpeed(_324)=true).
outputEntity(sarSpeed(_324)=true).
outputEntity(underWay(_324)=true).
outputEntity(anchoredOrMoored(_324)=true).
outputEntity(tugging(_324,_326)=true).
outputEntity(rendezVous(_324,_326)=true).
outputEntity(loitering(_324)=true).
outputEntity(pilotOps(_324,_326)=true).

event(entersArea(_506,_508)).
event(gap_start(_506)).
event(stop_start(_506)).
event(slow_motion_start(_506)).
event(change_in_speed_start(_506)).
event(velocity(_506,_508,_510,_512)).
event(leavesArea(_506,_508)).
event(gap_end(_506)).
event(stop_end(_506)).
event(slow_motion_end(_506)).
event(change_in_speed_end(_506)).
event(change_in_heading(_506)).
event(coord(_506,_508,_510)).

simpleFluent(withinArea(_652,_654)=true).
simpleFluent(gap(_652)=nearPorts).
simpleFluent(gap(_652)=farFromPorts).
simpleFluent(stopped(_652)=nearPorts).
simpleFluent(stopped(_652)=farFromPorts).
simpleFluent(lowSpeed(_652)=true).
simpleFluent(changingSpeed(_652)=true).
simpleFluent(highSpeedNearCoast(_652)=true).
simpleFluent(movingSpeed(_652)=below).
simpleFluent(movingSpeed(_652)=normal).
simpleFluent(movingSpeed(_652)=above).
simpleFluent(drifting(_652)=true).
simpleFluent(tuggingSpeed(_652)=true).
simpleFluent(trawlSpeed(_652)=true).
simpleFluent(sarSpeed(_652)=true).

sDFluent(underWay(_804)=true).
sDFluent(anchoredOrMoored(_804)=true).
sDFluent(tugging(_804,_806)=true).
sDFluent(rendezVous(_804,_806)=true).
sDFluent(loitering(_804)=true).
sDFluent(pilotOps(_804,_806)=true).
sDFluent(proximity(_804,_806)=true).
sDFluent(sarMovement(_804)=true).
sDFluent(sarMovement(_804)=false).
sDFluent(inSAR(_804)=true).
sDFluent(trawlingMovement(_804)=true).
sDFluent(trawlingMovement(_804)=false).
sDFluent(trawling(_804)=true).

index(entersArea(_884,_944),_884).
index(gap_start(_884),_884).
index(stop_start(_884),_884).
index(slow_motion_start(_884),_884).
index(change_in_speed_start(_884),_884).
index(velocity(_884,_944,_946,_948),_884).
index(leavesArea(_884,_944),_884).
index(gap_end(_884),_884).
index(stop_end(_884),_884).
index(slow_motion_end(_884),_884).
index(change_in_speed_end(_884),_884).
index(change_in_heading(_884),_884).
index(coord(_884,_944,_946),_884).
index(withinArea(_884,_950)=true,_884).
index(gap(_884)=nearPorts,_884).
index(gap(_884)=farFromPorts,_884).
index(stopped(_884)=nearPorts,_884).
index(stopped(_884)=farFromPorts,_884).
index(lowSpeed(_884)=true,_884).
index(changingSpeed(_884)=true,_884).
index(highSpeedNearCoast(_884)=true,_884).
index(movingSpeed(_884)=below,_884).
index(movingSpeed(_884)=normal,_884).
index(movingSpeed(_884)=above,_884).
index(drifting(_884)=true,_884).
index(tuggingSpeed(_884)=true,_884).
index(trawlSpeed(_884)=true,_884).
index(sarSpeed(_884)=true,_884).
index(underWay(_884)=true,_884).
index(anchoredOrMoored(_884)=true,_884).
index(tugging(_884,_950)=true,_884).
index(rendezVous(_884,_950)=true,_884).
index(loitering(_884)=true,_884).
index(pilotOps(_884,_950)=true,_884).
index(proximity(_884,_950)=true,_884).
index(sarMovement(_884)=true,_884).
index(sarMovement(_884)=false,_884).
index(inSAR(_884)=true,_884).
index(trawlingMovement(_884)=true,_884).
index(trawlingMovement(_884)=false,_884).
index(trawling(_884)=true,_884).


cachingOrder2(_1382, withinArea(_1382,_1384)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_1382),areaType(_1384).

cachingOrder2(_1600, gap(_1600)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1600),portStatus(nearPorts).

cachingOrder2(_1578, gap(_1578)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1578),portStatus(farFromPorts).

cachingOrder2(_1556, highSpeedNearCoast(_1556)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1556).

cachingOrder2(_2104, stopped(_2104)=nearPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2104),portStatus(nearPorts).

cachingOrder2(_2082, stopped(_2082)=farFromPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2082),portStatus(farFromPorts).

cachingOrder2(_2060, lowSpeed(_2060)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2060).

cachingOrder2(_2038, changingSpeed(_2038)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2038).

cachingOrder2(_2016, movingSpeed(_2016)=below) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2016),movingStatus(below).

cachingOrder2(_1994, movingSpeed(_1994)=normal) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1994),movingStatus(normal).

cachingOrder2(_1972, movingSpeed(_1972)=above) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1972),movingStatus(above).

cachingOrder2(_1950, tuggingSpeed(_1950)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1950).

cachingOrder2(_1928, trawlSpeed(_1928)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1928),vesselType(_1928,fishing).

cachingOrder2(_1906, sarSpeed(_1906)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1906),vesselType(_1906,sar).

cachingOrder2(_3048, underWay(_3048)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3048).

cachingOrder2(_3026, anchoredOrMoored(_3026)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3026).

cachingOrder2(_3002, tugging(_3002,_3004)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_3002,_3004).

cachingOrder2(_2978, rendezVous(_2978,_2980)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2978,_2980).

cachingOrder2(_2954, pilotOps(_2954,_2956)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2954,_2956).

cachingOrder2(_3550, drifting(_3550)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3550).

cachingOrder2(_3528, loitering(_3528)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3528).

collectGrounds([entersArea(_964,_978), gap_start(_964), stop_start(_964), slow_motion_start(_964), change_in_speed_start(_964), velocity(_964,_978,_980,_982), leavesArea(_964,_978), gap_end(_964), stop_end(_964), slow_motion_end(_964), change_in_speed_end(_964), change_in_heading(_964), coord(_964,_978,_980), sarMovement(_964)=true, sarMovement(_964)=false, inSAR(_964)=true, trawlingMovement(_964)=true, trawlingMovement(_964)=false, trawling(_964)=true],vessel(_964)).

collectGrounds([proximity(_952,_954)=true],vpair(_952,_954)).

dgrounded(withinArea(_1806,_1808)=true, vessel(_1806)).
dgrounded(gap(_1764)=nearPorts, vessel(_1764)).
dgrounded(gap(_1722)=farFromPorts, vessel(_1722)).
dgrounded(stopped(_1680)=nearPorts, vessel(_1680)).
dgrounded(stopped(_1638)=farFromPorts, vessel(_1638)).
dgrounded(lowSpeed(_1606)=true, vessel(_1606)).
dgrounded(changingSpeed(_1574)=true, vessel(_1574)).
dgrounded(highSpeedNearCoast(_1542)=true, vessel(_1542)).
dgrounded(movingSpeed(_1500)=below, vessel(_1500)).
dgrounded(movingSpeed(_1458)=normal, vessel(_1458)).
dgrounded(movingSpeed(_1416)=above, vessel(_1416)).
dgrounded(drifting(_1384)=true, vessel(_1384)).
dgrounded(tuggingSpeed(_1352)=true, vessel(_1352)).
dgrounded(trawlSpeed(_1308)=true, vessel(_1308)).
dgrounded(sarSpeed(_1264)=true, vessel(_1264)).
dgrounded(underWay(_1232)=true, vessel(_1232)).
dgrounded(anchoredOrMoored(_1200)=true, vessel(_1200)).
dgrounded(tugging(_1164,_1166)=true, vpair(_1164,_1166)).
dgrounded(rendezVous(_1128,_1130)=true, vpair(_1128,_1130)).
dgrounded(loitering(_1096)=true, vessel(_1096)).
dgrounded(pilotOps(_1060,_1062)=true, vpair(_1060,_1062)).
