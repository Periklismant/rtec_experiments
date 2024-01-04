:- dynamic vessel/1, vpair/2.

initiatedAt(withinArea(_2004,_2006)=true, _2036, _1974, _2042) :-
     happensAtIE(entersArea(_2004,_2012),_1974),_2036=<_1974,_1974<_2042,
     areaType(_2012,_2006).

initiatedAt(gap(_2004)=nearPorts, _2044, _1974, _2050) :-
     happensAtIE(gap_start(_2004),_1974),_2044=<_1974,_1974<_2050,
     holdsAtProcessedSimpleFluent(_2004,withinArea(_2004,nearPorts)=true,_1974).

initiatedAt(gap(_2004)=farFromPorts, _2048, _1974, _2054) :-
     happensAtIE(gap_start(_2004),_1974),_2048=<_1974,_1974<_2054,
     \+holdsAtProcessedSimpleFluent(_2004,withinArea(_2004,nearPorts)=true,_1974).

initiatedAt(changingSpeed(_2004)=true, _2020, _1974, _2026) :-
     happensAtIE(change_in_speed_start(_2004),_1974),
     _2020=<_1974,
     _1974<_2026.

initiatedAt(trawlSpeed(_2004)=true, _2088, _1974, _2094) :-
     happensAtIE(velocity(_2004,_2010,_2012,_2014),_1974),_2088=<_1974,_1974<_2094,
     thresholds(trawlspeedMin,_2026),
     thresholds(trawlspeedMax,_2032),
     inRange(_2010,_2026,_2032),
     holdsAtProcessedSimpleFluent(_2004,withinArea(_2004,fishing)=true,_1974).

initiatedAt(trawlingMovement(_2004)=true, _2044, _1974, _2050) :-
     happensAtIE(change_in_heading(_2004),_1974),_2044=<_1974,_1974<_2050,
     holdsAtProcessedSimpleFluent(_2004,withinArea(_2004,fishing)=true,_1974).

initiatedAt(sarSpeed(_2004)=true, _2052, _1974, _2058) :-
     happensAtIE(velocity(_2004,_2010,_2012,_2014),_1974),_2052=<_1974,_1974<_2058,
     thresholds(sarMinSpeed,_2026),
     inRange(_2010,_2026,inf).

initiatedAt(sarMovement(_2004)=true, _2020, _1974, _2026) :-
     happensAtIE(change_in_heading(_2004),_1974),
     _2020=<_1974,
     _1974<_2026.

initiatedAt(sarMovement(_2004)=true, _2030, _1974, _2036) :-
     happensAtProcessedSimpleFluent(_2004,start(changingSpeed(_2004)=true),_1974),
     _2030=<_1974,
     _1974<_2036.

terminatedAt(withinArea(_2004,_2006)=true, _2036, _1974, _2042) :-
     happensAtIE(leavesArea(_2004,_2012),_1974),_2036=<_1974,_1974<_2042,
     areaType(_2012,_2006).

terminatedAt(withinArea(_2004,_2006)=true, _2022, _1974, _2028) :-
     happensAtIE(gap_start(_2004),_1974),
     _2022=<_1974,
     _1974<_2028.

terminatedAt(gap(_2004)=_1980, _2020, _1974, _2026) :-
     happensAtIE(gap_end(_2004),_1974),
     _2020=<_1974,
     _1974<_2026.

terminatedAt(changingSpeed(_2004)=true, _2020, _1974, _2026) :-
     happensAtIE(change_in_speed_end(_2004),_1974),
     _2020=<_1974,
     _1974<_2026.

terminatedAt(changingSpeed(_2004)=true, _2030, _1974, _2036) :-
     happensAtProcessedSimpleFluent(_2004,start(gap(_2004)=_2014),_1974),
     _2030=<_1974,
     _1974<_2036.

terminatedAt(trawlSpeed(_2004)=true, _2068, _1974, _2074) :-
     happensAtIE(velocity(_2004,_2010,_2012,_2014),_1974),_2068=<_1974,_1974<_2074,
     thresholds(trawlspeedMin,_2026),
     thresholds(trawlspeedMax,_2032),
     \+inRange(_2010,_2026,_2032).

