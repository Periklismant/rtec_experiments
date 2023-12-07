:- dynamic vessel/1, vpair/2.

initiatedAt(withinArea(_3330,_3332)=true, _3362, _3300, _3368) :-
     happensAtIE(entersArea(_3330,_3338),_3300),_3362=<_3300,_3300<_3368,
     areaType(_3338,_3332).

initiatedAt(gap(_3330)=nearPorts, _3370, _3300, _3376) :-
     happensAtIE(gap_start(_3330),_3300),_3370=<_3300,_3300<_3376,
     holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,nearPorts)=true,_3300).

initiatedAt(gap(_3330)=farFromPorts, _3374, _3300, _3380) :-
     happensAtIE(gap_start(_3330),_3300),_3374=<_3300,_3300<_3380,
     \+holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,nearPorts)=true,_3300).

initiatedAt(stopped(_3330)=nearPorts, _3370, _3300, _3376) :-
     happensAtIE(stop_start(_3330),_3300),_3370=<_3300,_3300<_3376,
     holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,nearPorts)=true,_3300).

initiatedAt(stopped(_3330)=farFromPorts, _3374, _3300, _3380) :-
     happensAtIE(stop_start(_3330),_3300),_3374=<_3300,_3300<_3380,
     \+holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,nearPorts)=true,_3300).

initiatedAt(lowSpeed(_3330)=true, _3346, _3300, _3352) :-
     happensAtIE(slow_motion_start(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

initiatedAt(changingSpeed(_3330)=true, _3346, _3300, _3352) :-
     happensAtIE(change_in_speed_start(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

initiatedAt(highSpeedNearCoast(_3330)=true, _3406, _3300, _3412) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3406=<_3300,_3300<_3412,
     thresholds(hcNearCoastMax,_3352),
     \+inRange(_3336,0,_3352),
     holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,nearCoast)=true,_3300).

initiatedAt(movingSpeed(_3330)=below, _3406, _3300, _3412) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3406=<_3300,_3300<_3412,
     vesselType(_3330,_3352),
     typeSpeed(_3352,_3358,_3360,_3362),
     thresholds(movingMin,_3368),
     inRange(_3336,_3368,_3358).

initiatedAt(movingSpeed(_3330)=normal, _3394, _3300, _3400) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3394=<_3300,_3300<_3400,
     vesselType(_3330,_3352),
     typeSpeed(_3352,_3358,_3360,_3362),
     inRange(_3336,_3358,_3360).

initiatedAt(movingSpeed(_3330)=above, _3394, _3300, _3400) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3394=<_3300,_3300<_3400,
     vesselType(_3330,_3352),
     typeSpeed(_3352,_3358,_3360,_3362),
     inRange(_3336,_3360,inf).

initiatedAt(drifting(_3330)=true, _3430, _3300, _3436) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3430=<_3300,_3300<_3436,
     _3340=\=511.0,
     absoluteAngleDiff(_3338,_3340,_3366),
     thresholds(adriftAngThr,_3372),
     _3366>_3372,
     holdsAtProcessedSDFluent(_3330,underWay(_3330)=true,_3300).

initiatedAt(tuggingSpeed(_3330)=true, _3390, _3300, _3396) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3390=<_3300,_3300<_3396,
     thresholds(tuggingMin,_3352),
     thresholds(tuggingMax,_3358),
     inRange(_3336,_3352,_3358).

initiatedAt(trawlSpeed(_3330)=true, _3414, _3300, _3420) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3414=<_3300,_3300<_3420,
     thresholds(trawlspeedMin,_3352),
     thresholds(trawlspeedMax,_3358),
     inRange(_3336,_3352,_3358),
     holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,fishing)=true,_3300).

initiatedAt(trawlingMovement(_3330)=true, _3370, _3300, _3376) :-
     happensAtIE(change_in_heading(_3330),_3300),_3370=<_3300,_3300<_3376,
     holdsAtProcessedSimpleFluent(_3330,withinArea(_3330,fishing)=true,_3300).

initiatedAt(sarSpeed(_3330)=true, _3378, _3300, _3384) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3378=<_3300,_3300<_3384,
     thresholds(sarMinSpeed,_3352),
     inRange(_3336,_3352,inf).

