
%----------------within area -----------------%

initiatedAt(withinArea(Vessel, AreaType)=true, T) :-
    happensAt(entersArea(Vessel, Area), T),
    areaType(Area, AreaType).

terminatedAt(withinArea(Vessel, AreaType)=true, T) :-
    happensAt(leavesArea(Vessel, Area), T),
    areaType(Area, AreaType).

terminatedAt(withinArea(Vessel, _AreaType)=true, T) :-
    happensAt(gap_start(Vessel), T).


%--------------- communication gap -----------%

initiatedAt(gap(Vessel)=nearPorts, T) :-
    happensAt(gap_start(Vessel), T),
    holdsAt(withinArea(Vessel, nearPorts)=true, T).

initiatedAt(gap(Vessel)=farFromPorts, T) :-
    happensAt(gap_start(Vessel), T),
    \+holdsAt(withinArea(Vessel, nearPorts)=true, T).

terminatedAt(gap(Vessel)=_PortStatus, T) :-
    happensAt(gap_end(Vessel), T).

%-------------- changingSpeed ----------------%

initiatedAt(changingSpeed(Vessel)=true, T) :-  
    happensAt(change_in_speed_start(Vessel), T).

terminatedAt(changingSpeed(Vessel)=true, T) :-
    happensAt(change_in_speed_end(Vessel), T).

terminatedAt(changingSpeed(Vessel)=true, T) :-
    happensAt(start(gap(Vessel)=_Status), T).

%---------------- trawlSpeed -----------------%

initiatedAt(trawlSpeed(Vessel)=true, T):-
    %vesselType(Vessel, fishing),
    happensAt(velocity(Vessel, Speed, _Heading,_), T),
    thresholds(trawlspeedMin, TrawlspeedMin),
    thresholds(trawlspeedMax, TrawlspeedMax),
    inRange(Speed, TrawlspeedMin, TrawlspeedMax),
    holdsAt(withinArea(Vessel, fishing)=true, T).

terminatedAt(trawlSpeed(Vessel)=true, T):-
    %vesselType(Vessel, fishing),
    happensAt(velocity(Vessel, Speed, _Heading,_), T),
    thresholds(trawlspeedMin, TrawlspeedMin),
    thresholds(trawlspeedMax, TrawlspeedMax),
    \+inRange(Speed, TrawlspeedMin, TrawlspeedMax).

terminatedAt(trawlSpeed(Vessel)=true, T):-
    happensAt(start(gap(Vessel)=_Status), T).

terminatedAt(trawlSpeed(Vessel)=true, T):-
    happensAt(end(withinArea(Vessel, fishing)=true), T).


%--------------- trawling --------------------%

initiatedAt(trawlingMovement(Vessel)=true , T):-
    %vesselType(Vessel, fishing),
    happensAt(change_in_heading(Vessel), T),
    holdsAt(withinArea(Vessel, fishing)=true, T).

terminatedAt(trawlingMovement(Vessel)=true, T):-
    happensAt(end(withinArea(Vessel, fishing)=true), T).

fi(trawlingMovement(Vessel)=true, trawlingMovement(Vessel)=false, TrawlingCrs):-
	thresholds(trawlingCrs, TrawlingCrs).
p(trawlingMovement(_Vessel)=true).

holdsFor(trawling(Vessel)=true, I):-
    holdsFor(trawlSpeed(Vessel)=true, It),
    holdsFor(trawlingMovement(Vessel)=true, Itc),
    intersect_all([It, Itc], Ii),
    thresholds(trawlingTime, TrawlingTime),
    intDurGreater(Ii, TrawlingTime, I).

%-------------------------- SAR --------------%

initiatedAt(sarSpeed(Vessel)=true , T):-
    %vesselType(Vessel, sar),
    happensAt(velocity(Vessel, Speed, _, _), T),
    thresholds(sarMinSpeed, SarMinSpeed),
    inRange(Speed,SarMinSpeed,inf).

terminatedAt(sarSpeed(Vessel)=true, T):-
    %vesselType(Vessel, sar),
    happensAt(velocity(Vessel, Speed, _, _), T),
    thresholds(sarMinSpeed, SarMinSpeed),
    inRange(Speed,0,SarMinSpeed).

terminatedAt(sarSpeed(Vessel)=true, T):-
    happensAt(start(gap(Vessel)=_Status), T).

initiatedAt(sarMovement(Vessel)=true, T):-
    %vesselType(Vessel, sar),
    happensAt(change_in_heading(Vessel), T).

initiatedAt(sarMovement(Vessel)=true , T):-
    %vesselType(Vessel, sar),
    happensAt(start(changingSpeed(Vessel)=true), T).

terminatedAt(sarMovement(Vessel)=true, T):-
    %vesselType(Vessel, sar),
    happensAt(start(gap(Vessel)=_Status), T).

fi(sarMovement(Vessel)=true, sarMovement(Vessel)=false, 1800).
p(sarMovement(_Vessel)=true).

holdsFor(inSAR(Vessel)=true, I):-
    holdsFor(sarSpeed(Vessel)=true, Iss),
    holdsFor(sarMovement(Vessel)=true, Isc),
    intersect_all([Iss, Isc], Ii),
    intDurGreater(Ii, 3600, I).

% proximity is an input statically determined fluent.
% its instances arrive in the form of intervals.
collectIntervals(proximity(_,_)=true).

% The elements of these domains are derived from the ground arguments of input entitites
dynamicDomain(vessel(_Vessel)).
dynamicDomain(vpair(_Vessel1,_Vessel2)).

% Groundings of input entities
grounding(change_in_speed_start(V)):- vessel(V).
grounding(change_in_speed_end(V)):- vessel(V).
grounding(change_in_heading(V)):- vessel(V).
grounding(stop_start(V)):- vessel(V).
grounding(stop_end(V)):- vessel(V).
grounding(slow_motion_start(V)):- vessel(V).
grounding(slow_motion_end(V)):- vessel(V).
grounding(gap_start(V)):- vessel(V).
grounding(gap_end(V)):- vessel(V).
grounding(entersArea(V,Area)):- vessel(V), areaType(Area).
grounding(leavesArea(V,Area)):- vessel(V), areaType(Area).
grounding(coord(V,_,_)):- vessel(V).
grounding(velocity(V,_,_,_)):- vessel(V).
grounding(proximity(Vessel1, Vessel2)=true):- vpair(Vessel1, Vessel2).

% Groundings of output entities
grounding(gap(Vessel)=PortStatus):-
	vessel(Vessel), portStatus(PortStatus).
grounding(changingSpeed(Vessel)=true):-
	vessel(Vessel).
grounding(withinArea(Vessel, AreaType)=true):-
	vessel(Vessel), areaType(AreaType).
grounding(sarSpeed(Vessel)=true):-
	vessel(Vessel), vesselType(Vessel,sar).
grounding(sarMovement(Vessel)=true):-
	vessel(Vessel), vesselType(Vessel,sar).
grounding(sarMovement(Vessel)=false):-
	vessel(Vessel), vesselType(Vessel,sar).
grounding(inSAR(Vessel)=true):-
	vessel(Vessel).
grounding(trawlSpeed(Vessel)=true):-
	vessel(Vessel), vesselType(Vessel,fishing).
grounding(trawlingMovement(Vessel)=true):-
	vessel(Vessel), vesselType(Vessel,fishing).
grounding(trawlingMovement(Vessel)=false):-
	vessel(Vessel), vesselType(Vessel,fishing).
grounding(trawling(Vessel)=true):-
	vessel(Vessel).

needsGrounding(_, _, _) :-
	fail.
buildFromPoints(_) :-
	fail.