terminatedAt(trawlSpeed(_2004)=true, _2030, _1974, _2036) :-
     happensAtProcessedSimpleFluent(_2004,start(gap(_2004)=_2014),_1974),
     _2030=<_1974,
     _1974<_2036.

terminatedAt(trawlSpeed(_2004)=true, _2032, _1974, _2038) :-
     happensAtProcessedSimpleFluent(_2004,end(withinArea(_2004,fishing)=true),_1974),
     _2032=<_1974,
     _1974<_2038.

terminatedAt(trawlingMovement(_2004)=true, _2032, _1974, _2038) :-
     happensAtProcessedSimpleFluent(_2004,end(withinArea(_2004,fishing)=true),_1974),
     _2032=<_1974,
     _1974<_2038.

terminatedAt(sarSpeed(_2004)=true, _2052, _1974, _2058) :-
     happensAtIE(velocity(_2004,_2010,_2012,_2014),_1974),_2052=<_1974,_1974<_2058,
     thresholds(sarMinSpeed,_2026),
     inRange(_2010,0,_2026).

terminatedAt(sarSpeed(_2004)=true, _2030, _1974, _2036) :-
     happensAtProcessedSimpleFluent(_2004,start(gap(_2004)=_2014),_1974),
     _2030=<_1974,
     _1974<_2036.

terminatedAt(sarMovement(_2004)=true, _2030, _1974, _2036) :-
     happensAtProcessedSimpleFluent(_2004,start(gap(_2004)=_2014),_1974),
     _2030=<_1974,
     _1974<_2036.

holdsForSDFluent(trawling(_2004)=true,_1974) :-
     holdsForProcessedSimpleFluent(_2004,trawlSpeed(_2004)=true,_2020),
     holdsForProcessedSimpleFluent(_2004,trawlingMovement(_2004)=true,_2036),
     intersect_all([_2020,_2036],_2054),
     thresholds(trawlingTime,_2060),
     intDurGreater(_2054,_2060,_1974).

holdsForSDFluent(inSAR(_2004)=true,_1974) :-
     holdsForProcessedSimpleFluent(_2004,sarSpeed(_2004)=true,_2020),
     holdsForProcessedSimpleFluent(_2004,sarMovement(_2004)=true,_2036),
     intersect_all([_2020,_2036],_2054),
     intDurGreater(_2054,3600,_1974).

fi(trawlingMovement(_2014)=true,trawlingMovement(_2014)=false,_1976):-
     thresholds(trawlingCrs,_1976),
     grounding(trawlingMovement(_2014)=true),
     grounding(trawlingMovement(_2014)=false).

fi(sarMovement(_2008)=true,sarMovement(_2008)=false,1800):-
     grounding(sarMovement(_2008)=true),
     grounding(sarMovement(_2008)=false).

collectIntervals2(_1978, proximity(_1978,_1980)=true) :-
     vpair(_1978,_1980).

needsGrounding(_2192,_2194,_2196) :- 
     fail.

grounding(change_in_speed_start(_2374)) :- 
     vessel(_2374).

grounding(change_in_speed_end(_2374)) :- 
     vessel(_2374).

grounding(change_in_heading(_2374)) :- 
     vessel(_2374).

grounding(stop_start(_2374)) :- 
     vessel(_2374).

grounding(stop_end(_2374)) :- 
     vessel(_2374).

grounding(slow_motion_start(_2374)) :- 
     vessel(_2374).

grounding(slow_motion_end(_2374)) :- 
     vessel(_2374).

grounding(gap_start(_2374)) :- 
     vessel(_2374).

grounding(gap_end(_2374)) :- 
     vessel(_2374).

grounding(entersArea(_2374,_2376)) :- 
     vessel(_2374),areaType(_2376).

grounding(leavesArea(_2374,_2376)) :- 
     vessel(_2374),areaType(_2376).

grounding(coord(_2374,_2376,_2378)) :- 
     vessel(_2374).

grounding(velocity(_2374,_2376,_2378,_2380)) :- 
     vessel(_2374).

grounding(proximity(_2380,_2382)=true) :- 
     vpair(_2380,_2382).

