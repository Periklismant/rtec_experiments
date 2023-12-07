initially(punctuality(_, _)=punctual).

initiatedAt(punctuality(Id, VehicleType)=punctual, T) :-
	happensAt(stop_enter(Id, VehicleType, _StopCode, scheduled), T).	

initiatedAt(punctuality(Id, VehicleType)=punctual, T) :-
	happensAt(stop_enter(Id, VehicleType, _StopCode, early), T).	

initiatedAt(punctuality(Id, VehicleType)=non_punctual, T) :-
	happensAt(stop_enter(Id, VehicleType, _StopCode, late), T).

initiatedAt(punctuality(Id, VehicleType)=non_punctual, T) :-
	happensAt(stop_leave(Id, VehicleType, _StopCode, early), T).

holdsFor(punctuality(Id, VehicleType)=non_punctual, NPI) :-
	holdsFor(punctuality(Id, VehicleType)=punctual, PI),
	complement_all([PI], NPI).

happensAt(punctuality_change(Id, VehicleType, punctual), T) :-
	happensAt(end(punctuality(Id, VehicleType)=non_punctual), T).	

happensAt(punctuality_change(Id, VehicleType, non_punctual), T) :-
	happensAt(end(punctuality(Id, VehicleType)=punctual), T).	

holdsFor(driving_style(Id, VehicleType)=unsafe, UDI) :-
	holdsFor(sharp_turn(Id, VehicleType)=very_sharp, VSTI),
	holdsFor(abrupt_acceleration(Id, VehicleType)=very_abrupt, VAAI),
	holdsFor(abrupt_deceleration(Id, VehicleType)=very_abrupt, VADI),
	union_all([VSTI, VAAI, VADI], UDI).

holdsFor(driving_style(Id, VehicleType)=uncomfortable, UDI) :-
	holdsFor(sharp_turn(Id, VehicleType)=sharp, STI),
	holdsFor(abrupt_acceleration(Id, VehicleType)=very_abrupt, VAAI),
	holdsFor(abrupt_deceleration(Id, VehicleType)=very_abrupt, VADI),  
	relative_complement_all(STI, [VAAI, VADI], PureSharpTurn),
	holdsFor(abrupt_acceleration(Id, VehicleType)=abrupt, AAI),
	holdsFor(abrupt_deceleration(Id, VehicleType)=abrupt, ADI),
	union_all([PureSharpTurn, AAI, ADI], UDI).

