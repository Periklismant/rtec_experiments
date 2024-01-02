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

grounding(stopped(_454)=_450) :- 
     vessel(_454),portStatus(_450).

grounding(lowSpeed(_454)=true) :- 
     vessel(_454).

grounding(changingSpeed(_454)=true) :- 
     vessel(_454).

grounding(withinArea(_454,_456)=true) :- 
     vessel(_454),areaType(_456).

grounding(underWay(_454)=true) :- 
     vessel(_454).

grounding(sarSpeed(_454)=true) :- 
     vessel(_454),vesselType(_454,sar).

grounding(sarMovement(_454)=true) :- 
     vessel(_454),vesselType(_454,sar).

grounding(sarMovement(_454)=false) :- 
     vessel(_454),vesselType(_454,sar).

grounding(inSAR(_454)=true) :- 
     vessel(_454).

grounding(highSpeedNearCoast(_454)=true) :- 
     vessel(_454).

grounding(drifting(_454)=true) :- 
     vessel(_454).

grounding(anchoredOrMoored(_454)=true) :- 
     vessel(_454).

grounding(trawlSpeed(_454)=true) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(movingSpeed(_454)=_450) :- 
     vessel(_454),movingStatus(_450).

grounding(pilotOps(_454,_456)=true) :- 
     vpair(_454,_456).

grounding(tuggingSpeed(_454)=true) :- 
     vessel(_454).

grounding(tugging(_454,_456)=true) :- 
     vpair(_454,_456).

grounding(rendezVous(_454,_456)=true) :- 
     vpair(_454,_456).

grounding(trawlingMovement(_454)=true) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(trawlingMovement(_454)=false) :- 
     vessel(_454),vesselType(_454,fishing).

grounding(trawling(_454)=true) :- 
     vessel(_454).

grounding(loitering(_454)=true) :- 
     vessel(_454).

p(trawlingMovement(_448)=true).

p(sarMovement(_448)=true).

inputEntity(entersArea(_136,_138)).
inputEntity(gap_start(_136)).
inputEntity(stop_start(_136)).
inputEntity(slow_motion_start(_136)).
inputEntity(change_in_speed_start(_136)).
inputEntity(velocity(_136,_138,_140,_142)).
inputEntity(change_in_heading(_136)).
inputEntity(leavesArea(_136,_138)).
inputEntity(gap_end(_136)).
inputEntity(stop_end(_136)).
inputEntity(slow_motion_end(_136)).
inputEntity(change_in_speed_end(_136)).
inputEntity(proximity(_142,_144)=true).
inputEntity(coord(_136,_138,_140)).

outputEntity(withinArea(_288,_290)=true).
outputEntity(gap(_288)=nearPorts).
outputEntity(gap(_288)=farFromPorts).
outputEntity(stopped(_288)=nearPorts).
outputEntity(stopped(_288)=farFromPorts).
outputEntity(lowSpeed(_288)=true).
outputEntity(changingSpeed(_288)=true).
outputEntity(highSpeedNearCoast(_288)=true).
outputEntity(movingSpeed(_288)=below).
outputEntity(movingSpeed(_288)=normal).
outputEntity(movingSpeed(_288)=above).
outputEntity(drifting(_288)=true).
outputEntity(tuggingSpeed(_288)=true).
outputEntity(trawlSpeed(_288)=true).
outputEntity(trawlingMovement(_288)=true).
outputEntity(sarSpeed(_288)=true).
outputEntity(sarMovement(_288)=true).
outputEntity(trawlingMovement(_288)=false).
outputEntity(sarMovement(_288)=false).
outputEntity(underWay(_288)=true).
outputEntity(anchoredOrMoored(_288)=true).
outputEntity(tugging(_288,_290)=true).
outputEntity(rendezVous(_288,_290)=true).
outputEntity(trawling(_288)=true).
outputEntity(inSAR(_288)=true).
outputEntity(loitering(_288)=true).
outputEntity(pilotOps(_288,_290)=true).

event(entersArea(_506,_508)).
event(gap_start(_506)).
event(stop_start(_506)).
event(slow_motion_start(_506)).
event(change_in_speed_start(_506)).
event(velocity(_506,_508,_510,_512)).
event(change_in_heading(_506)).
event(leavesArea(_506,_508)).
event(gap_end(_506)).
event(stop_end(_506)).
event(slow_motion_end(_506)).
event(change_in_speed_end(_506)).
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
simpleFluent(trawlingMovement(_652)=true).
simpleFluent(sarSpeed(_652)=true).
simpleFluent(sarMovement(_652)=true).
simpleFluent(trawlingMovement(_652)=false).
simpleFluent(sarMovement(_652)=false).

sDFluent(underWay(_828)=true).
sDFluent(anchoredOrMoored(_828)=true).
sDFluent(tugging(_828,_830)=true).
sDFluent(rendezVous(_828,_830)=true).
sDFluent(trawling(_828)=true).
sDFluent(inSAR(_828)=true).
sDFluent(loitering(_828)=true).
sDFluent(pilotOps(_828,_830)=true).
sDFluent(proximity(_828,_830)=true).