grounding(gap(_2380)=_2376) :- 
     vessel(_2380),portStatus(_2376).

grounding(changingSpeed(_2380)=true) :- 
     vessel(_2380).

grounding(withinArea(_2380,_2382)=true) :- 
     vessel(_2380),areaType(_2382).

grounding(sarSpeed(_2380)=true) :- 
     vessel(_2380),vesselType(_2380,sar).

grounding(sarMovement(_2380)=true) :- 
     vessel(_2380),vesselType(_2380,sar).

grounding(sarMovement(_2380)=false) :- 
     vessel(_2380),vesselType(_2380,sar).

grounding(inSAR(_2380)=true) :- 
     vessel(_2380).

grounding(trawlSpeed(_2380)=true) :- 
     vessel(_2380),vesselType(_2380,fishing).

grounding(trawlingMovement(_2380)=true) :- 
     vessel(_2380),vesselType(_2380,fishing).

grounding(trawlingMovement(_2380)=false) :- 
     vessel(_2380),vesselType(_2380,fishing).

grounding(trawling(_2380)=true) :- 
     vessel(_2380).

p(trawlingMovement(_2374)=true).

p(sarMovement(_2374)=true).

inputEntity(entersArea(_2028,_2030)).
inputEntity(gap_start(_2028)).
inputEntity(change_in_speed_start(_2028)).
inputEntity(velocity(_2028,_2030,_2032,_2034)).
inputEntity(change_in_heading(_2028)).
inputEntity(leavesArea(_2028,_2030)).
inputEntity(gap_end(_2028)).
inputEntity(change_in_speed_end(_2028)).
inputEntity(stop_start(_2028)).
inputEntity(stop_end(_2028)).
inputEntity(slow_motion_start(_2028)).
inputEntity(slow_motion_end(_2028)).
inputEntity(coord(_2028,_2030,_2032)).
inputEntity(proximity(_2034,_2036)=true).

outputEntity(withinArea(_2174,_2176)=true).
outputEntity(gap(_2174)=nearPorts).
outputEntity(gap(_2174)=farFromPorts).
outputEntity(changingSpeed(_2174)=true).
outputEntity(trawlSpeed(_2174)=true).
outputEntity(trawlingMovement(_2174)=true).
outputEntity(sarSpeed(_2174)=true).
outputEntity(sarMovement(_2174)=true).
outputEntity(trawlingMovement(_2174)=false).
outputEntity(sarMovement(_2174)=false).
outputEntity(trawling(_2174)=true).
outputEntity(inSAR(_2174)=true).

event(entersArea(_2296,_2298)).
event(gap_start(_2296)).
event(change_in_speed_start(_2296)).
event(velocity(_2296,_2298,_2300,_2302)).
event(change_in_heading(_2296)).
event(leavesArea(_2296,_2298)).
event(gap_end(_2296)).
event(change_in_speed_end(_2296)).
event(stop_start(_2296)).
event(stop_end(_2296)).
event(slow_motion_start(_2296)).
event(slow_motion_end(_2296)).
event(coord(_2296,_2298,_2300)).

simpleFluent(withinArea(_2436,_2438)=true).
simpleFluent(gap(_2436)=nearPorts).
simpleFluent(gap(_2436)=farFromPorts).
simpleFluent(changingSpeed(_2436)=true).
simpleFluent(trawlSpeed(_2436)=true).
simpleFluent(trawlingMovement(_2436)=true).
simpleFluent(sarSpeed(_2436)=true).
simpleFluent(sarMovement(_2436)=true).
simpleFluent(trawlingMovement(_2436)=false).
simpleFluent(sarMovement(_2436)=false).

sDFluent(trawling(_2552)=true).
sDFluent(inSAR(_2552)=true).
sDFluent(proximity(_2552,_2554)=true).

