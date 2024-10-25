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

needsGrounding(_294,_296,_298) :- 
     fail.

grounding(change_in_speed_start(_440)) :- 
     vessel(_440).

grounding(change_in_speed_end(_440)) :- 
     vessel(_440).

grounding(change_in_heading(_440)) :- 
     vessel(_440).

grounding(stop_start(_440)) :- 
     vessel(_440).

grounding(stop_end(_440)) :- 
     vessel(_440).

grounding(slow_motion_start(_440)) :- 
     vessel(_440).

grounding(slow_motion_end(_440)) :- 
     vessel(_440).

grounding(gap_start(_440)) :- 
     vessel(_440).

grounding(gap_end(_440)) :- 
     vessel(_440).

grounding(entersArea(_440,_442)) :- 
     vessel(_440),areaType(_442).

grounding(leavesArea(_440,_442)) :- 
     vessel(_440),areaType(_442).

grounding(coord(_440,_442,_444)) :- 
     vessel(_440).

grounding(velocity(_440,_442,_444,_446)) :- 
     vessel(_440).

grounding(proximity(_446,_448)=true) :- 
     vpair(_446,_448).

grounding(gap(_446)=_442) :- 
     vessel(_446),portStatus(_442).

grounding(stopped(_446)=_442) :- 
     vessel(_446),portStatus(_442).

grounding(lowSpeed(_446)=true) :- 
     vessel(_446).

grounding(changingSpeed(_446)=true) :- 
     vessel(_446).

grounding(withinArea(_446,_448)=true) :- 
     vessel(_446),areaType(_448).

grounding(underWay(_446)=true) :- 
     vessel(_446).

grounding(sarSpeed(_446)=true) :- 
     vessel(_446),vesselType(_446,sar).

grounding(sarMovement(_446)=true) :- 
     vessel(_446),vesselType(_446,sar).

grounding(sarMovement(_446)=false) :- 
     vessel(_446),vesselType(_446,sar).

grounding(inSAR(_446)=true) :- 
     vessel(_446).

grounding(highSpeedNearCoast(_446)=true) :- 
     vessel(_446).

grounding(drifting(_446)=true) :- 
     vessel(_446).

grounding(anchoredOrMoored(_446)=true) :- 
     vessel(_446).

grounding(trawlSpeed(_446)=true) :- 
     vessel(_446),vesselType(_446,fishing).

grounding(movingSpeed(_446)=_442) :- 
     vessel(_446),movingStatus(_442).

grounding(pilotOps(_446,_448)=true) :- 
     vpair(_446,_448).

grounding(tuggingSpeed(_446)=true) :- 
     vessel(_446).

grounding(tugging(_446,_448)=true) :- 
     vpair(_446,_448).

grounding(rendezVous(_446,_448)=true) :- 
     vpair(_446,_448).

grounding(trawlingMovement(_446)=true) :- 
     vessel(_446),vesselType(_446,fishing).

grounding(trawlingMovement(_446)=false) :- 
     vessel(_446),vesselType(_446,fishing).

grounding(trawling(_446)=true) :- 
     vessel(_446).

grounding(loitering(_446)=true) :- 
     vessel(_446).

inputEntity(entersArea(_130,_132)).
inputEntity(gap_start(_130)).
inputEntity(stop_start(_130)).
inputEntity(slow_motion_start(_130)).
inputEntity(change_in_speed_start(_130)).
inputEntity(velocity(_130,_132,_134,_136)).
inputEntity(leavesArea(_130,_132)).
inputEntity(gap_end(_130)).
inputEntity(stop_end(_130)).
inputEntity(slow_motion_end(_130)).
inputEntity(change_in_speed_end(_130)).
inputEntity(proximity(_136,_138)=true).
inputEntity(change_in_heading(_130)).
inputEntity(coord(_130,_132,_134)).
inputEntity(sarMovement(_136)=true).
inputEntity(sarMovement(_136)=false).
inputEntity(inSAR(_136)=true).
inputEntity(trawlingMovement(_136)=true).
inputEntity(trawlingMovement(_136)=false).
inputEntity(trawling(_136)=true).