index(entersArea(_884,_944),_884).
index(gap_start(_884),_884).
index(stop_start(_884),_884).
index(slow_motion_start(_884),_884).
index(change_in_speed_start(_884),_884).
index(velocity(_884,_944,_946,_948),_884).
index(change_in_heading(_884),_884).
index(leavesArea(_884,_944),_884).
index(gap_end(_884),_884).
index(stop_end(_884),_884).
index(slow_motion_end(_884),_884).
index(change_in_speed_end(_884),_884).
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
index(trawlingMovement(_884)=true,_884).
index(sarSpeed(_884)=true,_884).
index(sarMovement(_884)=true,_884).
index(trawlingMovement(_884)=false,_884).
index(sarMovement(_884)=false,_884).
index(underWay(_884)=true,_884).
index(anchoredOrMoored(_884)=true,_884).
index(tugging(_884,_950)=true,_884).
index(rendezVous(_884,_950)=true,_884).
index(trawling(_884)=true,_884).
index(inSAR(_884)=true,_884).
index(loitering(_884)=true,_884).
index(pilotOps(_884,_950)=true,_884).
index(proximity(_884,_950)=true,_884).


cachingOrder2(_1382, withinArea(_1382,_1384)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_1382),areaType(_1384).

cachingOrder2(_1638, gap(_1638)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1638),portStatus(nearPorts).

cachingOrder2(_1616, gap(_1616)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1616),portStatus(farFromPorts).

cachingOrder2(_1594, highSpeedNearCoast(_1594)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1594).

cachingOrder2(_1556, trawlingMovement(_1556)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1556),vesselType(_1556,fishing).

cachingOrder2(_1556, trawlingMovement(_1556)=false) :- % level in dependency graph: 2, processing order in component: 2
     vessel(_1556),vesselType(_1556,fishing).

cachingOrder2(_2306, stopped(_2306)=nearPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2306),portStatus(nearPorts).

cachingOrder2(_2284, stopped(_2284)=farFromPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2284),portStatus(farFromPorts).

cachingOrder2(_2262, lowSpeed(_2262)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2262).

cachingOrder2(_2240, changingSpeed(_2240)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2240).

cachingOrder2(_2218, movingSpeed(_2218)=below) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2218),movingStatus(below).

cachingOrder2(_2196, movingSpeed(_2196)=normal) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2196),movingStatus(normal).

cachingOrder2(_2174, movingSpeed(_2174)=above) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2174),movingStatus(above).

cachingOrder2(_2152, tuggingSpeed(_2152)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2152).

cachingOrder2(_2130, trawlSpeed(_2130)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2130),vesselType(_2130,fishing).

cachingOrder2(_2108, sarSpeed(_2108)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2108),vesselType(_2108,sar).

cachingOrder2(_3294, sarMovement(_3294)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3294),vesselType(_3294,sar).

cachingOrder2(_3294, sarMovement(_3294)=false) :- % level in dependency graph: 4, processing order in component: 2
     vessel(_3294),vesselType(_3294,sar).

cachingOrder2(_3272, underWay(_3272)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3272).

cachingOrder2(_3250, anchoredOrMoored(_3250)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3250).

cachingOrder2(_3226, tugging(_3226,_3228)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_3226,_3228).

cachingOrder2(_3202, rendezVous(_3202,_3204)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_3202,_3204).

cachingOrder2(_3180, trawling(_3180)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3180).

cachingOrder2(_3156, pilotOps(_3156,_3158)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_3156,_3158).

cachingOrder2(_4068, drifting(_4068)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_4068).

cachingOrder2(_4046, inSAR(_4046)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_4046).

cachingOrder2(_4024, loitering(_4024)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_4024).

collectGrounds([entersArea(_688,_702), gap_start(_688), stop_start(_688), slow_motion_start(_688), change_in_speed_start(_688), velocity(_688,_702,_704,_706), change_in_heading(_688), leavesArea(_688,_702), gap_end(_688), stop_end(_688), slow_motion_end(_688), change_in_speed_end(_688), coord(_688,_702,_704)],vessel(_688)).

collectGrounds([proximity(_676,_678)=true],vpair(_676,_678)).

dgrounded(withinArea(_1770,_1772)=true, vessel(_1770)).
dgrounded(gap(_1728)=nearPorts, vessel(_1728)).
dgrounded(gap(_1686)=farFromPorts, vessel(_1686)).
dgrounded(stopped(_1644)=nearPorts, vessel(_1644)).
dgrounded(stopped(_1602)=farFromPorts, vessel(_1602)).
dgrounded(lowSpeed(_1570)=true, vessel(_1570)).
dgrounded(changingSpeed(_1538)=true, vessel(_1538)).
dgrounded(highSpeedNearCoast(_1506)=true, vessel(_1506)).
dgrounded(movingSpeed(_1464)=below, vessel(_1464)).
dgrounded(movingSpeed(_1422)=normal, vessel(_1422)).
dgrounded(movingSpeed(_1380)=above, vessel(_1380)).
dgrounded(drifting(_1348)=true, vessel(_1348)).
dgrounded(tuggingSpeed(_1316)=true, vessel(_1316)).
dgrounded(trawlSpeed(_1272)=true, vessel(_1272)).
dgrounded(trawlingMovement(_1228)=true, vessel(_1228)).
dgrounded(sarSpeed(_1184)=true, vessel(_1184)).
dgrounded(sarMovement(_1140)=true, vessel(_1140)).
dgrounded(trawlingMovement(_1096)=false, vessel(_1096)).
dgrounded(sarMovement(_1052)=false, vessel(_1052)).
dgrounded(underWay(_1020)=true, vessel(_1020)).
dgrounded(anchoredOrMoored(_988)=true, vessel(_988)).
dgrounded(tugging(_952,_954)=true, vpair(_952,_954)).
dgrounded(rendezVous(_916,_918)=true, vpair(_916,_918)).
dgrounded(trawling(_884)=true, vessel(_884)).
dgrounded(inSAR(_852)=true, vessel(_852)).
dgrounded(loitering(_820)=true, vessel(_820)).
dgrounded(pilotOps(_784,_786)=true, vpair(_784,_786)).