index(entersArea(_2572,_2626),_2572).
index(gap_start(_2572),_2572).
index(change_in_speed_start(_2572),_2572).
index(velocity(_2572,_2626,_2628,_2630),_2572).
index(change_in_heading(_2572),_2572).
index(leavesArea(_2572,_2626),_2572).
index(gap_end(_2572),_2572).
index(change_in_speed_end(_2572),_2572).
index(stop_start(_2572),_2572).
index(stop_end(_2572),_2572).
index(slow_motion_start(_2572),_2572).
index(slow_motion_end(_2572),_2572).
index(coord(_2572,_2626,_2628),_2572).
index(withinArea(_2572,_2632)=true,_2572).
index(gap(_2572)=nearPorts,_2572).
index(gap(_2572)=farFromPorts,_2572).
index(changingSpeed(_2572)=true,_2572).
index(trawlSpeed(_2572)=true,_2572).
index(trawlingMovement(_2572)=true,_2572).
index(sarSpeed(_2572)=true,_2572).
index(sarMovement(_2572)=true,_2572).
index(trawlingMovement(_2572)=false,_2572).
index(sarMovement(_2572)=false,_2572).
index(trawling(_2572)=true,_2572).
index(inSAR(_2572)=true,_2572).
index(proximity(_2572,_2632)=true,_2572).


cachingOrder2(_2962, withinArea(_2962,_2964)=true) :- % level in dependency graph: 1, processing order in component: 1
     vessel(_2962),areaType(_2964).

cachingOrder2(_3190, gap(_3190)=nearPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3190),portStatus(nearPorts).

cachingOrder2(_3168, gap(_3168)=farFromPorts) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3168),portStatus(farFromPorts).

cachingOrder2(_3130, trawlingMovement(_3130)=true) :- % level in dependency graph: 2, processing order in component: 1
     vessel(_3130),vesselType(_3130,fishing).

cachingOrder2(_3130, trawlingMovement(_3130)=false) :- % level in dependency graph: 2, processing order in component: 2
     vessel(_3130),vesselType(_3130,fishing).

cachingOrder2(_3628, changingSpeed(_3628)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3628).

cachingOrder2(_3606, trawlSpeed(_3606)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3606),vesselType(_3606,fishing).

cachingOrder2(_3584, sarSpeed(_3584)=true) :- % level in dependency graph: 3, processing order in component: 1
     vessel(_3584),vesselType(_3584,sar).

cachingOrder2(_3954, sarMovement(_3954)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3954),vesselType(_3954,sar).

cachingOrder2(_3954, sarMovement(_3954)=false) :- % level in dependency graph: 4, processing order in component: 2
     vessel(_3954),vesselType(_3954,sar).

cachingOrder2(_3932, trawling(_3932)=true) :- % level in dependency graph: 4, processing order in component: 1
     vessel(_3932).

cachingOrder2(_4274, inSAR(_4274)=true) :- % level in dependency graph: 5, processing order in component: 1
     vessel(_4274).

collectGrounds([entersArea(_2574,_2588), gap_start(_2574), change_in_speed_start(_2574), velocity(_2574,_2588,_2590,_2592), change_in_heading(_2574), leavesArea(_2574,_2588), gap_end(_2574), change_in_speed_end(_2574), stop_start(_2574), stop_end(_2574), slow_motion_start(_2574), slow_motion_end(_2574), coord(_2574,_2588,_2590)],vessel(_2574)).

collectGrounds([proximity(_2562,_2564)=true],vpair(_2562,_2564)).

dgrounded(withinArea(_3108,_3110)=true, vessel(_3108)).
dgrounded(gap(_3066)=nearPorts, vessel(_3066)).
dgrounded(gap(_3024)=farFromPorts, vessel(_3024)).
dgrounded(changingSpeed(_2992)=true, vessel(_2992)).
dgrounded(trawlSpeed(_2948)=true, vessel(_2948)).
dgrounded(trawlingMovement(_2904)=true, vessel(_2904)).
dgrounded(sarSpeed(_2860)=true, vessel(_2860)).
dgrounded(sarMovement(_2816)=true, vessel(_2816)).
dgrounded(trawlingMovement(_2772)=false, vessel(_2772)).
dgrounded(sarMovement(_2728)=false, vessel(_2728)).
dgrounded(trawling(_2696)=true, vessel(_2696)).
dgrounded(inSAR(_2664)=true, vessel(_2664)).
