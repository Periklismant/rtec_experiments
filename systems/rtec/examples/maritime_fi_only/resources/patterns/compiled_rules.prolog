:- dynamic vessel/1, vpair/2.

initiatedAt(withinArea(_2008,_2010)=true, _2040, _1978, _2046) :-
     happensAtIE(entersArea(_2008,_2016),_1978),_2040=<_1978,_1978<_2046,
     areaType(_2016,_2010).

initiatedAt(gap(_2008)=nearPorts, _2048, _1978, _2054) :-
     happensAtIE(gap_start(_2008),_1978),_2048=<_1978,_1978<_2054,
     holdsAtProcessedSimpleFluent(_2008,withinArea(_2008,nearPorts)=true,_1978).

initiatedAt(gap(_2008)=farFromPorts, _2052, _1978, _2058) :-
     happensAtIE(gap_start(_2008),_1978),_2052=<_1978,_1978<_2058,
     \+holdsAtProcessedSimpleFluent(_2008,withinArea(_2008,nearPorts)=true,_1978).

initiatedAt(changingSpeed(_2008)=true, _2024, _1978, _2030) :-
     happensAtIE(change_in_speed_start(_2008),_1978),
     _2024=<_1978,
     _1978<_2030.

initiatedAt(trawlSpeed(_2008)=true, _2092, _1978, _2098) :-
     happensAtIE(velocity(_2008,_2014,_2016,_2018),_1978),_2092=<_1978,_1978<_2098,
     thresholds(trawlspeedMin,_2030),
     thresholds(trawlspeedMax,_2036),
     inRange(_2014,_2030,_2036),
     holdsAtProcessedSimpleFluent(_2008,withinArea(_2008,fishing)=true,_1978).

initiatedAt(trawlingMovement(_2008)=true, _2048, _1978, _2054) :-
     happensAtIE(change_in_heading(_2008),_1978),_2048=<_1978,_1978<_2054,
     holdsAtProcessedSimpleFluent(_2008,withinArea(_2008,fishing)=true,_1978).

initiatedAt(sarSpeed(_2008)=true, _2056, _1978, _2062) :-
     happensAtIE(velocity(_2008,_2014,_2016,_2018),_1978),_2056=<_1978,_1978<_2062,
     thresholds(sarMinSpeed,_2030),
     inRange(_2014,_2030,inf).

initiatedAt(sarMovement(_2008)=true, _2024, _1978, _2030) :-
     happensAtIE(change_in_heading(_2008),_1978),
     _2024=<_1978,
     _1978<_2030.

