:- dynamic vessel/1, vpair/2.

initiatedAt(withinArea(_110,_112)=true, _142, _80, _148) :-
     happensAtIE(entersArea(_110,_118),_80),_142=<_80,_80<_148,
     areaType(_118,_112).

initiatedAt(gap(_110)=nearPorts, _150, _80, _156) :-
     happensAtIE(gap_start(_110),_80),_150=<_80,_80<_156,
     holdsAtProcessedSimpleFluent(_110,withinArea(_110,nearPorts)=true,_80).

initiatedAt(gap(_110)=farFromPorts, _154, _80, _160) :-
     happensAtIE(gap_start(_110),_80),_154=<_80,_80<_160,
     \+holdsAtProcessedSimpleFluent(_110,withinArea(_110,nearPorts)=true,_80).

initiatedAt(stopped(_110)=nearPorts, _150, _80, _156) :-
     happensAtIE(stop_start(_110),_80),_150=<_80,_80<_156,
     holdsAtProcessedSimpleFluent(_110,withinArea(_110,nearPorts)=true,_80).

initiatedAt(stopped(_110)=farFromPorts, _154, _80, _160) :-
     happensAtIE(stop_start(_110),_80),_154=<_80,_80<_160,
     \+holdsAtProcessedSimpleFluent(_110,withinArea(_110,nearPorts)=true,_80).

initiatedAt(lowSpeed(_110)=true, _126, _80, _132) :-
     happensAtIE(slow_motion_start(_110),_80),
     _126=<_80,
     _80<_132.

initiatedAt(changingSpeed(_110)=true, _126, _80, _132) :-
     happensAtIE(change_in_speed_start(_110),_80),
     _126=<_80,
     _80<_132.

initiatedAt(highSpeedNearCoast(_110)=true, _186, _80, _192) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_186=<_80,_80<_192,
     thresholds(hcNearCoastMax,_132),
     \+inRange(_116,0,_132),
     holdsAtProcessedSimpleFluent(_110,withinArea(_110,nearCoast)=true,_80).

initiatedAt(movingSpeed(_110)=below, _186, _80, _192) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_186=<_80,_80<_192,
     vesselType(_110,_132),
     typeSpeed(_132,_138,_140,_142),
     thresholds(movingMin,_148),
     inRange(_116,_148,_138).

initiatedAt(movingSpeed(_110)=normal, _174, _80, _180) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_174=<_80,_80<_180,
     vesselType(_110,_132),
     typeSpeed(_132,_138,_140,_142),
     inRange(_116,_138,_140).

initiatedAt(movingSpeed(_110)=above, _174, _80, _180) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_174=<_80,_80<_180,
     vesselType(_110,_132),
     typeSpeed(_132,_138,_140,_142),
     inRange(_116,_140,inf).

initiatedAt(drifting(_110)=true, _210, _80, _216) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_210=<_80,_80<_216,
     _120=\=511.0,
     absoluteAngleDiff(_118,_120,_146),
     thresholds(adriftAngThr,_152),
     _146>_152,
     holdsAtProcessedSDFluent(_110,underWay(_110)=true,_80).

initiatedAt(tuggingSpeed(_110)=true, _170, _80, _176) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_170=<_80,_80<_176,
     thresholds(tuggingMin,_132),
     thresholds(tuggingMax,_138),
     inRange(_116,_132,_138).

initiatedAt(trawlSpeed(_110)=true, _194, _80, _200) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_194=<_80,_80<_200,
     thresholds(trawlspeedMin,_132),
     thresholds(trawlspeedMax,_138),
     inRange(_116,_132,_138),
     holdsAtProcessedSimpleFluent(_110,withinArea(_110,fishing)=true,_80).

initiatedAt(sarSpeed(_110)=true, _158, _80, _164) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_158=<_80,_80<_164,
     thresholds(sarMinSpeed,_132),
     inRange(_116,_132,inf).

terminatedAt(withinArea(_110,_112)=true, _142, _80, _148) :-
     happensAtIE(leavesArea(_110,_118),_80),_142=<_80,_80<_148,
     areaType(_118,_112).

terminatedAt(withinArea(_110,_112)=true, _128, _80, _134) :-
     happensAtIE(gap_start(_110),_80),
     _128=<_80,
     _80<_134.