initiatedAt(sarMovement(_3330)=true, _3346, _3300, _3352) :-
     happensAtIE(change_in_heading(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

initiatedAt(sarMovement(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(changingSpeed(_3330)=true),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(withinArea(_3330,_3332)=true, _3362, _3300, _3368) :-
     happensAtIE(leavesArea(_3330,_3338),_3300),_3362=<_3300,_3300<_3368,
     areaType(_3338,_3332).

terminatedAt(withinArea(_3330,_3332)=true, _3348, _3300, _3354) :-
     happensAtIE(gap_start(_3330),_3300),
     _3348=<_3300,
     _3300<_3354.

terminatedAt(gap(_3330)=_3306, _3346, _3300, _3352) :-
     happensAtIE(gap_end(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

terminatedAt(stopped(_3330)=_3306, _3346, _3300, _3352) :-
     happensAtIE(stop_end(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

terminatedAt(stopped(_3330)=_3306, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(lowSpeed(_3330)=true, _3346, _3300, _3352) :-
     happensAtIE(slow_motion_end(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

terminatedAt(lowSpeed(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(changingSpeed(_3330)=true, _3346, _3300, _3352) :-
     happensAtIE(change_in_speed_end(_3330),_3300),
     _3346=<_3300,
     _3300<_3352.

terminatedAt(changingSpeed(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(highSpeedNearCoast(_3330)=true, _3378, _3300, _3384) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3378=<_3300,_3300<_3384,
     thresholds(hcNearCoastMax,_3352),
     inRange(_3336,0,_3352).

terminatedAt(highSpeedNearCoast(_3330)=true, _3358, _3300, _3364) :-
     happensAtProcessedSimpleFluent(_3330,end(withinArea(_3330,nearCoast)=true),_3300),
     _3358=<_3300,
     _3300<_3364.

terminatedAt(movingSpeed(_3330)=_3306, _3382, _3300, _3388) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3382=<_3300,_3300<_3388,
     thresholds(movingMin,_3352),
     \+inRange(_3336,_3352,inf).

terminatedAt(movingSpeed(_3330)=_3306, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(drifting(_3330)=true, _3390, _3300, _3396) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3390=<_3300,_3300<_3396,
     absoluteAngleDiff(_3338,_3340,_3354),
     thresholds(adriftAngThr,_3360),
     _3354=<_3360.

terminatedAt(drifting(_3330)=true, _3358, _3300, _3364) :-
     happensAtIE(velocity(_3330,_3336,_3338,511.0),_3300),
     _3358=<_3300,
     _3300<_3364.

terminatedAt(drifting(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSDFluent(_3330,end(underWay(_3330)=true),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(tuggingSpeed(_3330)=true, _3394, _3300, _3400) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3394=<_3300,_3300<_3400,
     thresholds(tuggingMin,_3352),
     thresholds(tuggingMax,_3358),
     \+inRange(_3336,_3352,_3358).

terminatedAt(tuggingSpeed(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(trawlSpeed(_3330)=true, _3394, _3300, _3400) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3394=<_3300,_3300<_3400,
     thresholds(trawlspeedMin,_3352),
     thresholds(trawlspeedMax,_3358),
     \+inRange(_3336,_3352,_3358).

terminatedAt(trawlSpeed(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(trawlSpeed(_3330)=true, _3358, _3300, _3364) :-
     happensAtProcessedSimpleFluent(_3330,end(withinArea(_3330,fishing)=true),_3300),
     _3358=<_3300,
     _3300<_3364.

terminatedAt(trawlingMovement(_3330)=true, _3358, _3300, _3364) :-
     happensAtProcessedSimpleFluent(_3330,end(withinArea(_3330,fishing)=true),_3300),
     _3358=<_3300,
     _3300<_3364.

terminatedAt(sarSpeed(_3330)=true, _3378, _3300, _3384) :-
     happensAtIE(velocity(_3330,_3336,_3338,_3340),_3300),_3378=<_3300,_3300<_3384,
     thresholds(sarMinSpeed,_3352),
     inRange(_3336,0,_3352).

terminatedAt(sarSpeed(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

terminatedAt(sarMovement(_3330)=true, _3356, _3300, _3362) :-
     happensAtProcessedSimpleFluent(_3330,start(gap(_3330)=_3340),_3300),
     _3356=<_3300,
     _3300<_3362.

holdsForSDFluent(underWay(_3330)=true,_3300) :-
     holdsForProcessedSimpleFluent(_3330,movingSpeed(_3330)=below,_3346),
     holdsForProcessedSimpleFluent(_3330,movingSpeed(_3330)=normal,_3362),
     holdsForProcessedSimpleFluent(_3330,movingSpeed(_3330)=above,_3378),
     union_all([_3346,_3362,_3378],_3300).

holdsForSDFluent(anchoredOrMoored(_3330)=true,_3300) :-
     holdsForProcessedSimpleFluent(_3330,stopped(_3330)=farFromPorts,_3346),
     holdsForProcessedSimpleFluent(_3330,withinArea(_3330,anchorage)=true,_3364),
     intersect_all([_3346,_3364],_3382),
     holdsForProcessedSimpleFluent(_3330,stopped(_3330)=nearPorts,_3398),
     union_all([_3382,_3398],_3416),
     thresholds(aOrMTime,_3422),
     intDurGreater(_3416,_3422,_3300).

holdsForSDFluent(tugging(_3330,_3332)=true,_3300) :-
     holdsForProcessedIE(_3330,proximity(_3330,_3332)=true,_3350),
     oneIsTug(_3330,_3332),
     \+oneIsPilot(_3330,_3332),
     \+twoAreTugs(_3330,_3332),
     holdsForProcessedSimpleFluent(_3330,tuggingSpeed(_3330)=true,_3392),
     holdsForProcessedSimpleFluent(_3332,tuggingSpeed(_3332)=true,_3408),
     intersect_all([_3350,_3392,_3408],_3432),
     thresholds(tuggingTime,_3438),
     intDurGreater(_3432,_3438,_3300).

holdsForSDFluent(rendezVous(_3330,_3332)=true,_3300) :-
     holdsForProcessedIE(_3330,proximity(_3330,_3332)=true,_3350),
     \+oneIsTug(_3330,_3332),
     \+oneIsPilot(_3330,_3332),
     holdsForProcessedSimpleFluent(_3330,lowSpeed(_3330)=true,_3386),
     holdsForProcessedSimpleFluent(_3332,lowSpeed(_3332)=true,_3402),
     holdsForProcessedSimpleFluent(_3330,stopped(_3330)=farFromPorts,_3418),
     holdsForProcessedSimpleFluent(_3332,stopped(_3332)=farFromPorts,_3434),
     union_all([_3386,_3418],_3452),
     union_all([_3402,_3434],_3470),
     intersect_all([_3452,_3470,_3350],_3494),
     _3494\=[],
     holdsForProcessedSimpleFluent(_3330,withinArea(_3330,nearPorts)=true,_3518),
     holdsForProcessedSimpleFluent(_3332,withinArea(_3332,nearPorts)=true,_3536),
     holdsForProcessedSimpleFluent(_3330,withinArea(_3330,nearCoast)=true,_3554),
     holdsForProcessedSimpleFluent(_3332,withinArea(_3332,nearCoast)=true,_3572),
     relative_complement_all(_3494,[_3518,_3536,_3554,_3572],_3604),
     thresholds(rendezvousTime,_3610),
     intDurGreater(_3604,_3610,_3300).

holdsForSDFluent(trawling(_3330)=true,_3300) :-
     holdsForProcessedSimpleFluent(_3330,trawlSpeed(_3330)=true,_3346),
     holdsForProcessedSimpleFluent(_3330,trawlingMovement(_3330)=true,_3362),
     intersect_all([_3346,_3362],_3380),
     thresholds(trawlingTime,_3386),
     intDurGreater(_3380,_3386,_3300).

holdsForSDFluent(inSAR(_3330)=true,_3300) :-
     holdsForProcessedSimpleFluent(_3330,sarSpeed(_3330)=true,_3346),
     holdsForProcessedSimpleFluent(_3330,sarMovement(_3330)=true,_3362),
     intersect_all([_3346,_3362],_3380),
     intDurGreater(_3380,3600,_3300).

holdsForSDFluent(loitering(_3330)=true,_3300) :-
     holdsForProcessedSimpleFluent(_3330,lowSpeed(_3330)=true,_3346),
     holdsForProcessedSimpleFluent(_3330,stopped(_3330)=farFromPorts,_3362),
     union_all([_3346,_3362],_3380),
     holdsForProcessedSimpleFluent(_3330,withinArea(_3330,nearCoast)=true,_3398),
     holdsForProcessedSDFluent(_3330,anchoredOrMoored(_3330)=true,_3414),
     relative_complement_all(_3380,[_3398,_3414],_3434),
     thresholds(loiteringTime,_3440),
     intDurGreater(_3434,_3440,_3300).

holdsForSDFluent(pilotOps(_3330,_3332)=true,_3300) :-
     holdsForProcessedIE(_3330,proximity(_3330,_3332)=true,_3350),
     oneIsPilot(_3330,_3332),
     holdsForProcessedSimpleFluent(_3330,lowSpeed(_3330)=true,_3372),
     holdsForProcessedSimpleFluent(_3332,lowSpeed(_3332)=true,_3388),
     holdsForProcessedSimpleFluent(_3330,stopped(_3330)=farFromPorts,_3404),
     holdsForProcessedSimpleFluent(_3332,stopped(_3332)=farFromPorts,_3420),
     union_all([_3372,_3404],_3438),
     union_all([_3388,_3420],_3456),
     intersect_all([_3438,_3456,_3350],_3480),
     _3480\=[],
     holdsForProcessedSimpleFluent(_3330,withinArea(_3330,nearCoast)=true,_3504),
     holdsForProcessedSimpleFluent(_3332,withinArea(_3332,nearCoast)=true,_3522),
     relative_complement_all(_3480,[_3504,_3522],_3300).

fi(trawlingMovement(_3340)=true,trawlingMovement(_3340)=false,_3302):-
     thresholds(trawlingCrs,_3302),
     grounding(trawlingMovement(_3340)=true),
     grounding(trawlingMovement(_3340)=false).

fi(sarMovement(_3334)=true,sarMovement(_3334)=false,1800):-
     grounding(sarMovement(_3334)=true),
     grounding(sarMovement(_3334)=false).

p(trawlingMovement(_3672)=true).

p(sarMovement(_3672)=true).

collectIntervals2(_3304, proximity(_3304,_3306)=true) :-
     vpair(_3304,_3306).

needsGrounding(_3490,_3492,_3494) :- 
     fail.

grounding(change_in_speed_start(_3672)) :- 
     vessel(_3672).

grounding(change_in_speed_end(_3672)) :- 
     vessel(_3672).

grounding(change_in_heading(_3672)) :- 
     vessel(_3672).

grounding(stop_start(_3672)) :- 
     vessel(_3672).

grounding(stop_end(_3672)) :- 
     vessel(_3672).

grounding(slow_motion_start(_3672)) :- 
     vessel(_3672).

grounding(slow_motion_end(_3672)) :- 
     vessel(_3672).

grounding(gap_start(_3672)) :- 
     vessel(_3672).

grounding(gap_end(_3672)) :- 
     vessel(_3672).

grounding(entersArea(_3672,_3674)) :- 
     vessel(_3672),areaType(_3674).

grounding(leavesArea(_3672,_3674)) :- 
     vessel(_3672),areaType(_3674).

grounding(coord(_3672,_3674,_3676)) :- 
     vessel(_3672).

grounding(velocity(_3672,_3674,_3676,_3678)) :- 
     vessel(_3672).

grounding(proximity(_3678,_3680)=true) :- 
     vpair(_3678,_3680).

grounding(gap(_3678)=_3674) :- 
     vessel(_3678),portStatus(_3674).

grounding(stopped(_3678)=_3674) :- 
     vessel(_3678),portStatus(_3674).

grounding(lowSpeed(_3678)=true) :- 
     vessel(_3678).

grounding(changingSpeed(_3678)=true) :- 
     vessel(_3678).

grounding(withinArea(_3678,_3680)=true) :- 
     vessel(_3678),areaType(_3680).

grounding(underWay(_3678)=true) :- 
     vessel(_3678).

grounding(sarSpeed(_3678)=true) :- 
     vessel(_3678),vesselType(_3678,sar).

grounding(sarMovement(_3678)=true) :- 
     vessel(_3678),vesselType(_3678,sar).

grounding(sarMovement(_3678)=false) :- 
     vessel(_3678),vesselType(_3678,sar).

grounding(inSAR(_3678)=true) :- 
     vessel(_3678).

grounding(highSpeedNearCoast(_3678)=true) :- 
     vessel(_3678).

grounding(drifting(_3678)=true) :- 
     vessel(_3678).

grounding(anchoredOrMoored(_3678)=true) :- 
     vessel(_3678).

grounding(trawlSpeed(_3678)=true) :- 
     vessel(_3678),vesselType(_3678,fishing).

grounding(movingSpeed(_3678)=_3674) :- 
     vessel(_3678),movingStatus(_3674).

grounding(pilotOps(_3678,_3680)=true) :- 
     vpair(_3678,_3680).

grounding(tuggingSpeed(_3678)=true) :- 
     vessel(_3678).

grounding(tugging(_3678,_3680)=true) :- 
     vpair(_3678,_3680).

grounding(rendezVous(_3678,_3680)=true) :- 
     vpair(_3678,_3680).

grounding(trawlingMovement(_3678)=true) :- 
     vessel(_3678),vesselType(_3678,fishing).

grounding(trawlingMovement(_3678)=false) :- 
     vessel(_3678),vesselType(_3678,fishing).

grounding(trawling(_3678)=true) :- 
     vessel(_3678).

grounding(loitering(_3678)=true) :- 
     vessel(_3678).

inputEntity(entersArea(_3360,_3362)).
inputEntity(gap_start(_3360)).
inputEntity(stop_start(_3360)).
inputEntity(slow_motion_start(_3360)).
inputEntity(change_in_speed_start(_3360)).
inputEntity(velocity(_3360,_3362,_3364,_3366)).
inputEntity(change_in_heading(_3360)).
inputEntity(leavesArea(_3360,_3362)).
inputEntity(gap_end(_3360)).
inputEntity(stop_end(_3360)).
inputEntity(slow_motion_end(_3360)).
inputEntity(change_in_speed_end(_3360)).
inputEntity(proximity(_3366,_3368)=true).
inputEntity(coord(_3360,_3362,_3364)).

outputEntity(withinArea(_3512,_3514)=true).
outputEntity(gap(_3512)=nearPorts).
outputEntity(gap(_3512)=farFromPorts).
outputEntity(stopped(_3512)=nearPorts).
outputEntity(stopped(_3512)=farFromPorts).
outputEntity(lowSpeed(_3512)=true).
outputEntity(changingSpeed(_3512)=true).
outputEntity(highSpeedNearCoast(_3512)=true).
outputEntity(movingSpeed(_3512)=below).
outputEntity(movingSpeed(_3512)=normal).
outputEntity(movingSpeed(_3512)=above).
outputEntity(drifting(_3512)=true).
outputEntity(tuggingSpeed(_3512)=true).
outputEntity(trawlSpeed(_3512)=true).
outputEntity(trawlingMovement(_3512)=true).
outputEntity(sarSpeed(_3512)=true).
outputEntity(sarMovement(_3512)=true).
outputEntity(trawlingMovement(_3512)=false).
outputEntity(sarMovement(_3512)=false).
outputEntity(underWay(_3512)=true).
outputEntity(anchoredOrMoored(_3512)=true).
outputEntity(tugging(_3512,_3514)=true).
outputEntity(rendezVous(_3512,_3514)=true).
outputEntity(trawling(_3512)=true).
outputEntity(inSAR(_3512)=true).
outputEntity(loitering(_3512)=true).
outputEntity(pilotOps(_3512,_3514)=true).

event(entersArea(_3730,_3732)).
event(gap_start(_3730)).
event(stop_start(_3730)).
event(slow_motion_start(_3730)).
event(change_in_speed_start(_3730)).
event(velocity(_3730,_3732,_3734,_3736)).
event(change_in_heading(_3730)).
event(leavesArea(_3730,_3732)).
event(gap_end(_3730)).
event(stop_end(_3730)).
event(slow_motion_end(_3730)).
event(change_in_speed_end(_3730)).
event(coord(_3730,_3732,_3734)).

simpleFluent(withinArea(_3876,_3878)=true).
simpleFluent(gap(_3876)=nearPorts).
simpleFluent(gap(_3876)=farFromPorts).
simpleFluent(stopped(_3876)=nearPorts).
simpleFluent(stopped(_3876)=farFromPorts).
simpleFluent(lowSpeed(_3876)=true).
simpleFluent(changingSpeed(_3876)=true).
simpleFluent(highSpeedNearCoast(_3876)=true).
simpleFluent(movingSpeed(_3876)=below).
simpleFluent(movingSpeed(_3876)=normal).
simpleFluent(movingSpeed(_3876)=above).
simpleFluent(drifting(_3876)=true).
simpleFluent(tuggingSpeed(_3876)=true).
simpleFluent(trawlSpeed(_3876)=true).
simpleFluent(trawlingMovement(_3876)=true).
simpleFluent(sarSpeed(_3876)=true).
simpleFluent(sarMovement(_3876)=true).
simpleFluent(trawlingMovement(_3876)=false).
simpleFluent(sarMovement(_3876)=false).

sDFluent(underWay(_4052)=true).
sDFluent(anchoredOrMoored(_4052)=true).
sDFluent(tugging(_4052,_4054)=true).
sDFluent(rendezVous(_4052,_4054)=true).
sDFluent(trawling(_4052)=true).
sDFluent(inSAR(_4052)=true).
sDFluent(loitering(_4052)=true).
sDFluent(pilotOps(_4052,_4054)=true).
sDFluent(proximity(_4052,_4054)=true).

index(entersArea(_4108,_4168),_4108).
index(gap_start(_4108),_4108).
index(stop_start(_4108),_4108).
index(slow_motion_start(_4108),_4108).
index(change_in_speed_start(_4108),_4108).
index(velocity(_4108,_4168,_4170,_4172),_4108).
index(change_in_heading(_4108),_4108).
index(leavesArea(_4108,_4168),_4108).
index(gap_end(_4108),_4108).
index(stop_end(_4108),_4108).
index(slow_motion_end(_4108),_4108).
index(change_in_speed_end(_4108),_4108).
index(coord(_4108,_4168,_4170),_4108).
index(withinArea(_4108,_4174)=true,_4108).
index(gap(_4108)=nearPorts,_4108).
index(gap(_4108)=farFromPorts,_4108).
index(stopped(_4108)=nearPorts,_4108).
index(stopped(_4108)=farFromPorts,_4108).
index(lowSpeed(_4108)=true,_4108).
index(changingSpeed(_4108)=true,_4108).
index(highSpeedNearCoast(_4108)=true,_4108).
index(movingSpeed(_4108)=below,_4108).
index(movingSpeed(_4108)=normal,_4108).
index(movingSpeed(_4108)=above,_4108).
index(drifting(_4108)=true,_4108).
index(tuggingSpeed(_4108)=true,_4108).
index(trawlSpeed(_4108)=true,_4108).
index(trawlingMovement(_4108)=true,_4108).
index(sarSpeed(_4108)=true,_4108).
index(sarMovement(_4108)=true,_4108).
index(trawlingMovement(_4108)=false,_4108).
index(sarMovement(_4108)=false,_4108).
index(underWay(_4108)=true,_4108).
index(anchoredOrMoored(_4108)=true,_4108).
index(tugging(_4108,_4174)=true,_4108).
index(rendezVous(_4108,_4174)=true,_4108).
index(trawling(_4108)=true,_4108).
index(inSAR(_4108)=true,_4108).
index(loitering(_4108)=true,_4108).
index(pilotOps(_4108,_4174)=true,_4108).
index(proximity(_4108,_4174)=true,_4108).


cachingOrder2(_4600, withinArea(_4600,_4602)=true) :- % level: 1
     vessel(_4600),areaType(_4602).

cachingOrder2(_4764, gap(_4764)=nearPorts) :- % level: 2
     vessel(_4764),portStatus(nearPorts).

cachingOrder2(_4748, gap(_4748)=farFromPorts) :- % level: 2
     vessel(_4748),portStatus(farFromPorts).

cachingOrder2(_4732, highSpeedNearCoast(_4732)=true) :- % level: 2
     vessel(_4732).

cachingOrder2(_4716, trawlingMovement(_4716)=true) :- % level: 2
     vessel(_4716),vesselType(_4716,fishing).

cachingOrder2(_5138, stopped(_5138)=nearPorts) :- % level: 3
     vessel(_5138),portStatus(nearPorts).

cachingOrder2(_5122, stopped(_5122)=farFromPorts) :- % level: 3
     vessel(_5122),portStatus(farFromPorts).

cachingOrder2(_5106, lowSpeed(_5106)=true) :- % level: 3
     vessel(_5106).

cachingOrder2(_5090, changingSpeed(_5090)=true) :- % level: 3
     vessel(_5090).

cachingOrder2(_5074, movingSpeed(_5074)=below) :- % level: 3
     vessel(_5074),movingStatus(below).

cachingOrder2(_5058, movingSpeed(_5058)=normal) :- % level: 3
     vessel(_5058),movingStatus(normal).

cachingOrder2(_5042, movingSpeed(_5042)=above) :- % level: 3
     vessel(_5042),movingStatus(above).

cachingOrder2(_5026, tuggingSpeed(_5026)=true) :- % level: 3
     vessel(_5026).

cachingOrder2(_5010, trawlSpeed(_5010)=true) :- % level: 3
     vessel(_5010),vesselType(_5010,fishing).

cachingOrder2(_4994, sarSpeed(_4994)=true) :- % level: 3
     vessel(_4994),vesselType(_4994,sar).

cachingOrder2(_5704, sarMovement(_5704)=true) :- % level: 4
     vessel(_5704),vesselType(_5704,sar).

cachingOrder2(_5688, underWay(_5688)=true) :- % level: 4
     vessel(_5688).

cachingOrder2(_5672, anchoredOrMoored(_5672)=true) :- % level: 4
     vessel(_5672).

cachingOrder2(_5654, tugging(_5654,_5656)=true) :- % level: 4
     vpair(_5654,_5656).

cachingOrder2(_5636, rendezVous(_5636,_5638)=true) :- % level: 4
     vpair(_5636,_5638).

cachingOrder2(_5620, trawling(_5620)=true) :- % level: 4
     vessel(_5620).

cachingOrder2(_5602, pilotOps(_5602,_5604)=true) :- % level: 4
     vpair(_5602,_5604).

cachingOrder2(_6070, drifting(_6070)=true) :- % level: 5
     vessel(_6070).

cachingOrder2(_6054, sarMovement(_6054)=false) :- % level: 5
     vessel(_6054),vesselType(_6054,sar).

cachingOrder2(_6038, inSAR(_6038)=true) :- % level: 5
     vessel(_6038).

cachingOrder2(_6022, loitering(_6022)=true) :- % level: 5
     vessel(_6022).

collectGrounds([entersArea(_3912,_3926), gap_start(_3912), stop_start(_3912), slow_motion_start(_3912), change_in_speed_start(_3912), velocity(_3912,_3926,_3928,_3930), change_in_heading(_3912), leavesArea(_3912,_3926), gap_end(_3912), stop_end(_3912), slow_motion_end(_3912), change_in_speed_end(_3912), coord(_3912,_3926,_3928)],vessel(_3912)).

collectGrounds([proximity(_3900,_3902)=true],vpair(_3900,_3902)).

dgrounded(withinArea(_4994,_4996)=true, vessel(_4994)).
dgrounded(gap(_4952)=nearPorts, vessel(_4952)).
dgrounded(gap(_4910)=farFromPorts, vessel(_4910)).
dgrounded(stopped(_4868)=nearPorts, vessel(_4868)).
dgrounded(stopped(_4826)=farFromPorts, vessel(_4826)).
dgrounded(lowSpeed(_4794)=true, vessel(_4794)).
dgrounded(changingSpeed(_4762)=true, vessel(_4762)).
dgrounded(highSpeedNearCoast(_4730)=true, vessel(_4730)).
dgrounded(movingSpeed(_4688)=below, vessel(_4688)).
dgrounded(movingSpeed(_4646)=normal, vessel(_4646)).
dgrounded(movingSpeed(_4604)=above, vessel(_4604)).
dgrounded(drifting(_4572)=true, vessel(_4572)).
dgrounded(tuggingSpeed(_4540)=true, vessel(_4540)).
dgrounded(trawlSpeed(_4496)=true, vessel(_4496)).
dgrounded(trawlingMovement(_4452)=true, vessel(_4452)).
dgrounded(sarSpeed(_4408)=true, vessel(_4408)).
dgrounded(sarMovement(_4364)=true, vessel(_4364)).
dgrounded(trawlingMovement(_4320)=false, vessel(_4320)).
dgrounded(sarMovement(_4276)=false, vessel(_4276)).
dgrounded(underWay(_4244)=true, vessel(_4244)).
dgrounded(anchoredOrMoored(_4212)=true, vessel(_4212)).
dgrounded(tugging(_4176,_4178)=true, vpair(_4176,_4178)).
dgrounded(rendezVous(_4140,_4142)=true, vpair(_4140,_4142)).
dgrounded(trawling(_4108)=true, vessel(_4108)).
dgrounded(inSAR(_4076)=true, vessel(_4076)).
dgrounded(loitering(_4044)=true, vessel(_4044)).
dgrounded(pilotOps(_4008,_4010)=true, vpair(_4008,_4010)).
