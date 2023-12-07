initiatedAt(withinArea(_131139,_131140)=true, _131153, _131124, _131155) :-
     happensAtIE(entersArea(_131139,_131149),_131124),_131153=<_131124,_131124<_131155,
     areaType(_131149,_131140).

initiatedAt(gap(_131139)=nearPorts, _131157, _131124, _131159) :-
     happensAtIE(gap_start(_131139),_131124),_131157=<_131124,_131124<_131159,
     holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,nearPorts)=true,_131124).

initiatedAt(gap(_131139)=farFromPorts, _131159, _131124, _131161) :-
     happensAtIE(gap_start(_131139),_131124),_131159=<_131124,_131124<_131161,
     \+holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,nearPorts)=true,_131124).

initiatedAt(stopped(_131139)=nearPorts, _131157, _131124, _131159) :-
     happensAtIE(stop_start(_131139),_131124),_131157=<_131124,_131124<_131159,
     holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,nearPorts)=true,_131124).

initiatedAt(stopped(_131139)=farFromPorts, _131159, _131124, _131161) :-
     happensAtIE(stop_start(_131139),_131124),_131159=<_131124,_131124<_131161,
     \+holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,nearPorts)=true,_131124).

initiatedAt(lowSpeed(_131139)=true, _131145, _131124, _131147) :-
     happensAtIE(slow_motion_start(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

initiatedAt(changingSpeed(_131139)=true, _131145, _131124, _131147) :-
     happensAtIE(change_in_speed_start(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

initiatedAt(highSpeedNearCoast(_131139)=true, _131175, _131124, _131177) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131175=<_131124,_131124<_131177,
     thresholds(hcNearCoastMax,_131156),
     \+inRange(_131148,0,_131156),
     holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,nearCoast)=true,_131124).

initiatedAt(movingSpeed(_131139)=below, _131175, _131124, _131177) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131175=<_131124,_131124<_131177,
     vesselType(_131139,_131156),
     typeSpeed(_131156,_131162,_131163,_131164),
     thresholds(movingMin,_131170),
     inRange(_131148,_131170,_131162).

initiatedAt(movingSpeed(_131139)=normal, _131169, _131124, _131171) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131169=<_131124,_131124<_131171,
     vesselType(_131139,_131156),
     typeSpeed(_131156,_131162,_131163,_131164),
     inRange(_131148,_131162,_131163).

initiatedAt(movingSpeed(_131139)=above, _131169, _131124, _131171) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131169=<_131124,_131124<_131171,
     vesselType(_131139,_131156),
     typeSpeed(_131156,_131162,_131163,_131164),
     inRange(_131148,_131163,inf).

initiatedAt(drifting(_131139)=true, _131187, _131124, _131189) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131187=<_131124,_131124<_131189,
     _131150=\=511.0,
     absoluteAngleDiff(_131149,_131150,_131166),
     thresholds(adriftAngThr,_131172),
     _131166>_131172,
     holdsAtProcessedSDFluent(_131139,underWay(_131139)=true,_131124).

initiatedAt(tuggingSpeed(_131139)=true, _131167, _131124, _131169) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131167=<_131124,_131124<_131169,
     thresholds(tuggingMin,_131156),
     thresholds(tuggingMax,_131162),
     inRange(_131148,_131156,_131162).

initiatedAt(trawlSpeed(_131139)=true, _131179, _131124, _131181) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131179=<_131124,_131124<_131181,
     thresholds(trawlspeedMin,_131156),
     thresholds(trawlspeedMax,_131162),
     inRange(_131148,_131156,_131162),
     holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,fishing)=true,_131124).

initiatedAt(trawlingMovement(_131139)=true, _131157, _131124, _131159) :-
     happensAtIE(change_in_heading(_131139),_131124),_131157=<_131124,_131124<_131159,
     holdsAtProcessedSimpleFluent(_131139,withinArea(_131139,fishing)=true,_131124).

initiatedAt(sarSpeed(_131139)=true, _131161, _131124, _131163) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131161=<_131124,_131124<_131163,
     thresholds(sarMinSpeed,_131156),
     inRange(_131148,_131156,inf).