terminatedAt(gap(_110)=_86, _126, _80, _132) :-
     happensAtIE(gap_end(_110),_80),
     _126=<_80,
     _80<_132.

terminatedAt(stopped(_110)=_86, _126, _80, _132) :-
     happensAtIE(stop_end(_110),_80),
     _126=<_80,
     _80<_132.

terminatedAt(stopped(_110)=_86, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(lowSpeed(_110)=true, _126, _80, _132) :-
     happensAtIE(slow_motion_end(_110),_80),
     _126=<_80,
     _80<_132.

terminatedAt(lowSpeed(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(changingSpeed(_110)=true, _126, _80, _132) :-
     happensAtIE(change_in_speed_end(_110),_80),
     _126=<_80,
     _80<_132.

terminatedAt(changingSpeed(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(highSpeedNearCoast(_110)=true, _158, _80, _164) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_158=<_80,_80<_164,
     thresholds(hcNearCoastMax,_132),
     inRange(_116,0,_132).

terminatedAt(highSpeedNearCoast(_110)=true, _138, _80, _144) :-
     happensAtProcessedSimpleFluent(_110,end(withinArea(_110,nearCoast)=true),_80),
     _138=<_80,
     _80<_144.

terminatedAt(movingSpeed(_110)=_86, _162, _80, _168) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_162=<_80,_80<_168,
     thresholds(movingMin,_132),
     \+inRange(_116,_132,inf).

terminatedAt(movingSpeed(_110)=_86, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(drifting(_110)=true, _170, _80, _176) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_170=<_80,_80<_176,
     absoluteAngleDiff(_118,_120,_134),
     thresholds(adriftAngThr,_140),
     _134=<_140.

terminatedAt(drifting(_110)=true, _138, _80, _144) :-
     happensAtIE(velocity(_110,_116,_118,511.0),_80),
     _138=<_80,
     _80<_144.

terminatedAt(drifting(_110)=true, _136, _80, _142) :-
     happensAtProcessedSDFluent(_110,end(underWay(_110)=true),_80),
     _136=<_80,
     _80<_142.

terminatedAt(tuggingSpeed(_110)=true, _174, _80, _180) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_174=<_80,_80<_180,
     thresholds(tuggingMin,_132),
     thresholds(tuggingMax,_138),
     \+inRange(_116,_132,_138).

terminatedAt(tuggingSpeed(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(trawlSpeed(_110)=true, _174, _80, _180) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_174=<_80,_80<_180,
     thresholds(trawlspeedMin,_132),
     thresholds(trawlspeedMax,_138),
     \+inRange(_116,_132,_138).

terminatedAt(trawlSpeed(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

terminatedAt(trawlSpeed(_110)=true, _138, _80, _144) :-
     happensAtProcessedSimpleFluent(_110,end(withinArea(_110,fishing)=true),_80),
     _138=<_80,
     _80<_144.

terminatedAt(sarSpeed(_110)=true, _158, _80, _164) :-
     happensAtIE(velocity(_110,_116,_118,_120),_80),_158=<_80,_80<_164,
     thresholds(sarMinSpeed,_132),
     inRange(_116,0,_132).

terminatedAt(sarSpeed(_110)=true, _136, _80, _142) :-
     happensAtProcessedSimpleFluent(_110,start(gap(_110)=_120),_80),
     _136=<_80,
     _80<_142.

holdsForSDFluent(underWay(_110)=true,_80) :-
     holdsForProcessedSimpleFluent(_110,movingSpeed(_110)=below,_126),
     holdsForProcessedSimpleFluent(_110,movingSpeed(_110)=normal,_142),
     holdsForProcessedSimpleFluent(_110,movingSpeed(_110)=above,_158),
     union_all([_126,_142,_158],_80).

holdsForSDFluent(anchoredOrMoored(_110)=true,_80) :-
     holdsForProcessedSimpleFluent(_110,stopped(_110)=farFromPorts,_126),
     holdsForProcessedSimpleFluent(_110,withinArea(_110,anchorage)=true,_144),
     intersect_all([_126,_144],_162),
     holdsForProcessedSimpleFluent(_110,stopped(_110)=nearPorts,_178),
     union_all([_162,_178],_196),
     thresholds(aOrMTime,_202),
     intDurGreater(_196,_202,_80).

holdsForSDFluent(tugging(_110,_112)=true,_80) :-
     holdsForProcessedIE(_110,proximity(_110,_112)=true,_130),
     oneIsTug(_110,_112),
     \+oneIsPilot(_110,_112),
     \+twoAreTugs(_110,_112),
     holdsForProcessedSimpleFluent(_110,tuggingSpeed(_110)=true,_172),
     holdsForProcessedSimpleFluent(_112,tuggingSpeed(_112)=true,_188),
     intersect_all([_130,_172,_188],_212),
     thresholds(tuggingTime,_218),
     intDurGreater(_212,_218,_80).

holdsForSDFluent(rendezVous(_110,_112)=true,_80) :-
     holdsForProcessedIE(_110,proximity(_110,_112)=true,_130),
     \+oneIsTug(_110,_112),
     \+oneIsPilot(_110,_112),
     holdsForProcessedSimpleFluent(_110,lowSpeed(_110)=true,_166),
     holdsForProcessedSimpleFluent(_112,lowSpeed(_112)=true,_182),
     holdsForProcessedSimpleFluent(_110,stopped(_110)=farFromPorts,_198),
     holdsForProcessedSimpleFluent(_112,stopped(_112)=farFromPorts,_214),
     union_all([_166,_198],_232),
     union_all([_182,_214],_250),
     intersect_all([_232,_250,_130],_274),
     _274\=[],
     holdsForProcessedSimpleFluent(_110,withinArea(_110,nearPorts)=true,_298),
     holdsForProcessedSimpleFluent(_112,withinArea(_112,nearPorts)=true,_316),
     holdsForProcessedSimpleFluent(_110,withinArea(_110,nearCoast)=true,_334),
     holdsForProcessedSimpleFluent(_112,withinArea(_112,nearCoast)=true,_352),
     relative_complement_all(_274,[_298,_316,_334,_352],_384),
     thresholds(rendezvousTime,_390),
     intDurGreater(_384,_390,_80).

holdsForSDFluent(loitering(_110)=true,_80) :-
     holdsForProcessedSimpleFluent(_110,lowSpeed(_110)=true,_126),
     holdsForProcessedSimpleFluent(_110,stopped(_110)=farFromPorts,_142),
     union_all([_126,_142],_160),
     holdsForProcessedSimpleFluent(_110,withinArea(_110,nearCoast)=true,_178),
     holdsForProcessedSDFluent(_110,anchoredOrMoored(_110)=true,_194),
     relative_complement_all(_160,[_178,_194],_214),
     thresholds(loiteringTime,_220),
     intDurGreater(_214,_220,_80).

holdsForSDFluent(pilotOps(_110,_112)=true,_80) :-
     holdsForProcessedIE(_110,proximity(_110,_112)=true,_130),
     oneIsPilot(_110,_112),
     holdsForProcessedSimpleFluent(_110,lowSpeed(_110)=true,_152),
     holdsForProcessedSimpleFluent(_112,lowSpeed(_112)=true,_168),
     holdsForProcessedSimpleFluent(_110,stopped(_110)=farFromPorts,_184),
     holdsForProcessedSimpleFluent(_112,stopped(_112)=farFromPorts,_200),
     union_all([_152,_184],_218),
     union_all([_168,_200],_236),
     intersect_all([_218,_236,_130],_260),
     _260\=[],
     holdsForProcessedSimpleFluent(_110,withinArea(_110,nearCoast)=true,_284),
     holdsForProcessedSimpleFluent(_112,withinArea(_112,nearCoast)=true,_302),
     relative_complement_all(_260,[_284,_302],_80).

collectIntervals2(_84, proximity(_84,_86)=true) :-
     vpair(_84,_86).

needsGrounding(_298,_300,_302) :- 
     fail.

grounding(change_in_speed_start(_444)) :- 
     vessel(_444).

grounding(change_in_speed_end(_444)) :- 
     vessel(_444).

grounding(change_in_heading(_444)) :- 
     vessel(_444).

grounding(stop_start(_444)) :- 
     vessel(_444).

grounding(stop_end(_444)) :- 
     vessel(_444).

grounding(slow_motion_start(_444)) :- 
     vessel(_444).

grounding(slow_motion_end(_444)) :- 
     vessel(_444).

grounding(gap_start(_444)) :- 
     vessel(_444).

grounding(gap_end(_444)) :- 
     vessel(_444).

grounding(entersArea(_444,_446)) :- 
     vessel(_444),areaType(_446).

grounding(leavesArea(_444,_446)) :- 
     vessel(_444),areaType(_446).

grounding(coord(_444,_446,_448)) :- 
     vessel(_444).

grounding(velocity(_444,_446,_448,_450)) :- 
     vessel(_444).

grounding(proximity(_450,_452)=true) :- 
     vpair(_450,_452).

grounding(gap(_450)=_446) :- 
     vessel(_450),portStatus(_446).

grounding(stopped(_450)=_446) :- 
     vessel(_450),portStatus(_446).

grounding(lowSpeed(_450)=true) :- 
     vessel(_450).

grounding(changingSpeed(_450)=true) :- 
     vessel(_450).

grounding(withinArea(_450,_452)=true) :- 
     vessel(_450),areaType(_452).

grounding(underWay(_450)=true) :- 
     vessel(_450).

grounding(sarSpeed(_450)=true) :- 
     vessel(_450),vesselType(_450,sar).

grounding(sarMovement(_450)=true) :- 
     vessel(_450),vesselType(_450,sar).

grounding(sarMovement(_450)=false) :- 
     vessel(_450),vesselType(_450,sar).

grounding(inSAR(_450)=true) :- 
     vessel(_450).

grounding(highSpeedNearCoast(_450)=true) :- 
     vessel(_450).

grounding(drifting(_450)=true) :- 
     vessel(_450).

grounding(anchoredOrMoored(_450)=true) :- 
     vessel(_450).

grounding(trawlSpeed(_450)=true) :- 
     vessel(_450),vesselType(_450,fishing).

grounding(movingSpeed(_450)=_446) :- 
     vessel(_450),movingStatus(_446).

grounding(pilotOps(_450,_452)=true) :- 
     vpair(_450,_452).

grounding(tuggingSpeed(_450)=true) :- 
     vessel(_450).

grounding(tugging(_450,_452)=true) :- 
     vpair(_450,_452).

grounding(rendezVous(_450,_452)=true) :- 
     vpair(_450,_452).

grounding(trawlingMovement(_450)=true) :- 
     vessel(_450),vesselType(_450,fishing).

grounding(trawlingMovement(_450)=false) :- 
     vessel(_450),vesselType(_450,fishing).

grounding(trawling(_450)=true) :- 
     vessel(_450).

grounding(loitering(_450)=true) :- 
     vessel(_450).

inputEntity(entersArea(_134,_136)).
inputEntity(gap_start(_134)).
inputEntity(stop_start(_134)).
inputEntity(slow_motion_start(_134)).
inputEntity(change_in_speed_start(_134)).
inputEntity(velocity(_134,_136,_138,_140)).
inputEntity(leavesArea(_134,_136)).
inputEntity(gap_end(_134)).
inputEntity(stop_end(_134)).
inputEntity(slow_motion_end(_134)).
inputEntity(change_in_speed_end(_134)).
inputEntity(proximity(_140,_142)=true).
inputEntity(change_in_heading(_134)).
inputEntity(coord(_134,_136,_138)).
inputEntity(sarMovement(_140)=true).
inputEntity(sarMovement(_140)=false).
inputEntity(inSAR(_140)=true).
inputEntity(trawlingMovement(_140)=true).
inputEntity(trawlingMovement(_140)=false).
inputEntity(trawling(_140)=true).

outputEntity(withinArea(_316,_318)=true).
outputEntity(gap(_316)=nearPorts).
outputEntity(gap(_316)=farFromPorts).
outputEntity(stopped(_316)=nearPorts).
outputEntity(stopped(_316)=farFromPorts).
outputEntity(lowSpeed(_316)=true).
outputEntity(changingSpeed(_316)=true).
outputEntity(highSpeedNearCoast(_316)=true).
outputEntity(movingSpeed(_316)=below).
outputEntity(movingSpeed(_316)=normal).
outputEntity(movingSpeed(_316)=above).
outputEntity(drifting(_316)=true).
outputEntity(tuggingSpeed(_316)=true).
outputEntity(trawlSpeed(_316)=true).
outputEntity(sarSpeed(_316)=true).
outputEntity(underWay(_316)=true).
outputEntity(anchoredOrMoored(_316)=true).
outputEntity(tugging(_316,_318)=true).
outputEntity(rendezVous(_316,_318)=true).
outputEntity(loitering(_316)=true).
outputEntity(pilotOps(_316,_318)=true).

event(entersArea(_492,_494)).
event(gap_start(_492)).
event(stop_start(_492)).
event(slow_motion_start(_492)).
event(change_in_speed_start(_492)).
event(velocity(_492,_494,_496,_498)).
event(leavesArea(_492,_494)).
event(gap_end(_492)).
event(stop_end(_492)).
event(slow_motion_end(_492)).
event(change_in_speed_end(_492)).
event(change_in_heading(_492)).
event(coord(_492,_494,_496)).

simpleFluent(withinArea(_632,_634)=true).
simpleFluent(gap(_632)=nearPorts).
simpleFluent(gap(_632)=farFromPorts).
simpleFluent(stopped(_632)=nearPorts).
simpleFluent(stopped(_632)=farFromPorts).
simpleFluent(lowSpeed(_632)=true).
simpleFluent(changingSpeed(_632)=true).
simpleFluent(highSpeedNearCoast(_632)=true).
simpleFluent(movingSpeed(_632)=below).
simpleFluent(movingSpeed(_632)=normal).
simpleFluent(movingSpeed(_632)=above).
simpleFluent(drifting(_632)=true).
simpleFluent(tuggingSpeed(_632)=true).
simpleFluent(trawlSpeed(_632)=true).
simpleFluent(sarSpeed(_632)=true).

sDFluent(underWay(_778)=true).
sDFluent(anchoredOrMoored(_778)=true).
sDFluent(tugging(_778,_780)=true).
sDFluent(rendezVous(_778,_780)=true).
sDFluent(loitering(_778)=true).
sDFluent(pilotOps(_778,_780)=true).
sDFluent(proximity(_778,_780)=true).
sDFluent(sarMovement(_778)=true).
sDFluent(sarMovement(_778)=false).
sDFluent(inSAR(_778)=true).
sDFluent(trawlingMovement(_778)=true).
sDFluent(trawlingMovement(_778)=false).
sDFluent(trawling(_778)=true).

index(entersArea(_858,_912),_858).
index(gap_start(_858),_858).
index(stop_start(_858),_858).
index(slow_motion_start(_858),_858).
index(change_in_speed_start(_858),_858).
index(velocity(_858,_912,_914,_916),_858).
index(leavesArea(_858,_912),_858).
index(gap_end(_858),_858).
index(stop_end(_858),_858).
index(slow_motion_end(_858),_858).
index(change_in_speed_end(_858),_858).
index(change_in_heading(_858),_858).
index(coord(_858,_912,_914),_858).
index(withinArea(_858,_918)=true,_858).
index(gap(_858)=nearPorts,_858).
index(gap(_858)=farFromPorts,_858).
index(stopped(_858)=nearPorts,_858).
index(stopped(_858)=farFromPorts,_858).
index(lowSpeed(_858)=true,_858).
index(changingSpeed(_858)=true,_858).
index(highSpeedNearCoast(_858)=true,_858).
index(movingSpeed(_858)=below,_858).
index(movingSpeed(_858)=normal,_858).
index(movingSpeed(_858)=above,_858).
index(drifting(_858)=true,_858).
index(tuggingSpeed(_858)=true,_858).
index(trawlSpeed(_858)=true,_858).
index(sarSpeed(_858)=true,_858).
index(underWay(_858)=true,_858).
index(anchoredOrMoored(_858)=true,_858).
index(tugging(_858,_918)=true,_858).
index(rendezVous(_858,_918)=true,_858).
index(loitering(_858)=true,_858).
index(pilotOps(_858,_918)=true,_858).
index(proximity(_858,_918)=true,_858).
index(sarMovement(_858)=true,_858).
index(sarMovement(_858)=false,_858).
index(inSAR(_858)=true,_858).
index(trawlingMovement(_858)=true,_858).
index(trawlingMovement(_858)=false,_858).
index(trawling(_858)=true,_858).


cachingOrder2(_1338, withinArea(_1338,_1340)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_1338),areaType(_1340).

cachingOrder2(_1550, gap(_1550)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1550),portStatus(nearPorts).

cachingOrder2(_1528, gap(_1528)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1528),portStatus(farFromPorts).

cachingOrder2(_1506, highSpeedNearCoast(_1506)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1506).

cachingOrder2(_2048, stopped(_2048)=nearPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2048),portStatus(nearPorts).

cachingOrder2(_2026, stopped(_2026)=farFromPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2026),portStatus(farFromPorts).

cachingOrder2(_2004, lowSpeed(_2004)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2004).

cachingOrder2(_1982, changingSpeed(_1982)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1982).

cachingOrder2(_1960, movingSpeed(_1960)=below) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1960),movingStatus(below).

cachingOrder2(_1938, movingSpeed(_1938)=normal) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1938),movingStatus(normal).

cachingOrder2(_1916, movingSpeed(_1916)=above) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1916),movingStatus(above).

cachingOrder2(_1894, tuggingSpeed(_1894)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1894).

cachingOrder2(_1872, trawlSpeed(_1872)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1872),vesselType(_1872,fishing).

cachingOrder2(_1850, sarSpeed(_1850)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1850),vesselType(_1850,sar).

cachingOrder2(_2986, underWay(_2986)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2986).

cachingOrder2(_2964, anchoredOrMoored(_2964)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2964).

cachingOrder2(_2940, tugging(_2940,_2942)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2940,_2942).

cachingOrder2(_2916, rendezVous(_2916,_2918)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2916,_2918).

cachingOrder2(_2892, pilotOps(_2892,_2894)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2892,_2894).

cachingOrder2(_3482, drifting(_3482)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3482).

cachingOrder2(_3460, loitering(_3460)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3460).

collectGrounds([entersArea(_956,_970), gap_start(_956), stop_start(_956), slow_motion_start(_956), change_in_speed_start(_956), velocity(_956,_970,_972,_974), leavesArea(_956,_970), gap_end(_956), stop_end(_956), slow_motion_end(_956), change_in_speed_end(_956), change_in_heading(_956), coord(_956,_970,_972), sarMovement(_956)=true, sarMovement(_956)=false, inSAR(_956)=true, trawlingMovement(_956)=true, trawlingMovement(_956)=false, trawling(_956)=true],vessel(_956)).

collectGrounds([proximity(_944,_946)=true],vpair(_944,_946)).

dgrounded(withinArea(_1792,_1794)=true, vessel(_1792)).
dgrounded(gap(_1750)=nearPorts, vessel(_1750)).
dgrounded(gap(_1708)=farFromPorts, vessel(_1708)).
dgrounded(stopped(_1666)=nearPorts, vessel(_1666)).
dgrounded(stopped(_1624)=farFromPorts, vessel(_1624)).
dgrounded(lowSpeed(_1592)=true, vessel(_1592)).
dgrounded(changingSpeed(_1560)=true, vessel(_1560)).
dgrounded(highSpeedNearCoast(_1528)=true, vessel(_1528)).
dgrounded(movingSpeed(_1486)=below, vessel(_1486)).
dgrounded(movingSpeed(_1444)=normal, vessel(_1444)).
dgrounded(movingSpeed(_1402)=above, vessel(_1402)).
dgrounded(drifting(_1370)=true, vessel(_1370)).
dgrounded(tuggingSpeed(_1338)=true, vessel(_1338)).
dgrounded(trawlSpeed(_1294)=true, vessel(_1294)).
dgrounded(sarSpeed(_1250)=true, vessel(_1250)).
dgrounded(underWay(_1218)=true, vessel(_1218)).
dgrounded(anchoredOrMoored(_1186)=true, vessel(_1186)).
dgrounded(tugging(_1150,_1152)=true, vpair(_1150,_1152)).
dgrounded(rendezVous(_1114,_1116)=true, vpair(_1114,_1116)).
dgrounded(loitering(_1082)=true, vessel(_1082)).
dgrounded(pilotOps(_1046,_1048)=true, vpair(_1046,_1048)).
