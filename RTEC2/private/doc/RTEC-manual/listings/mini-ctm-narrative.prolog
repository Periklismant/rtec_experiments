updateSDE( 0,60 ) :-
updateSDE( abrupt_acceleration, 0, 60 ),
updateSDE( abrupt_deceleration, 0, 60 ),
updateSDE( sharp_turn, 0, 60 ),
updateSDE( stop_enter_leave, 0, 60 ).

updateSDE( abrupt_acceleration, 0, 60 ) :-
assert( holdsForIESI( abrupt_acceleration(75, bus)=abrupt, (5, 8)) ),
assert( holdsForIESI( abrupt_acceleration(75, bus)=abrupt, (10, 13)) ),
assert( holdsForIESI( abrupt_acceleration(76, bus)=abrupt, (19, 23)) ),
assert( holdsForIESI( abrupt_acceleration(77, bus)=abrupt, (28, 33)) ),
assert( holdsForIESI( abrupt_acceleration(78, bus)=very_abrupt, (34, 36)) ),
assert( holdsForIESI( abrupt_acceleration(79, bus)=abrupt, (43, 47)) ),
assert( holdsForIESI( abrupt_acceleration(79, bus)=very_abrupt, (50, 57)) ).

updateSDE( abrupt_deceleration, 0, 60 ) :-
assert( holdsForIESI( abrupt_deceleration(75, bus)=very_abrupt, (6, 9)) ),
assert( holdsForIESI( abrupt_deceleration(75, bus)=abrupt, (15, 17)) ),
assert( holdsForIESI( abrupt_deceleration(76, bus)=abrupt, (23, 25)) ),
assert( holdsForIESI( abrupt_deceleration(77, bus)=abrupt, (26, 28)) ),
assert( holdsForIESI( abrupt_deceleration(78, bus)=abrupt, (36, 39)) ),
assert( holdsForIESI( abrupt_deceleration(79, bus)=abrupt, (44, 48)) ),
assert( holdsForIESI( abrupt_deceleration(79, bus)=abrupt, (51, 56)) ).

updateSDE( sharp_turn, 0, 60 ) :-
assert( holdsForIESI( sharp_turn(75, bus)=sharp, (5, 8)) ),
assert( holdsForIESI( sharp_turn(75, bus)=very_sharp, (14, 16)) ),
assert( holdsForIESI( sharp_turn(76, bus)=very_sharp, (19, 24)) ),
assert( holdsForIESI( sharp_turn(77, bus)=sharp, (31, 33)) ),
assert( holdsForIESI( sharp_turn(78, bus)=very_sharp, (38, 40)) ),
assert( holdsForIESI( sharp_turn(79, bus)=sharp, (47, 49)) ),
assert( holdsForIESI( sharp_turn(79, bus)=very_sharp, (52, 57)) ).

updateSDE( stop_enter_leave, 0, 60 ) :-
assert( happensAtIE( stop_enter(75, bus, 003, early), 1) ),
assert( happensAtIE( stop_leave(75, bus, 003, scheduled), 5) ),
assert( happensAtIE( stop_enter(75, bus, 0017, early), 14) ),
assert( happensAtIE( stop_leave(75, bus, 0017, late), 20) ),
assert( happensAtIE( stop_enter(76, bus, 0025, late), 22) ),
assert( happensAtIE( stop_leave(76, bus, 0025, scheduled), 23) ),
assert( happensAtIE( stop_enter(77, bus, 0031, early), 29) ),
assert( happensAtIE( stop_leave(77, bus, 0031, late), 37) ),
assert( happensAtIE( stop_enter(78, bus, 0040, scheduled), 40) ),
assert( happensAtIE( stop_leave(78, bus, 0040, late), 45) ),
assert( happensAtIE( stop_enter(79, bus, 0049, late), 48) ),
assert( happensAtIE( stop_leave(79, bus, 0049, scheduled), 49) ),
assert( happensAtIE( stop_enter(79, bus, 0056, scheduled), 53) ),
assert( happensAtIE( stop_leave(79, bus, 0056, late), 58) ).