initiatedAt(sarMovement(_131139)=true, _131145, _131124, _131147) :-
     happensAtIE(change_in_heading(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

initiatedAt(sarMovement(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(changingSpeed(_131139)=true),_131124),
     _131150=<_131124,
     _131124<_131152.

initiatedAt(fishingTripStatus(_131139)=aomni, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(anchoredOrMoored(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=null,_131124).

initiatedAt(fishingTripStatus(_131139)=aomni, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(anchoredOrMoored(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=underWay,_131124).

initiatedAt(fishingTripStatus(_131139)=aomi, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(anchoredOrMoored(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=interrupted,_131124).

initiatedAt(fishingTripStatus(_131139)=underWay, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(underWay(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=null,_131124).

initiatedAt(fishingTripStatus(_131139)=underWay, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(underWay(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=aomni,_131124).

initiatedAt(fishingTripStatus(_131139)=underWay, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(underWay(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=aomi,_131124).

initiatedAt(fishingTripStatus(_131139)=underWay, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(underWay(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=trawling,_131124).

initiatedAt(fishingTripStatus(_131139)=trawling, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(trawling(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=underWay,_131124).

initiatedAt(fishingTripStatus(_131139)=interrupted, _131164, _131124, _131166) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131150),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=underWay,_131124).

initiatedAt(fishingTripStatus(_131139)=interrupted, _131164, _131124, _131166) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131150),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=trawling,_131124).

initiatedAt(fishingTripStatus(_131139)=interrupted, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(loitering(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=underWay,_131124).

initiatedAt(fishingTripStatus(_131139)=interrupted, _131164, _131124, _131166) :-
     happensAtProcessedSDFluent(_131139,start(loitering(_131139)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtCyclic(_131139,fishingTripStatus(_131139)=trawling,_131124).

initiatedAt(fishingTripStatus(_131143)=null, _131124, -1, _131126) :-
     _131124=<1443650400,
     1443650400<_131126.

terminatedAt(withinArea(_131139,_131140)=true, _131153, _131124, _131155) :-
     happensAtIE(leavesArea(_131139,_131149),_131124),_131153=<_131124,_131124<_131155,
     areaType(_131149,_131140).

terminatedAt(withinArea(_131139,_131140)=true, _131146, _131124, _131148) :-
     happensAtIE(gap_start(_131139),_131124),
     _131146=<_131124,
     _131124<_131148.

terminatedAt(gap(_131139)=_131127, _131145, _131124, _131147) :-
     happensAtIE(gap_end(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

terminatedAt(stopped(_131139)=_131127, _131145, _131124, _131147) :-
     happensAtIE(stop_end(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

terminatedAt(stopped(_131139)=_131127, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(lowSpeed(_131139)=true, _131145, _131124, _131147) :-
     happensAtIE(slow_motion_end(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

terminatedAt(lowSpeed(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(changingSpeed(_131139)=true, _131145, _131124, _131147) :-
     happensAtIE(change_in_speed_end(_131139),_131124),
     _131145=<_131124,
     _131124<_131147.

terminatedAt(changingSpeed(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(highSpeedNearCoast(_131139)=true, _131161, _131124, _131163) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131161=<_131124,_131124<_131163,
     thresholds(hcNearCoastMax,_131156),
     inRange(_131148,0,_131156).

terminatedAt(highSpeedNearCoast(_131139)=true, _131151, _131124, _131153) :-
     happensAtProcessedSimpleFluent(_131139,end(withinArea(_131139,nearCoast)=true),_131124),
     _131151=<_131124,
     _131124<_131153.

terminatedAt(movingSpeed(_131139)=_131127, _131163, _131124, _131165) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131163=<_131124,_131124<_131165,
     thresholds(movingMin,_131156),
     \+inRange(_131148,_131156,inf).

terminatedAt(movingSpeed(_131139)=_131127, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(drifting(_131139)=true, _131167, _131124, _131169) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131167=<_131124,_131124<_131169,
     absoluteAngleDiff(_131149,_131150,_131157),
     thresholds(adriftAngThr,_131163),
     _131157=<_131163.

terminatedAt(drifting(_131139)=true, _131151, _131124, _131153) :-
     happensAtIE(velocity(_131139,_131145,_131146,511.0),_131124),
     _131151=<_131124,
     _131124<_131153.

terminatedAt(drifting(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSDFluent(_131139,end(underWay(_131139)=true),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(tuggingSpeed(_131139)=true, _131169, _131124, _131171) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131169=<_131124,_131124<_131171,
     thresholds(tuggingMin,_131156),
     thresholds(tuggingMax,_131162),
     \+inRange(_131148,_131156,_131162).

terminatedAt(tuggingSpeed(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(trawlSpeed(_131139)=true, _131169, _131124, _131171) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131169=<_131124,_131124<_131171,
     thresholds(trawlspeedMin,_131156),
     thresholds(trawlspeedMax,_131162),
     \+inRange(_131148,_131156,_131162).

terminatedAt(trawlSpeed(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(trawlSpeed(_131139)=true, _131151, _131124, _131153) :-
     happensAtProcessedSimpleFluent(_131139,end(withinArea(_131139,fishing)=true),_131124),
     _131151=<_131124,
     _131124<_131153.

terminatedAt(trawlingMovement(_131139)=true, _131151, _131124, _131153) :-
     happensAtProcessedSimpleFluent(_131139,end(withinArea(_131139,fishing)=true),_131124),
     _131151=<_131124,
     _131124<_131153.

terminatedAt(sarSpeed(_131139)=true, _131161, _131124, _131163) :-
     happensAtIE(velocity(_131139,_131148,_131149,_131150),_131124),_131161=<_131124,_131124<_131163,
     thresholds(sarMinSpeed,_131156),
     inRange(_131148,0,_131156).

terminatedAt(sarSpeed(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

terminatedAt(sarMovement(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(gap(_131139)=_131147),_131124),
     _131150=<_131124,
     _131124<_131152.

holdsForSDFluent(underWay(_131139)=true,_131124) :-
     holdsForProcessedSimpleFluent(_131139,movingSpeed(_131139)=below,_131145),
     holdsForProcessedSimpleFluent(_131139,movingSpeed(_131139)=normal,_131156),
     holdsForProcessedSimpleFluent(_131139,movingSpeed(_131139)=above,_131167),
     union_all([_131145,_131156,_131167],_131124).

holdsForSDFluent(anchoredOrMoored(_131139)=true,_131124) :-
     holdsForProcessedSimpleFluent(_131139,stopped(_131139)=farFromPorts,_131145),
     holdsForProcessedSimpleFluent(_131139,withinArea(_131139,anchorage)=true,_131156),
     intersect_all([_131145,_131156],_131168),
     holdsForProcessedSimpleFluent(_131139,stopped(_131139)=nearPorts,_131178),
     union_all([_131168,_131178],_131189),
     thresholds(aOrMTime,_131199),
     intDurGreater(_131189,_131199,_131124).

holdsForSDFluent(tugging(_131139,_131140)=true,_131124) :-
     holdsForProcessedIE(_131139,proximity(_131139,_131140)=true,_131146),
     oneIsTug(_131139,_131140),
     \+oneIsPilot(_131139,_131140),
     \+twoAreTugs(_131139,_131140),
     holdsForProcessedSimpleFluent(_131139,tuggingSpeed(_131139)=true,_131180),
     holdsForProcessedSimpleFluent(_131140,tuggingSpeed(_131140)=true,_131191),
     intersect_all([_131146,_131180,_131191],_131202),
     thresholds(tuggingTime,_131214),
     intDurGreater(_131202,_131214,_131124).

holdsForSDFluent(rendezVous(_131139,_131140)=true,_131124) :-
     holdsForProcessedIE(_131139,proximity(_131139,_131140)=true,_131146),
     \+oneIsTug(_131139,_131140),
     \+oneIsPilot(_131139,_131140),
     holdsForProcessedSimpleFluent(_131139,lowSpeed(_131139)=true,_131174),
     holdsForProcessedSimpleFluent(_131140,lowSpeed(_131140)=true,_131185),
     holdsForProcessedSimpleFluent(_131139,stopped(_131139)=farFromPorts,_131196),
     holdsForProcessedSimpleFluent(_131140,stopped(_131140)=farFromPorts,_131207),
     union_all([_131174,_131196],_131218),
     union_all([_131185,_131207],_131228),
     intersect_all([_131218,_131228,_131146],_131238),
     _131238\=[],
     holdsForProcessedSimpleFluent(_131139,withinArea(_131139,nearPorts)=true,_131256),
     holdsForProcessedSimpleFluent(_131140,withinArea(_131140,nearPorts)=true,_131268),
     holdsForProcessedSimpleFluent(_131139,withinArea(_131139,nearCoast)=true,_131280),
     holdsForProcessedSimpleFluent(_131140,withinArea(_131140,nearCoast)=true,_131292),
     relative_complement_all(_131238,[_131256,_131268,_131280,_131292],_131305),
     thresholds(rendezvousTime,_131319),
     intDurGreater(_131305,_131319,_131124).

holdsForSDFluent(trawling(_131139)=true,_131124) :-
     holdsForProcessedSimpleFluent(_131139,trawlSpeed(_131139)=true,_131145),
     holdsForProcessedSimpleFluent(_131139,trawlingMovement(_131139)=true,_131156),
     intersect_all([_131145,_131156],_131167),
     thresholds(trawlingTime,_131177),
     intDurGreater(_131167,_131177,_131124).

holdsForSDFluent(inSAR(_131139)=true,_131124) :-
     holdsForProcessedSimpleFluent(_131139,sarSpeed(_131139)=true,_131145),
     holdsForProcessedSimpleFluent(_131139,sarMovement(_131139)=true,_131156),
     intersect_all([_131145,_131156],_131167),
     intDurGreater(_131167,3600,_131124).

holdsForSDFluent(loitering(_131139)=true,_131124) :-
     holdsForProcessedSimpleFluent(_131139,lowSpeed(_131139)=true,_131145),
     holdsForProcessedSimpleFluent(_131139,stopped(_131139)=farFromPorts,_131156),
     union_all([_131145,_131156],_131167),
     holdsForProcessedSimpleFluent(_131139,withinArea(_131139,nearCoast)=true,_131177),
     holdsForProcessedSDFluent(_131139,anchoredOrMoored(_131139)=true,_131189),
     relative_complement_all(_131167,[_131177,_131189],_131201),
     thresholds(loiteringTime,_131211),
     intDurGreater(_131201,_131211,_131124).

holdsForSDFluent(pilotOps(_131139,_131140)=true,_131124) :-
     holdsForProcessedIE(_131139,proximity(_131139,_131140)=true,_131146),
     oneIsPilot(_131139,_131140),
     holdsForProcessedSimpleFluent(_131139,lowSpeed(_131139)=true,_131164),
     holdsForProcessedSimpleFluent(_131140,lowSpeed(_131140)=true,_131175),
     holdsForProcessedSimpleFluent(_131139,stopped(_131139)=farFromPorts,_131186),
     holdsForProcessedSimpleFluent(_131140,stopped(_131140)=farFromPorts,_131197),
     union_all([_131164,_131186],_131208),
     union_all([_131175,_131197],_131218),
     intersect_all([_131208,_131218,_131146],_131228),
     _131228\=[],
     holdsForProcessedSimpleFluent(_131139,withinArea(_131139,nearCoast)=true,_131246),
     holdsForProcessedSimpleFluent(_131140,withinArea(_131140,nearCoast)=true,_131258),
     relative_complement_all(_131228,[_131246,_131258],_131124).

cachingOrder2(_131123, withinArea(_131123,_131124)=true) :-
     vessel(_131123),areaType(_131124).

cachingOrder2(_131123, gap(_131123)=nearPorts) :-
     vessel(_131123),portStatus(nearPorts).

cachingOrder2(_131123, gap(_131123)=farFromPorts) :-
     vessel(_131123),portStatus(farFromPorts).

cachingOrder2(_131123, stopped(_131123)=nearPorts) :-
     vessel(_131123),portStatus(nearPorts).

cachingOrder2(_131123, stopped(_131123)=farFromPorts) :-
     vessel(_131123),portStatus(farFromPorts).

cachingOrder2(_131123, lowSpeed(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, changingSpeed(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, movingSpeed(_131123)=below) :-
     vessel(_131123),movingStatus(below).

cachingOrder2(_131123, movingSpeed(_131123)=above) :-
     vessel(_131123),movingStatus(above).

cachingOrder2(_131123, movingSpeed(_131123)=normal) :-
     vessel(_131123),movingStatus(normal).

cachingOrder2(_131123, underWay(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, highSpeedNearCoast(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, drifting(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, sarSpeed(_131123)=true) :-
     vessel(_131123),vesselType(_131123,sar).

cachingOrder2(_131123, sarMovement(_131123)=true) :-
     vessel(_131123),vesselType(_131123,sar).

cachingOrder2(_131123, inSAR(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, anchoredOrMoored(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, tuggingSpeed(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, tugging(_131123,_131124)=true) :-
     vpair(_131123,_131124).

cachingOrder2(_131123, rendezVous(_131123,_131124)=true) :-
     vpair(_131123,_131124).

cachingOrder2(_131123, pilotOps(_131123,_131124)=true) :-
     vpair(_131123,_131124).

cachingOrder2(_131123, trawlSpeed(_131123)=true) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, trawlingMovement(_131123)=true) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, trawling(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, loitering(_131123)=true) :-
     vessel(_131123).

cachingOrder2(_131123, fishingTripStatus(_131123)=null) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, fishingTripStatus(_131123)=aomni) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, fishingTripStatus(_131123)=aomi) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, fishingTripStatus(_131123)=underWay) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, fishingTripStatus(_131123)=trawling) :-
     vessel(_131123),vesselType(_131123,fishing).

cachingOrder2(_131123, fishingTripStatus(_131123)=interrupted) :-
     vessel(_131123),vesselType(_131123,fishing).

collectIntervals2(_131123, proximity(_131123,_131124)=true) :-
     vpair(_131123,_131124).

% Original deadlines were =1800
initDeadlines(Mult) :- 
    SarMovementDeadline is Mult * 1800,
    nb_setval(sarMovementDeadline, SarMovementDeadline),
    %thresholds(trawlingCrs,Thr), %1800
    TrawlingMovementDeadline is Mult * 1800,
    nb_setval(trawlingMovementDeadline, TrawlingMovementDeadline).

%maxDurationUE(trawlingMovement(_131176)=true,trawlingMovement(_131176)=false,_131150) :- 
%     thresholds(trawlingCrs,_131150),grounding(trawlingMovement(_131176)=true).

%maxDurationUE(sarMovement(_131176)=true,sarMovement(_131176)=false,1800) :- 
%     grounding(sarMovement(_131176)=true).

