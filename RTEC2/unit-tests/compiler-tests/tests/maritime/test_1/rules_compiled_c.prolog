:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(withinArea(_131567,_131568)=true, _131587, _131550, _131589) :-
     user:happensAt(entersArea(_131567,_131580),_131550),
     user:areaType(_131580,_131568).

initiatedAt(gap(_131567)=nearPorts, _131591, _131550, _131593) :-
     user:happensAt(gap_start(_131567),_131550),
     user:holdsAt(withinArea(_131567,nearPorts)=true,_131550).

initiatedAt(gap(_131567)=farFromPorts, _131593, _131550, _131595) :-
     user:happensAt(gap_start(_131567),_131550),
     \+user:holdsAt(withinArea(_131567,nearPorts)=true,_131550).

initiatedAt(stopped(_131567)=nearPorts, _131591, _131550, _131593) :-
     user:happensAt(stop_start(_131567),_131550),
     user:holdsAt(withinArea(_131567,nearPorts)=true,_131550).

initiatedAt(stopped(_131567)=farFromPorts, _131593, _131550, _131595) :-
     user:happensAt(stop_start(_131567),_131550),
     \+user:holdsAt(withinArea(_131567,nearPorts)=true,_131550).

initiatedAt(lowSpeed(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(slow_motion_start(_131567),_131550).

initiatedAt(changingSpeed(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(change_in_speed_start(_131567),_131550).

initiatedAt(highSpeedNearCoast(_131567)=true, _131615, _131550, _131617) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(hcNearCoastMax,_131590),
     \+user:inRange(_131579,0,_131590),
     user:holdsAt(withinArea(_131567,nearCoast)=true,_131550).

initiatedAt(movingSpeed(_131567)=below, _131618, _131550, _131620) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:vesselType(_131567,_131590),
     user:typeSpeed(_131590,_131599,_131600,_131601),
     user:thresholds(movingMin,_131610),
     user:inRange(_131579,_131610,_131599).

initiatedAt(movingSpeed(_131567)=normal, _131609, _131550, _131611) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:vesselType(_131567,_131590),
     user:typeSpeed(_131590,_131599,_131600,_131601),
     user:inRange(_131579,_131599,_131600).

initiatedAt(movingSpeed(_131567)=above, _131609, _131550, _131611) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:vesselType(_131567,_131590),
     user:typeSpeed(_131590,_131599,_131600,_131601),
     user:inRange(_131579,_131600,inf).

initiatedAt(drifting(_131567)=true, _131633, _131550, _131635) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user: (_131581=\= 511.0000000000000000),
     user:absoluteAngleDiff(_131580,_131581,_131603),
     user:thresholds(adriftAngThr,_131612),
     user: (_131603>_131612),
     user:holdsAt(underWay(_131567)=true,_131550).

initiatedAt(tuggingSpeed(_131567)=true, _131607, _131550, _131609) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(tuggingMin,_131590),
     user:thresholds(tuggingMax,_131599),
     user:inRange(_131579,_131590,_131599).

initiatedAt(trawlSpeed(_131567)=true, _131622, _131550, _131624) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(trawlspeedMin,_131590),
     user:thresholds(trawlspeedMax,_131599),
     user:inRange(_131579,_131590,_131599),
     user:holdsAt(withinArea(_131567,fishing)=true,_131550).

initiatedAt(trawlingMovement(_131567)=true, _131591, _131550, _131593) :-
     user:happensAt(change_in_heading(_131567),_131550),
     user:holdsAt(withinArea(_131567,fishing)=true,_131550).

initiatedAt(sarSpeed(_131567)=true, _131598, _131550, _131600) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(sarMinSpeed,_131590),
     user:inRange(_131579,_131590,inf).

initiatedAt(sarMovement(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(change_in_heading(_131567),_131550).

initiatedAt(sarMovement(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(changingSpeed(_131567)=true),_131550).

terminatedAt(withinArea(_131567,_131568)=true, _131587, _131550, _131589) :-
     user:happensAt(leavesArea(_131567,_131580),_131550),
     user:areaType(_131580,_131568).

terminatedAt(withinArea(_131567,_131568)=true, _131577, _131550, _131579) :-
     user:happensAt(gap_start(_131567),_131550).

terminatedAt(gap(_131567)=_131553, _131576, _131550, _131578) :-
     user:happensAt(gap_end(_131567),_131550).

terminatedAt(stopped(_131567)=_131553, _131576, _131550, _131578) :-
     user:happensAt(stop_end(_131567),_131550).

terminatedAt(stopped(_131567)=_131553, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(lowSpeed(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(slow_motion_end(_131567),_131550).

terminatedAt(lowSpeed(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(changingSpeed(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(change_in_speed_end(_131567),_131550).

terminatedAt(changingSpeed(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(highSpeedNearCoast(_131567)=true, _131598, _131550, _131600) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(hcNearCoastMax,_131590),
     user:inRange(_131579,0,_131590).

terminatedAt(highSpeedNearCoast(_131567)=true, _131582, _131550, _131584) :-
     user:happensAt(end(withinArea(_131567,nearCoast)=true),_131550).

terminatedAt(movingSpeed(_131567)=_131553, _131600, _131550, _131602) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(movingMin,_131590),
     \+user:inRange(_131579,_131590,inf).

terminatedAt(movingSpeed(_131567)=_131553, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(drifting(_131567)=true, _131607, _131550, _131609) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:absoluteAngleDiff(_131580,_131581,_131591),
     user:thresholds(adriftAngThr,_131600),
     user: (_131591=<_131600).

terminatedAt(drifting(_131567)=true, _131582, _131550, _131584) :-
     user:happensAt(velocity(_131567,_131576,_131577,511.0000000000000000),_131550).

terminatedAt(drifting(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(end(underWay(_131567)=true),_131550).

terminatedAt(tuggingSpeed(_131567)=true, _131609, _131550, _131611) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(tuggingMin,_131590),
     user:thresholds(tuggingMax,_131599),
     \+user:inRange(_131579,_131590,_131599).

terminatedAt(tuggingSpeed(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(trawlSpeed(_131567)=true, _131609, _131550, _131611) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(trawlspeedMin,_131590),
     user:thresholds(trawlspeedMax,_131599),
     \+user:inRange(_131579,_131590,_131599).

terminatedAt(trawlSpeed(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(trawlSpeed(_131567)=true, _131582, _131550, _131584) :-
     user:happensAt(end(withinArea(_131567,fishing)=true),_131550).

terminatedAt(trawlingMovement(_131567)=true, _131582, _131550, _131584) :-
     user:happensAt(end(withinArea(_131567,fishing)=true),_131550).

terminatedAt(sarSpeed(_131567)=true, _131598, _131550, _131600) :-
     user:happensAt(velocity(_131567,_131579,_131580,_131581),_131550),
     user:thresholds(sarMinSpeed,_131590),
     user:inRange(_131579,0,_131590).

terminatedAt(sarSpeed(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

terminatedAt(sarMovement(_131567)=true, _131581, _131550, _131583) :-
     user:happensAt(start(gap(_131567)=_131578),_131550).

holdsForSDFluent(underWay(_131567)=true,_131550) :-
     user:holdsFor(movingSpeed(_131567)=below,_131576),
     user:holdsFor(movingSpeed(_131567)=normal,_131590),
     user:holdsFor(movingSpeed(_131567)=above,_131604),
     user:union_all([_131576,_131590,_131604],_131550).

holdsForSDFluent(anchoredOrMoored(_131567)=true,_131550) :-
     user:holdsFor(stopped(_131567)=farFromPorts,_131576),
     user:holdsFor(withinArea(_131567,anchorage)=true,_131590),
     user:intersect_all([_131576,_131590],_131605),
     user:holdsFor(stopped(_131567)=nearPorts,_131618),
     user:union_all([_131605,_131618],_131632),
     user:thresholds(aOrMTime,_131645),
     user:intDurGreater(_131632,_131645,_131550).

holdsForSDFluent(tugging(_131567,_131568)=true,_131550) :-
     user:holdsFor(proximity(_131567,_131568)=true,_131577),
     user:oneIsTug(_131567,_131568),
     \+user:oneIsPilot(_131567,_131568),
     \+user:twoAreTugs(_131567,_131568),
     user:holdsFor(tuggingSpeed(_131567)=true,_131623),
     user:holdsFor(tuggingSpeed(_131568)=true,_131637),
     user:intersect_all([_131577,_131623,_131637],_131651),
     user:thresholds(tuggingTime,_131666),
     user:intDurGreater(_131651,_131666,_131550).

holdsForSDFluent(rendezVous(_131567,_131568)=true,_131550) :-
     user:holdsFor(proximity(_131567,_131568)=true,_131577),
     \+user:oneIsTug(_131567,_131568),
     \+user:oneIsPilot(_131567,_131568),
     user:holdsFor(lowSpeed(_131567)=true,_131614),
     user:holdsFor(lowSpeed(_131568)=true,_131628),
     user:holdsFor(stopped(_131567)=farFromPorts,_131642),
     user:holdsFor(stopped(_131568)=farFromPorts,_131656),
     user:union_all([_131614,_131642],_131670),
     user:union_all([_131628,_131656],_131683),
     user:intersect_all([_131670,_131683,_131577],_131696),
     user: (_131696\=[]),
     user:holdsFor(withinArea(_131567,nearPorts)=true,_131720),
     user:holdsFor(withinArea(_131568,nearPorts)=true,_131735),
     user:holdsFor(withinArea(_131567,nearCoast)=true,_131750),
     user:holdsFor(withinArea(_131568,nearCoast)=true,_131765),
     user:relative_complement_all(_131696,[_131720,_131735,_131750,_131765],_131781),
     user:thresholds(rendezvousTime,_131798),
     user:intDurGreater(_131781,_131798,_131550).

holdsForSDFluent(trawling(_131567)=true,_131550) :-
     user:holdsFor(trawlSpeed(_131567)=true,_131576),
     user:holdsFor(trawlingMovement(_131567)=true,_131590),
     user:intersect_all([_131576,_131590],_131604),
     user:thresholds(trawlingTime,_131617),
     user:intDurGreater(_131604,_131617,_131550).

holdsForSDFluent(inSAR(_131567)=true,_131550) :-
     user:holdsFor(sarSpeed(_131567)=true,_131576),
     user:holdsFor(sarMovement(_131567)=true,_131590),
     user:intersect_all([_131576,_131590],_131604),
     user:intDurGreater(_131604,3600,_131550).

holdsForSDFluent(loitering(_131567)=true,_131550) :-
     user:holdsFor(lowSpeed(_131567)=true,_131576),
     user:holdsFor(stopped(_131567)=farFromPorts,_131590),
     user:union_all([_131576,_131590],_131604),
     user:holdsFor(withinArea(_131567,nearCoast)=true,_131617),
     user:holdsFor(anchoredOrMoored(_131567)=true,_131632),
     user:relative_complement_all(_131604,[_131617,_131632],_131647),
     user:thresholds(loiteringTime,_131660),
     user:intDurGreater(_131647,_131660,_131550).

holdsForSDFluent(pilotOps(_131567,_131568)=true,_131550) :-
     user:holdsFor(proximity(_131567,_131568)=true,_131577),
     user:oneIsPilot(_131567,_131568),
     user:holdsFor(lowSpeed(_131567)=true,_131601),
     user:holdsFor(lowSpeed(_131568)=true,_131615),
     user:holdsFor(stopped(_131567)=farFromPorts,_131629),
     user:holdsFor(stopped(_131568)=farFromPorts,_131643),
     user:union_all([_131601,_131629],_131657),
     user:union_all([_131615,_131643],_131670),
     user:intersect_all([_131657,_131670,_131577],_131683),
     user: (_131683\=[]),
     user:holdsFor(withinArea(_131567,nearCoast)=true,_131707),
     user:holdsFor(withinArea(_131568,nearCoast)=true,_131722),
     user:relative_complement_all(_131683,[_131707,_131722],_131550).

cachingOrder2(_131549, withinArea(_131549,_131550)=true) :-
     user:vessel(_131549),user:areaType(_131550).

cachingOrder2(_131549, gap(_131549)=nearPorts) :-
     user:vessel(_131549),user:portStatus(nearPorts).

cachingOrder2(_131549, gap(_131549)=farFromPorts) :-
     user:vessel(_131549),user:portStatus(farFromPorts).

cachingOrder2(_131549, stopped(_131549)=nearPorts) :-
     user:vessel(_131549),user:portStatus(nearPorts).

cachingOrder2(_131549, stopped(_131549)=farFromPorts) :-
     user:vessel(_131549),user:portStatus(farFromPorts).

cachingOrder2(_131549, lowSpeed(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, changingSpeed(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, movingSpeed(_131549)=below) :-
     user:vessel(_131549),user:movingStatus(below).

cachingOrder2(_131549, movingSpeed(_131549)=above) :-
     user:vessel(_131549),user:movingStatus(above).

cachingOrder2(_131549, movingSpeed(_131549)=normal) :-
     user:vessel(_131549),user:movingStatus(normal).

cachingOrder2(_131549, underWay(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, highSpeedNearCoast(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, drifting(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, sarSpeed(_131549)=true) :-
     user:vessel(_131549),user:vesselType(_131549,sar).

cachingOrder2(_131549, sarMovement(_131549)=true) :-
     user:vessel(_131549),user:vesselType(_131549,sar).

cachingOrder2(_131549, inSAR(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, anchoredOrMoored(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, tuggingSpeed(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, tugging(_131549,_131550)=true) :-
     user:vpair(_131549,_131550).

cachingOrder2(_131549, rendezVous(_131549,_131550)=true) :-
     user:vpair(_131549,_131550).

cachingOrder2(_131549, pilotOps(_131549,_131550)=true) :-
     user:vpair(_131549,_131550).

cachingOrder2(_131549, trawlSpeed(_131549)=true) :-
     user:vessel(_131549),user:vesselType(_131549,fishing).

cachingOrder2(_131549, trawlingMovement(_131549)=true) :-
     user:vessel(_131549),user:vesselType(_131549,fishing).

cachingOrder2(_131549, trawling(_131549)=true) :-
     user:vessel(_131549).

cachingOrder2(_131549, loitering(_131549)=true) :-
     user:vessel(_131549).

collectIntervals2(_131549, proximity(_131549,_131550)=true) :-
     user:vpair(_131549,_131550).