outputEntity(withinArea(_312,_314)=true).
outputEntity(gap(_312)=nearPorts).
outputEntity(gap(_312)=farFromPorts).
outputEntity(stopped(_312)=nearPorts).
outputEntity(stopped(_312)=farFromPorts).
outputEntity(lowSpeed(_312)=true).
outputEntity(changingSpeed(_312)=true).
outputEntity(highSpeedNearCoast(_312)=true).
outputEntity(movingSpeed(_312)=below).
outputEntity(movingSpeed(_312)=normal).
outputEntity(movingSpeed(_312)=above).
outputEntity(drifting(_312)=true).
outputEntity(tuggingSpeed(_312)=true).
outputEntity(trawlSpeed(_312)=true).
outputEntity(sarSpeed(_312)=true).
outputEntity(underWay(_312)=true).
outputEntity(anchoredOrMoored(_312)=true).
outputEntity(tugging(_312,_314)=true).
outputEntity(rendezVous(_312,_314)=true).
outputEntity(loitering(_312)=true).
outputEntity(pilotOps(_312,_314)=true).

event(entersArea(_488,_490)).
event(gap_start(_488)).
event(stop_start(_488)).
event(slow_motion_start(_488)).
event(change_in_speed_start(_488)).
event(velocity(_488,_490,_492,_494)).
event(leavesArea(_488,_490)).
event(gap_end(_488)).
event(stop_end(_488)).
event(slow_motion_end(_488)).
event(change_in_speed_end(_488)).
event(change_in_heading(_488)).
event(coord(_488,_490,_492)).

simpleFluent(withinArea(_628,_630)=true).
simpleFluent(gap(_628)=nearPorts).
simpleFluent(gap(_628)=farFromPorts).
simpleFluent(stopped(_628)=nearPorts).
simpleFluent(stopped(_628)=farFromPorts).
simpleFluent(lowSpeed(_628)=true).
simpleFluent(changingSpeed(_628)=true).
simpleFluent(highSpeedNearCoast(_628)=true).
simpleFluent(movingSpeed(_628)=below).
simpleFluent(movingSpeed(_628)=normal).
simpleFluent(movingSpeed(_628)=above).
simpleFluent(drifting(_628)=true).
simpleFluent(tuggingSpeed(_628)=true).
simpleFluent(trawlSpeed(_628)=true).
simpleFluent(sarSpeed(_628)=true).

sDFluent(underWay(_774)=true).
sDFluent(anchoredOrMoored(_774)=true).
sDFluent(tugging(_774,_776)=true).
sDFluent(rendezVous(_774,_776)=true).
sDFluent(loitering(_774)=true).
sDFluent(pilotOps(_774,_776)=true).
sDFluent(proximity(_774,_776)=true).
sDFluent(sarMovement(_774)=true).
sDFluent(sarMovement(_774)=false).
sDFluent(inSAR(_774)=true).
sDFluent(trawlingMovement(_774)=true).
sDFluent(trawlingMovement(_774)=false).
sDFluent(trawling(_774)=true).

index(entersArea(_854,_908),_854).
index(gap_start(_854),_854).
index(stop_start(_854),_854).
index(slow_motion_start(_854),_854).
index(change_in_speed_start(_854),_854).
index(velocity(_854,_908,_910,_912),_854).
index(leavesArea(_854,_908),_854).
index(gap_end(_854),_854).
index(stop_end(_854),_854).
index(slow_motion_end(_854),_854).
index(change_in_speed_end(_854),_854).
index(change_in_heading(_854),_854).
index(coord(_854,_908,_910),_854).
index(withinArea(_854,_914)=true,_854).
index(gap(_854)=nearPorts,_854).
index(gap(_854)=farFromPorts,_854).
index(stopped(_854)=nearPorts,_854).
index(stopped(_854)=farFromPorts,_854).
index(lowSpeed(_854)=true,_854).
index(changingSpeed(_854)=true,_854).
index(highSpeedNearCoast(_854)=true,_854).
index(movingSpeed(_854)=below,_854).
index(movingSpeed(_854)=normal,_854).
index(movingSpeed(_854)=above,_854).
index(drifting(_854)=true,_854).
index(tuggingSpeed(_854)=true,_854).
index(trawlSpeed(_854)=true,_854).
index(sarSpeed(_854)=true,_854).
index(underWay(_854)=true,_854).
index(anchoredOrMoored(_854)=true,_854).
index(tugging(_854,_914)=true,_854).
index(rendezVous(_854,_914)=true,_854).
index(loitering(_854)=true,_854).
index(pilotOps(_854,_914)=true,_854).
index(proximity(_854,_914)=true,_854).
index(sarMovement(_854)=true,_854).
index(sarMovement(_854)=false,_854).
index(inSAR(_854)=true,_854).
index(trawlingMovement(_854)=true,_854).
index(trawlingMovement(_854)=false,_854).
index(trawling(_854)=true,_854).