initiatedAt(sarMovement(_2008)=true, _2034, _1978, _2040) :-
     happensAtProcessedSimpleFluent(_2008,start(changingSpeed(_2008)=true),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(withinArea(_2008,_2010)=true, _2040, _1978, _2046) :-
     happensAtIE(leavesArea(_2008,_2016),_1978),_2040=<_1978,_1978<_2046,
     areaType(_2016,_2010).

terminatedAt(withinArea(_2008,_2010)=true, _2026, _1978, _2032) :-
     happensAtIE(gap_start(_2008),_1978),
     _2026=<_1978,
     _1978<_2032.

terminatedAt(gap(_2008)=_1984, _2024, _1978, _2030) :-
     happensAtIE(gap_end(_2008),_1978),
     _2024=<_1978,
     _1978<_2030.

terminatedAt(changingSpeed(_2008)=true, _2024, _1978, _2030) :-
     happensAtIE(change_in_speed_end(_2008),_1978),
     _2024=<_1978,
     _1978<_2030.

terminatedAt(changingSpeed(_2008)=true, _2034, _1978, _2040) :-
     happensAtProcessedSimpleFluent(_2008,start(gap(_2008)=_2018),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(trawlSpeed(_2008)=true, _2072, _1978, _2078) :-
     happensAtIE(velocity(_2008,_2014,_2016,_2018),_1978),_2072=<_1978,_1978<_2078,
     thresholds(trawlspeedMin,_2030),
     thresholds(trawlspeedMax,_2036),
     \+inRange(_2014,_2030,_2036).

terminatedAt(trawlSpeed(_2008)=true, _2034, _1978, _2040) :-
     happensAtProcessedSimpleFluent(_2008,start(gap(_2008)=_2018),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(trawlSpeed(_2008)=true, _2036, _1978, _2042) :-
     happensAtProcessedSimpleFluent(_2008,end(withinArea(_2008,fishing)=true),_1978),
     _2036=<_1978,
     _1978<_2042.

terminatedAt(trawlingMovement(_2008)=true, _2036, _1978, _2042) :-
     happensAtProcessedSimpleFluent(_2008,end(withinArea(_2008,fishing)=true),_1978),
     _2036=<_1978,
     _1978<_2042.

terminatedAt(sarSpeed(_2008)=true, _2056, _1978, _2062) :-
     happensAtIE(velocity(_2008,_2014,_2016,_2018),_1978),_2056=<_1978,_1978<_2062,
     thresholds(sarMinSpeed,_2030),
     inRange(_2014,0,_2030).

terminatedAt(sarSpeed(_2008)=true, _2034, _1978, _2040) :-
     happensAtProcessedSimpleFluent(_2008,start(gap(_2008)=_2018),_1978),
     _2034=<_1978,
     _1978<_2040.

terminatedAt(sarMovement(_2008)=true, _2034, _1978, _2040) :-
     happensAtProcessedSimpleFluent(_2008,start(gap(_2008)=_2018),_1978),
     _2034=<_1978,
     _1978<_2040.

holdsForSDFluent(trawling(_2008)=true,_1978) :-
     holdsForProcessedSimpleFluent(_2008,trawlSpeed(_2008)=true,_2024),
     holdsForProcessedSimpleFluent(_2008,trawlingMovement(_2008)=true,_2040),
     intersect_all([_2024,_2040],_2058),
     thresholds(trawlingTime,_2064),
     intDurGreater(_2058,_2064,_1978).

holdsForSDFluent(inSAR(_2008)=true,_1978) :-
     holdsForProcessedSimpleFluent(_2008,sarSpeed(_2008)=true,_2024),
     holdsForProcessedSimpleFluent(_2008,sarMovement(_2008)=true,_2040),
     intersect_all([_2024,_2040],_2058),
     intDurGreater(_2058,3600,_1978).

fi(trawlingMovement(_2018)=true,trawlingMovement(_2018)=false,_1980):-
     thresholds(trawlingCrs,_1980),
     grounding(trawlingMovement(_2018)=true),
     grounding(trawlingMovement(_2018)=false).

fi(sarMovement(_2012)=true,sarMovement(_2012)=false,1800):-
     grounding(sarMovement(_2012)=true),
     grounding(sarMovement(_2012)=false).

collectIntervals2(_1982, proximity(_1982,_1984)=true) :-
     vpair(_1982,_1984).

needsGrounding(_2196,_2198,_2200) :- 
     fail.

grounding(change_in_speed_start(_2378)) :- 
     vessel(_2378).

grounding(change_in_speed_end(_2378)) :- 
     vessel(_2378).

grounding(change_in_heading(_2378)) :- 
     vessel(_2378).

grounding(stop_start(_2378)) :- 
     vessel(_2378).

grounding(stop_end(_2378)) :- 
     vessel(_2378).

grounding(slow_motion_start(_2378)) :- 
     vessel(_2378).

grounding(slow_motion_end(_2378)) :- 
     vessel(_2378).

grounding(gap_start(_2378)) :- 
     vessel(_2378).

grounding(gap_end(_2378)) :- 
     vessel(_2378).

grounding(entersArea(_2378,_2380)) :- 
     vessel(_2378),areaType(_2380).

grounding(leavesArea(_2378,_2380)) :- 
     vessel(_2378),areaType(_2380).

grounding(coord(_2378,_2380,_2382)) :- 
     vessel(_2378).

grounding(velocity(_2378,_2380,_2382,_2384)) :- 
     vessel(_2378).

grounding(proximity(_2384,_2386)=true) :- 
     vpair(_2384,_2386).

grounding(gap(_2384)=_2380) :- 
     vessel(_2384),portStatus(_2380).

grounding(changingSpeed(_2384)=true) :- 
     vessel(_2384).

grounding(withinArea(_2384,_2386)=true) :- 
     vessel(_2384),areaType(_2386).

grounding(sarSpeed(_2384)=true) :- 
     vessel(_2384),vesselType(_2384,sar).

grounding(sarMovement(_2384)=true) :- 
     vessel(_2384),vesselType(_2384,sar).

grounding(sarMovement(_2384)=false) :- 
     vessel(_2384),vesselType(_2384,sar).

grounding(inSAR(_2384)=true) :- 
     vessel(_2384).

grounding(trawlSpeed(_2384)=true) :- 
     vessel(_2384),vesselType(_2384,fishing).

grounding(trawlingMovement(_2384)=true) :- 
     vessel(_2384),vesselType(_2384,fishing).

grounding(trawlingMovement(_2384)=false) :- 
     vessel(_2384),vesselType(_2384,fishing).

grounding(trawling(_2384)=true) :- 
     vessel(_2384).

p(trawlingMovement(_2378)=true).

p(sarMovement(_2378)=true).

inputEntity(entersArea(_2032,_2034)).
inputEntity(gap_start(_2032)).
inputEntity(change_in_speed_start(_2032)).
inputEntity(velocity(_2032,_2034,_2036,_2038)).
inputEntity(change_in_heading(_2032)).
inputEntity(leavesArea(_2032,_2034)).
inputEntity(gap_end(_2032)).
inputEntity(change_in_speed_end(_2032)).
inputEntity(stop_start(_2032)).
inputEntity(stop_end(_2032)).
inputEntity(slow_motion_start(_2032)).
inputEntity(slow_motion_end(_2032)).
inputEntity(coord(_2032,_2034,_2036)).
inputEntity(proximity(_2038,_2040)=true).

outputEntity(withinArea(_2178,_2180)=true).
outputEntity(gap(_2178)=nearPorts).
outputEntity(gap(_2178)=farFromPorts).
outputEntity(changingSpeed(_2178)=true).
outputEntity(trawlSpeed(_2178)=true).
outputEntity(trawlingMovement(_2178)=true).
outputEntity(sarSpeed(_2178)=true).
outputEntity(sarMovement(_2178)=true).
outputEntity(trawlingMovement(_2178)=false).
outputEntity(sarMovement(_2178)=false).
outputEntity(trawling(_2178)=true).
outputEntity(inSAR(_2178)=true).

event(entersArea(_2300,_2302)).
event(gap_start(_2300)).
event(change_in_speed_start(_2300)).
event(velocity(_2300,_2302,_2304,_2306)).
event(change_in_heading(_2300)).
event(leavesArea(_2300,_2302)).
event(gap_end(_2300)).
event(change_in_speed_end(_2300)).
event(stop_start(_2300)).
event(stop_end(_2300)).
event(slow_motion_start(_2300)).
event(slow_motion_end(_2300)).
event(coord(_2300,_2302,_2304)).

simpleFluent(withinArea(_2440,_2442)=true).
simpleFluent(gap(_2440)=nearPorts).
simpleFluent(gap(_2440)=farFromPorts).
simpleFluent(changingSpeed(_2440)=true).
simpleFluent(trawlSpeed(_2440)=true).
simpleFluent(trawlingMovement(_2440)=true).
simpleFluent(sarSpeed(_2440)=true).
simpleFluent(sarMovement(_2440)=true).
simpleFluent(trawlingMovement(_2440)=false).
simpleFluent(sarMovement(_2440)=false).

sDFluent(trawling(_2556)=true).
sDFluent(inSAR(_2556)=true).
sDFluent(proximity(_2556,_2558)=true).

index(entersArea(_2576,_2630),_2576).
index(gap_start(_2576),_2576).
index(change_in_speed_start(_2576),_2576).
index(velocity(_2576,_2630,_2632,_2634),_2576).
index(change_in_heading(_2576),_2576).
index(leavesArea(_2576,_2630),_2576).
index(gap_end(_2576),_2576).
index(change_in_speed_end(_2576),_2576).
index(stop_start(_2576),_2576).
index(stop_end(_2576),_2576).
index(slow_motion_start(_2576),_2576).
index(slow_motion_end(_2576),_2576).
index(coord(_2576,_2630,_2632),_2576).
index(withinArea(_2576,_2636)=true,_2576).
index(gap(_2576)=nearPorts,_2576).
index(gap(_2576)=farFromPorts,_2576).
index(changingSpeed(_2576)=true,_2576).
index(trawlSpeed(_2576)=true,_2576).
index(trawlingMovement(_2576)=true,_2576).
index(sarSpeed(_2576)=true,_2576).
index(sarMovement(_2576)=true,_2576).
index(trawlingMovement(_2576)=false,_2576).
index(sarMovement(_2576)=false,_2576).
index(trawling(_2576)=true,_2576).
index(inSAR(_2576)=true,_2576).
index(proximity(_2576,_2636)=true,_2576).


cachingOrder2(_2966, withinArea(_2966,_2968)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_2966),areaType(_2968).

cachingOrder2(_3194, gap(_3194)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3194),portStatus(nearPorts).

cachingOrder2(_3172, gap(_3172)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3172),portStatus(farFromPorts).

cachingOrder2(_3134, trawlingMovement(_3134)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3134),vesselType(_3134,fishing).

cachingOrder2(_3134, trawlingMovement(_3134)=false) :- % level in dependency graph: 2, processing order in component: 2
     vessel(_3134),vesselType(_3134,fishing).

cachingOrder2(_3632, changingSpeed(_3632)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3632).

cachingOrder2(_3610, trawlSpeed(_3610)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3610),vesselType(_3610,fishing).

cachingOrder2(_3588, sarSpeed(_3588)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3588),vesselType(_3588,sar).

cachingOrder2(_3958, sarMovement(_3958)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3958),vesselType(_3958,sar).

cachingOrder2(_3958, sarMovement(_3958)=false) :- % level in dependency graph: 4, processing order in component: 2
     vessel(_3958),vesselType(_3958,sar).

cachingOrder2(_3936, trawling(_3936)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3936).

cachingOrder2(_4278, inSAR(_4278)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_4278).

collectGrounds([entersArea(_2578,_2592), gap_start(_2578), change_in_speed_start(_2578), velocity(_2578,_2592,_2594,_2596), change_in_heading(_2578), leavesArea(_2578,_2592), gap_end(_2578), change_in_speed_end(_2578), stop_start(_2578), stop_end(_2578), slow_motion_start(_2578), slow_motion_end(_2578), coord(_2578,_2592,_2594)],vessel(_2578)).

collectGrounds([proximity(_2566,_2568)=true],vpair(_2566,_2568)).

dgrounded(withinArea(_3112,_3114)=true, vessel(_3112)).
dgrounded(gap(_3070)=nearPorts, vessel(_3070)).
dgrounded(gap(_3028)=farFromPorts, vessel(_3028)).
dgrounded(changingSpeed(_2996)=true, vessel(_2996)).
dgrounded(trawlSpeed(_2952)=true, vessel(_2952)).
dgrounded(trawlingMovement(_2908)=true, vessel(_2908)).
dgrounded(sarSpeed(_2864)=true, vessel(_2864)).
dgrounded(sarMovement(_2820)=true, vessel(_2820)).
dgrounded(trawlingMovement(_2776)=false, vessel(_2776)).
dgrounded(sarMovement(_2732)=false, vessel(_2732)).
dgrounded(trawling(_2700)=true, vessel(_2700)).
dgrounded(inSAR(_2668)=true, vessel(_2668)).