cachingOrder2(_1334, withinArea(_1334,_1336)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_1334),areaType(_1336).

cachingOrder2(_1546, gap(_1546)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1546),portStatus(nearPorts).

cachingOrder2(_1524, gap(_1524)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1524),portStatus(farFromPorts).

cachingOrder2(_1502, highSpeedNearCoast(_1502)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_1502).

cachingOrder2(_2044, stopped(_2044)=nearPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2044),portStatus(nearPorts).

cachingOrder2(_2022, stopped(_2022)=farFromPorts) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2022),portStatus(farFromPorts).

cachingOrder2(_2000, lowSpeed(_2000)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_2000).

cachingOrder2(_1978, changingSpeed(_1978)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1978).

cachingOrder2(_1956, movingSpeed(_1956)=below) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1956),movingStatus(below).

cachingOrder2(_1934, movingSpeed(_1934)=normal) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1934),movingStatus(normal).

cachingOrder2(_1912, movingSpeed(_1912)=above) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1912),movingStatus(above).

cachingOrder2(_1890, tuggingSpeed(_1890)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1890).

cachingOrder2(_1868, trawlSpeed(_1868)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1868),vesselType(_1868,fishing).

cachingOrder2(_1846, sarSpeed(_1846)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_1846),vesselType(_1846,sar).

cachingOrder2(_2982, underWay(_2982)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2982).

cachingOrder2(_2960, anchoredOrMoored(_2960)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_2960).

cachingOrder2(_2936, tugging(_2936,_2938)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2936,_2938).

cachingOrder2(_2912, rendezVous(_2912,_2914)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2912,_2914).

cachingOrder2(_2888, pilotOps(_2888,_2890)=true) :- % level in dependency graph: 4, processing order in component: 1
     vpair(_2888,_2890).

cachingOrder2(_3478, drifting(_3478)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3478).

cachingOrder2(_3456, loitering(_3456)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_3456).

collectGrounds([entersArea(_952,_966), gap_start(_952), stop_start(_952), slow_motion_start(_952), change_in_speed_start(_952), velocity(_952,_966,_968,_970), leavesArea(_952,_966), gap_end(_952), stop_end(_952), slow_motion_end(_952), change_in_speed_end(_952), change_in_heading(_952), coord(_952,_966,_968), sarMovement(_952)=true, sarMovement(_952)=false, inSAR(_952)=true, trawlingMovement(_952)=true, trawlingMovement(_952)=false, trawling(_952)=true],vessel(_952)).

collectGrounds([proximity(_940,_942)=true],vpair(_940,_942)).

dgrounded(withinArea(_1788,_1790)=true, vessel(_1788)).
dgrounded(gap(_1746)=nearPorts, vessel(_1746)).
dgrounded(gap(_1704)=farFromPorts, vessel(_1704)).
dgrounded(stopped(_1662)=nearPorts, vessel(_1662)).
dgrounded(stopped(_1620)=farFromPorts, vessel(_1620)).
dgrounded(lowSpeed(_1588)=true, vessel(_1588)).
dgrounded(changingSpeed(_1556)=true, vessel(_1556)).
dgrounded(highSpeedNearCoast(_1524)=true, vessel(_1524)).
dgrounded(movingSpeed(_1482)=below, vessel(_1482)).
dgrounded(movingSpeed(_1440)=normal, vessel(_1440)).
dgrounded(movingSpeed(_1398)=above, vessel(_1398)).
dgrounded(drifting(_1366)=true, vessel(_1366)).
dgrounded(tuggingSpeed(_1334)=true, vessel(_1334)).
dgrounded(trawlSpeed(_1290)=true, vessel(_1290)).
dgrounded(sarSpeed(_1246)=true, vessel(_1246)).
dgrounded(underWay(_1214)=true, vessel(_1214)).
dgrounded(anchoredOrMoored(_1182)=true, vessel(_1182)).
dgrounded(tugging(_1146,_1148)=true, vpair(_1146,_1148)).
dgrounded(rendezVous(_1110,_1112)=true, vpair(_1110,_1112)).
dgrounded(loitering(_1078)=true, vessel(_1078)).
dgrounded(pilotOps(_1042,_1044)=true, vpair(_1042,_1044)).
